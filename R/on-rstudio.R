#' Check whether the session is running in RStudio
#'
#' @description
#' Detect whether the current R session is running in RStudio, used to
#' decide if themes can be applied to the IDE.
#'
#' @return
#' `TRUE` if running in RStudio, `FALSE` otherwise.
#'
#' @family helpers
#' @encoding UTF-8
#' @export
#'
#' @examples
#' on_rstudio()
on_rstudio <- function() {
  gui <- detect_gui()

  if (gui == "RStudio") {
    return(TRUE)
  }

  cli::cli_alert_warning("Detected GUI: {.str {gui}}.")

  FALSE
}

# Helper functions.
detect_gui <- function() {
  # Return the platform GUI string, but override it for Visual Studio Code.
  gui <- .Platform$GUI
  if (on_vscode()) {
    gui <- "Visual Studio Code"
  }

  gui
}

on_vscode <- function() {
  # Detect Visual Studio Code through the TERM_PROGRAM environment variable.
  Sys.getenv("TERM_PROGRAM") == "vscode"
}
