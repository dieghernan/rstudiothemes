#' Read and parse a Visual Studio Code/Positron theme
#'
#' @description
#' Read a `.json` file representing a Visual Studio Code/Positron theme.
#'
#' @param path Path or URL to a Visual Studio Code/Positron theme, in `.json`
#'   format.
#'
#' @inherit read_tm_theme return
#'
#' @family functions for reading themes
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
  # 0. Validate
  if (missing(path)) {
    cli::cli_abort("Argument {.arg path} can't be empty.")
  }

  if (tools::file_ext(path) != "json") {
    cli::cli_abort(
      paste0(
        "Argument {.arg path} should be a {.str json} file",
        " not {.str {tools::file_ext(path)}}."
      )
    )
  }

  # Check if the file is online
  if (grepl("^http", path)) {
    local_file <- tempfile(fileext = ".json")
    cli::cli_alert_info("Downloading from {.url {path}}")
    download.file(path, local_file, quiet = TRUE, mode = "wb")
  } else {
    local_file <- path
  }

  if (!file.exists(local_file)) {
    cli::cli_abort("File {.path {local_file}} does not exist.")
  }

  # 1. Read vscode and prepare
  vs <- jsonlite::read_json(local_file)

  vs <- rapply(vs, col2hex, how = "list")

  # Remove trailing and double whitespace

  vs <- rapply(
    vs,
    function(x) {
      x <- gsub("  ", " ", x, fixed = TRUE)
      x <- gsub("  ", " ", x, fixed = TRUE)

      trimws(x)
    },
    how = "list"
  )

  # High-level inputs
  name <- paste0(unlist(vs$name)[1], collapse = ", ")
  type <- paste0(unlist(vs$type)[1], collapse = ", ")
  author <- paste0(unlist(vs$author), collapse = ", ")

  top_df <- dplyr::tibble(
    value = c(name, author, type)
  )

  top_df$section <- "highlevel"
  top_df$name <- c("name", "author", "type")

  # Process semantic token colors if present
  semantic_df <- NULL
  if ("semanticTokenColors" %in% names(vs)) {
    semantic_list <- vs$semanticTokenColors

    it <- seq_along(semantic_list)

    semantic_df <- lapply(it, function(i) {
      this_tok <- semantic_list[i]

      nm <- paste0("Semantic: ", names(this_tok))

      # Split into individual pieces (some JSONs provide them collapsed)
      scopes <- names(this_tok)
      scopes <- paste0(scopes, collapse = ",")
      scopes <- unlist(strsplit(scopes, ","))

      # Handle case where token has no named values
      vals <- unlist(this_tok[[1]])
      if (any(is.null(names(vals)))) {
        vals <- vals[1]
        names(vals) <- "foreground"
      }

      # Convert to data frame
      df_vals <- as.data.frame(t(vals))

      # Convert italic attribute to fontStyle
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

  # High-level color settings
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

  # Process token colors
  token_list <- vs$tokenColors
  token_list <- token_list[lengths(token_list) > 0]
  it <- seq_along(token_list)

  token_df <- lapply(it, function(i) {
    this_tok <- token_list[i][[1]]

    nm <- unlist(this_tok$name)
    if (is.null(nm)) {
      nm <- paste0("tokenColors ", i)
    }

    # Split into individual pieces (some JSONs provide them collapsed)
    scopes <- sort(unlist(this_tok$scope))
    scopes <- paste0(scopes, collapse = ",")
    scopes <- unlist(strsplit(scopes, ","))

    this_tok_df <- dplyr::tibble(
      name = nm,
      scope = scopes
    )

    this_set <- unlist(this_tok$settings)
    # Convert settings to data frame
    sett <- dplyr::as_tibble(t(this_set))

    this_tok_df <- dplyr::bind_cols(this_tok_df, sett)

    this_tok_df
  })

  token_df <- dplyr::bind_rows(token_df)
  token_df$section <- "tokenColors"

  # Combine all data frames
  final_df <- dplyr::bind_rows(top_df, settings_df, semantic_df, token_df)

  # Add missing columns if they do not exist
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
