#' Read and parse a Visual Studio Code theme
#'
#' @description
#' Read a `*.json` file representing a Visual Studio Code theme.
#'
#' @param path Path to a Visual Studio Code theme, in `*.json` format.
#'
#' @returns
#' A [tibble::tibble()].
#'
#' @family reading
#'
#' @export
#'
#' @examples
#'
#' vstheme <- system.file("ext/test-color-theme.json",
#'   package = "rstudiothemes"
#' )
#' read_vs_theme(vstheme)
#'
read_vs_theme <- function(path) {
  # 1. Read vscode and prepare
  vs <- jsonlite::read_json(path)

  vs <- rapply(vs, col2hex, how = "list")

  # Remove trailings / double  whitespace

  vs <- rapply(
    vs,
    function(x) {
      x <- gsub("  ", " ", x, fixed = TRUE)
      x <- gsub("  ", " ", x, fixed = TRUE)

      trimws(x)
    },
    how = "list"
  )

  # High level inputs
  name <- paste0(unlist(vs$name)[1], collapse = ", ")
  type <- paste0(unlist(vs$type)[1], collapse = ", ")
  author <- paste0(unlist(vs$author), collapse = ", ")

  top_df <- dplyr::tibble(
    value = c(name, author, type)
  )

  top_df$section <- "highlevel"
  top_df$name <- c("name", "author", "type")

  semantic_df <- NULL
  if ("semanticTokenColors" %in% names(vs)) {
    semantic_list <- vs$semanticTokenColors

    it <- seq_along(semantic_list)

    semantic_df <- lapply(it, function(i) {
      this_tok <- semantic_list[i]

      nm <- paste0("Semantic: ", names(this_tok))

      # Split in individual pieces (some jsons provides it collapsed)
      scopes <- names(this_tok)
      scopes <- paste0(scopes, collapse = ",")
      scopes <- unlist(strsplit(scopes, ","))

      # Some issues for cobalt2
      vals <- unlist(this_tok[[1]])
      if (any(is.null(names(vals)))) {
        vals <- vals[1]
        names(vals) <- "foreground"
      }

      # To df
      df_vals <- as.data.frame(t(vals))

      # If italic then
      if ("italic" %in% names(df_vals)) {
        if (identical(df_vals$italic, "TRUE")) {
          df_vals$fontStyle <- "italic"
        }
        setdiff(names(df_vals), "italic")
        df_vals <- df_vals[, setdiff(names(df_vals), "italic")]
      }

      this_tok_df <- dplyr::tibble(
        name = nm,
        scope = scopes
      )
      this_tok_df <- dplyr::bind_cols(this_tok_df, df_vals)

      this_tok_df
    })

    semantic_df <- dplyr::bind_rows(semantic_df)
    semantic_df$section <- "semanticTokenColors"
  }

  # Colors (Settings)
  settings_list <- vs$colors

  it <- seq_along(settings_list)

  settings_df <- lapply(it, function(i) {
    x <- settings_list[i]
    val <- unlist(x)
    if (length(val) < 1) {
      val <- NA
    }
    dplyr::tibble(
      name = names(x),
      foreground = unname(val)
    )
  })

  settings_df <- dplyr::bind_rows(settings_df)
  settings_df$section <- "colors"

  # Token colors

  token_list <- vs$tokenColors
  it <- seq_along(token_list)

  token_df <- lapply(it, function(i) {
    this_tok <- token_list[i][[1]]

    nm <- unlist(this_tok$name)
    if (is.null(nm)) {
      nm <- paste0("tokenColors ", i)
    }

    # Split in individual pieces (some jsons provides it collapsed)
    scopes <- sort(unlist(this_tok$scope))
    scopes <- paste0(scopes, collapse = ",")
    scopes <- unlist(strsplit(scopes, ","))

    this_tok_df <- dplyr::tibble(
      name = nm,
      scope = scopes
    )

    this_set <- unlist(this_tok$settings)
    # Settings as df
    sett <- dplyr::as_tibble(t(this_set))

    this_tok_df <- dplyr::bind_cols(this_tok_df, sett)

    this_tok_df
  })

  token_df <- dplyr::bind_rows(token_df)
  token_df$section <- "tokenColors"

  #  Final df
  final_df <- dplyr::bind_rows(top_df, settings_df, semantic_df, token_df)

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
