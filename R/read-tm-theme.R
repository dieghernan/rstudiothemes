#' Read and parse a TextMate theme
#'
#' @description
#' Read a `*.tmTheme` file (really a `*.xml` file) representing a TextMate or
#' a Sublime Text theme.
#'
#' @param path Path to a TextMate theme, in `*.tmTheme` format.
#'
#' @returns
#' A [tibble][tibble::tbl_df()].
#'
#' @family reading
#'
#' @export
#'
#' @examples
#'
#' the_theme <- system.file("ext/test-color-theme.json",
#'   package = "rstudiothemes"
#' ) |>
#'   # Generate the theme
#'   convert_vs_to_tm_theme()
#'
#' # Check
#' readLines(the_theme) |>
#'   head(10) |>
#'   cat(sep = "\n")
#'
#' read_tm_theme(the_theme)
read_tm_theme <- function(path) {
  tm <- xml2::read_xml(path)
  tm <- xml2::as_list(tm)

  tm <- rapply(tm, col2hex, how = "list")

  # Remove trailings / double  whitespace
  tm <- rapply(
    tm,
    function(x) {
      x <- gsub("  ", " ", x, fixed = TRUE)
      x <- gsub("  ", " ", x, fixed = TRUE)

      trimws(x)
    },
    how = "list"
  )

  # 1. High level inputs -----
  specs <- tm$plist$dict
  # Not use the array, this is where the colors are
  highlev <- specs[names(specs) != "array"]

  # Strong assumption here! structure should be a list of consecutive
  # <key><string><key><string>...
  hl_keys <- unlist(highlev[names(highlev) == "key"])

  # Remove settings from keys
  hl_keys <- hl_keys[!hl_keys == "settings"]
  hl_values <- unlist(highlev[names(highlev) == "string"])

  # Ensure same length
  l_merged <- seq_len(min(length(hl_keys), length(hl_values)))

  top_df <- dplyr::tibble(
    section = "highlevel",
    name = unname(hl_keys)[l_merged],
    value = unname(hl_values)[l_merged]
  )

  # 2. Colors (Settings) ----
  array <- specs[names(specs) == "array"][[1]]

  # Identify high level settings since it should present only key and dict

  id_settings <- vapply(
    array,
    function(x) {
      nms <- sort(names(x))
      if (length(nms) == 2 && identical(nms, c("dict", "key"))) {
        return(TRUE)
      }
      FALSE
    },
    FUN.VALUE = logical(1)
  )

  settings_list <- array[id_settings][1]$dict$dict

  # Same assumptions

  sett_keys <- unlist(settings_list[names(settings_list) == "key"])
  sett_values <- unlist(settings_list[names(settings_list) == "string"])

  # Ensure same length
  l_set_merged <- seq_len(min(length(sett_keys), length(sett_values)))

  settings_df <- dplyr::tibble(
    section = "colors",
    name = unname(sett_keys)[l_set_merged],
    foreground = unname(sett_values)[l_set_merged]
  )

  # 3. Tokens ----
  token_list <- array[!id_settings]
  it <- seq_along(token_list)

  token_df <- lapply(it, function(i) {
    # Same assumptions

    this_tok <- token_list[i][[1]]

    tok_keys <- unlist(this_tok[names(this_tok) == "key"])

    # Remove settings from keys
    tok_keys <- tok_keys[!tok_keys == "settings"]
    tok_values_init <- this_tok[names(this_tok) == "string"]
    tok_values <- lapply(tok_values_init, function(y) {
      if (length(y) == 0) {
        return("")
      }

      unlist(y)
    })
    tok_values <- unlist(tok_values)

    # Ensure same length
    t_set_merged <- seq_len(min(length(tok_keys), length(tok_values)))
    tok_keys <- tok_keys[t_set_merged]
    tok_values <- tok_values[t_set_merged]
    names(tok_values) <- tok_keys

    nm <- tok_values["name"]
    scopes <- strsplit(tok_values["scope"], ",")
    scopes <- sort(trimws(unname(unlist(scopes))))

    tok_df <- dplyr::tibble(
      section = "tokenColors",
      name = nm,
      scope = scopes
    )

    # Dictionary
    dict <- lapply(this_tok$dict, function(x) {
      if (length(x) == 0) {
        return("NULL")
      }
      x
    })

    # Spec df
    if (length(dict) == 0) {
      df_spec <- dplyr::tibble(foreground = "")
    } else {
      # Spec df
      nm <- names(dict)
      val <- unlist(dict[nm == "string"])
      names(val) <- unlist(dict[nm == "key"])

      df_spec <- as.data.frame(t(val))
    }

    tok_df <- dplyr::bind_cols(tok_df, df_spec)
    tok_df
  })

  token_df <- dplyr::bind_rows(token_df)

  #  Final df
  final_df <- dplyr::bind_rows(top_df, settings_df, token_df)

  # Complete columns if doesn't exist
  if (!"background" %in% names(final_df)) {
    final_df$background <- NA
  }

  if (!"fontStyle" %in% names(final_df)) {
    final_df$fontStyle <- NA
  }

  nms <- unique(c(
    "section",
    "name",
    "scope",
    "value",
    "foreground",
    "background",
    "fontStyle",
    names(final_df)
  ))

  final_df <- final_df[, nms]

  # Blanks as NAs
  final_df[final_df == ""] <- NA

  # Filter un-defined
  undef <- is.na(final_df$value) &
    is.na(final_df$foreground) &
    is.na(final_df$background) &
    is.na(final_df$fontStyle)

  final_df[!undef, ]
}
