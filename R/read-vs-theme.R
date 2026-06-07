#' Read and parse a Visual Studio Code or Positron theme
#'
#' @description
#' Read a `.json` file representing a Visual Studio Code or Positron theme.
#'
#' @param path Path or URL to a Visual Studio Code or Positron theme, in
#'   `.json` format.
#'
#' @inherit read_tm_theme return
#'
#' @family functions for reading themes
#' @encoding UTF-8
#' @rdname read_vs_theme
#' @export
#'
#' @examples
#' vstheme <- system.file("ext/test-color-theme.json",
#'   package = "rstudiothemes"
#' )
#' read_vs_theme(vstheme)
#'
read_vs_theme <- function(path) {
  # Validate inputs.
  if (missing(path)) {
    cli::cli_abort("The {.arg path} argument is required.")
  }

  if (tools::file_ext(path) != "json") {
    cli::cli_abort(paste0(
      "The {.arg path} argument must be a {.str json} file",
      ", not {.str {tools::file_ext(path)}}."
    ))
  }

  local_file <- local_theme_file(path, "json")

  # Read and prepare the Visual Studio Code or Positron theme.
  vs <- safe_read_json(local_file)

  vs <- rapply(vs, col2hex, how = "list")

  # Remove trailing and repeated whitespace.
  vs <- rapply(vs, normalize_theme_text, how = "list")

  # Extract high-level inputs.
  name <- paste0(unlist(vs$name)[1], collapse = ", ")
  type <- paste0(unlist(vs$type)[1], collapse = ", ")
  author <- paste0(unlist(vs$author), collapse = ", ")

  top_df <- dplyr::tibble(value = c(name, author, type))

  top_df$section <- "highlevel"
  top_df$name <- c("name", "author", "type")

  # Process semantic token colors when present.
  semantic_df <- NULL
  if ("semanticTokenColors" %in% names(vs)) {
    semantic_list <- vs$semanticTokenColors

    it <- seq_along(semantic_list)

    semantic_df <- lapply(it, function(i) {
      this_tok <- semantic_list[i]

      nm <- paste0("Semantic: ", names(this_tok))

      # Split collapsed scopes into individual pieces.
      scopes <- names(this_tok)
      scopes <- paste0(scopes, collapse = ",")
      scopes <- unlist(strsplit(scopes, ","))

      # Handle tokens with no named values.
      vals <- unlist(this_tok[[1]])
      if (any(is.null(names(vals)))) {
        vals <- vals[1]
        names(vals) <- "foreground"
      }

      # Convert to a data frame.
      df_vals <- as.data.frame(t(vals))

      # Convert the italic attribute to fontStyle.
      if ("italic" %in% names(df_vals)) {
        if (identical(df_vals$italic, "TRUE")) {
          df_vals$fontStyle <- "italic"
        }
        setdiff(names(df_vals), "italic")
        df_vals <- df_vals[, setdiff(names(df_vals), "italic")]
      }

      this_tok_df <- dplyr::tibble(name = nm, scope = scopes)
      this_tok_df <- dplyr::bind_cols(this_tok_df, df_vals)

      this_tok_df
    })

    semantic_df <- dplyr::bind_rows(semantic_df)
    semantic_df$section <- "semanticTokenColors"
  }

  # Extract high-level color settings.
  settings_list <- vs$colors

  it <- seq_along(settings_list)

  settings_df <- lapply(it, function(i) {
    x <- settings_list[i]
    val <- unlist(x)
    if (length(val) < 1) {
      val <- NA
    }
    dplyr::tibble(name = names(x), foreground = unname(val))
  })

  settings_df <- dplyr::bind_rows(settings_df)
  settings_df$section <- "colors"

  # Process token colors.
  token_list <- vs$tokenColors
  token_list <- token_list[lengths(token_list) > 0]
  it <- seq_along(token_list)

  token_df <- lapply(it, function(i) {
    this_tok <- token_list[i][[1]]

    nm <- unlist(this_tok$name)
    if (is.null(nm)) {
      nm <- paste0("tokenColors ", i)
    }

    # Split collapsed scopes into individual pieces.
    scopes <- sort(unlist(this_tok$scope))
    scopes <- paste0(scopes, collapse = ",")
    scopes <- unlist(strsplit(scopes, ","))

    this_tok_df <- dplyr::tibble(name = nm, scope = scopes)

    this_set <- unlist(this_tok$settings)
    # Convert settings to a data frame.
    sett <- dplyr::as_tibble(t(this_set))

    this_tok_df <- dplyr::bind_cols(this_tok_df, sett)

    this_tok_df
  })

  token_df <- dplyr::bind_rows(token_df)
  token_df$section <- "tokenColors"

  # Combine all data frames.
  final_df <- dplyr::bind_rows(top_df, settings_df, semantic_df, token_df)

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

  # Convert blanks to NA values.
  final_df[final_df == ""] <- NA

  # Filter undefined rows.
  undef <- is.na(final_df$value) &
    is.na(final_df$foreground) &
    is.na(final_df$background) &
    is.na(final_df$fontStyle)

  final_df[!undef, ]
}

#' @description
#' `read_positron_theme()` is an alias of `read_vs_theme()`.
#'
#' @rdname read_vs_theme
#' @export
read_positron_theme <- read_vs_theme

#' Read and clean JSON data from a theme file
#'
#' Read JSON after removing inline comments and extra trailing commas, then
#' parse and clean the result.
#'
#' @param local_file Path to a JSON file.
#'
#' @return
#' A parsed list structure from the JSON file with cleaned formatting.
#'
#' @noRd
safe_read_json <- function(local_file) {
  lns <- readLines(local_file, warn = FALSE)

  # Flatten and clean the JSON lines.
  lns <- trimws(lns[lns != ""])
  # Remove the schema key.
  lns <- lns[!grepl("$schema", lns, fixed = TRUE)]

  # Split inline comments into separate lines.
  r2_split <- gsub("//", "~//", lns, fixed = TRUE)
  r2 <- trimws(unlist(strsplit(r2_split, "~", fixed = TRUE)))
  # Remove lines that start with a double slash.
  r2 <- r2[!grepl("^//", r2)]

  # Remove trailing commas by collapsing the JSON.
  r2 <- paste0(r2, collapse = "")
  r2 <- gsub(",}", "}", r2, fixed = TRUE)
  r2 <- gsub(", }", "}", r2, fixed = TRUE)
  r2 <- gsub(", ]", "]", r2, fixed = TRUE)
  r2 <- gsub(",]", "]", r2, fixed = TRUE)

  # Convert and read the cleaned JSON.
  json_ok <- jsonlite::fromJSON(r2)
  tmp_js <- tempfile(fileext = ".json")
  jsonlite::write_json(json_ok, tmp_js)
  ll <- jsonlite::read_json(tmp_js)
  unlink(tmp_js)
  ll
}
