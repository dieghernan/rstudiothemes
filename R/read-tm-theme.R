#' Read and parse a TextMate theme
#'
#' @description
#' Read a `.tmTheme` file (XML format) representing a TextMate or Sublime Text
#' theme.
#'
#' @param path Path or URL to a TextMate theme, in `.tmTheme` format.
#'
#' @return
#' A [tibble][tibble::tbl_df()] with the data of the theme.
#'
#' @family functions for reading themes
#' @encoding UTF-8
#' @export
#'
#' @examples
#' the_theme <- system.file("ext/test-color-theme.json",
#'   package = "rstudiothemes"
#' ) |>
#'   # Convert the Visual Studio Code theme to TextMate format.
#'   convert_vs_to_tm_theme()
#'
#' # Check the converted theme.
#' readLines(the_theme) |>
#'   head(10) |>
#'   cat(sep = "\n")
#'
#' read_tm_theme(the_theme)
read_tm_theme <- function(path) {
  # Validate inputs.
  if (missing(path)) {
    cli::cli_abort("The {.arg path} argument is required.")
  }

  if (tools::file_ext(path) != "tmTheme") {
    cli::cli_abort(paste0(
      "The {.arg path} argument must be a {.str tmTheme} file",
      ", not {.str {tools::file_ext(path)}}."
    ))
  }

  local_file <- local_theme_file(path, "tmTheme")

  tm <- xml2::read_xml(local_file)
  tm <- xml2::as_list(tm)

  tm <- rapply(tm, col2hex, how = "list")

  # Remove trailing and repeated whitespace.
  tm <- rapply(tm, normalize_theme_text, how = "list")

  # 1. High-level inputs -----
  specs <- tm$plist$dict
  # Skip the array because it contains color settings.
  highlev <- specs[names(specs) != "array"]

  # Assumption: structure is a consecutive list of <key><string> pairs
  # representing metadata like name, author, colorSpaceName, etc.
  hl_keys <- unlist(highlev[names(highlev) == "key"])

  # Remove settings from keys.
  hl_keys <- hl_keys[!hl_keys == "settings"]
  hl_values <- unlist(highlev[names(highlev) == "string"])

  # Ensure the same length.
  l_merged <- seq_len(min(length(hl_keys), length(hl_values)))

  top_df <- dplyr::tibble(
    section = "highlevel",
    name = unname(hl_keys)[l_merged],
    value = unname(hl_values)[l_merged]
  )

  # 2. High-level color settings ----
  array <- specs[names(specs) == "array"][[1]]

  # Identify high-level color settings by key and dictionary structure.
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

  # Extract keys and values with the same assumptions as high-level inputs.
  sett_keys <- unlist(settings_list[names(settings_list) == "key"])
  sett_values <- unlist(settings_list[names(settings_list) == "string"])

  # Ensure a matching length.
  l_set_merged <- seq_len(min(length(sett_keys), length(sett_values)))

  settings_df <- dplyr::tibble(
    section = "colors",
    name = unname(sett_keys)[l_set_merged],
    foreground = unname(sett_values)[l_set_merged]
  )

  # Validate the TextMate theme.
  minimal_keys <- c(
    "background",
    "caret",
    "foreground",
    "invisibles",
    "lineHighlight",
    "selection"
  )

  the_keys <- settings_df$name
  difs <- setdiff(minimal_keys, the_keys)
  if (length(difs) > 0) {
    cli::cli_abort(paste0(
      "TextMate theme in {.file {path}} is invalid. ",
      "Required setting{?/s} {.str {difs}} {?is/are} missing."
    ))
  }

  # 3. Token color scopes ----
  token_list <- array[!id_settings]
  it <- seq_along(token_list)

  token_df <- lapply(it, function(i) {
    # Use the same assumptions as the high-level inputs.
    this_tok <- token_list[i][[1]]

    tok_keys <- unlist(this_tok[names(this_tok) == "key"])

    # Exclude the settings key.
    tok_keys <- tok_keys[!tok_keys == "settings"]
    tok_values_init <- this_tok[names(this_tok) == "string"]
    tok_values <- lapply(tok_values_init, function(y) {
      if (length(y) == 0) {
        return("")
      }

      unlist(y)
    })
    tok_values <- unlist(tok_values)

    # Ensure a matching length.
    t_set_merged <- seq_len(min(length(tok_keys), length(tok_values)))
    tok_keys <- tok_keys[t_set_merged]
    tok_values <- tok_values[t_set_merged]
    names(tok_values) <- tok_keys

    nm <- tok_values["name"]
    scopes <- strsplit(tok_values["scope"], ",")
    scopes <- sort(trimws(unname(unlist(scopes))))

    tok_df <- dplyr::tibble(section = "tokenColors", name = nm, scope = scopes)

    # Extract color specifications from the dictionary.
    dict <- lapply(this_tok$dict, function(x) {
      if (length(x) == 0) {
        return("NULL")
      }
      x
    })

    # Convert specifications to a data frame.
    if (length(dict) == 0) {
      df_spec <- dplyr::tibble(foreground = "")
    } else {
      nm <- names(dict)
      val <- unlist(dict[nm == "string"])
      names(val) <- unlist(dict[nm == "key"])

      df_spec <- as.data.frame(t(val))
    }

    tok_df <- dplyr::bind_cols(tok_df, df_spec)
    tok_df
  })

  token_df <- dplyr::bind_rows(token_df)

  # Combine all data frames.
  final_df <- dplyr::bind_rows(top_df, settings_df, token_df)

  # Add missing columns if they do not exist.
  if (!"background" %in% names(final_df)) {
    final_df$background <- NA
  }

  if (!"fontStyle" %in% names(final_df)) {
    final_df$fontStyle <- NA
  }

  if (!"scope" %in% names(final_df)) {
    final_df$scope <- NA
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

  # Convert empty strings to NA.
  final_df[final_df == ""] <- NA

  # Filter out rows with no style information.
  undef <- is.na(final_df$value) &
    is.na(final_df$foreground) &
    is.na(final_df$background) &
    is.na(final_df$fontStyle)

  final_df[!undef, ]
}
