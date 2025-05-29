#' Read and parse a TextMate theme
#'
#' @description
#' Read a `*.tmTheme` file (really a `*.xml` file) representing a
#' TextMate or a Sublime Text theme.
#'
#' @param tmtheme Path to a TextMate theme, in `*.tmTheme` format.
#'
#' @returns
#' A [tibble::tibble()].
#'
#' @family converters
#'
#' @export
#'
#' @examples
#'
#' the_theme <- system.file("ext/test-color-theme.json",
#'   package = "rstudiothemes"
#' ) |>
#'   # Generate the theme
#'   vstheme2tmtheme()
#'
#' # Check
#' readLines(the_theme) |>
#'   head(10) |>
#'   cat(sep = "\n")
#'
#' read_tmtheme(the_theme)
read_tmtheme <- function(tmtheme) {
  tm <- xml2::read_xml(tmtheme)
  tm <- xml2::as_list(tm)

  tm <- rapply(tm, col2hex, how = "list")

  # Remove trailings / double  whitespace
  tm <- rapply(tm, function(x) {
    x <- gsub("  ", " ", x)
    x <- gsub("  ", " ", x)

    trimws(x)
  }, how = "list")

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

  id_settings <- vapply(array, function(x) {
    nms <- sort(names(x))
    if (length(nms) == 2 && identical(nms, c("dict", "key"))) {
      return(TRUE)
    }
    FALSE
  }, FUN.VALUE = logical(1))

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


  dplyr::bind_rows(top_df, settings_df)
}
