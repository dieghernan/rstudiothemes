# nocov start

#' Install, list, try or remove RStudio themes
#'
#' @description
#' Adaptation of some \pkg{rsthemes} functions,
#'
#' ```{r, echo=FALSE, results='asis'}
#'
#' paste0(" [MIT License](https://github.com/gadenbuie/rsthemes/blob/",
#'   "main/LICENSE.md) Copyright \u00a9 rsthemes authors.") |> cat()
#'
#' ```
#'
#' **Important**: These functions (except
#' `list_rstudiothemes(list_installed = FALSE)` only works in RStudio;
#' it returns `NULL` when called from other IDEs.
#'
#' @section Palettes: \pkg{rstudiothemes} includes RStudio themes based on the
#'   following color palettes.
#'
#'   ```r
#'   # {r child="man/fragments/palettes.Rmd"}
#'   TODO
#'   ```
#' @author  Garrick Aden-Buie <https://github.com/gadenbuie>
#'
#' @references
#'   Aden-Buie G (2026). _rsthemes: Full Themes for RStudio v1.2+_. R package
#'   version 0.5.1,commit 48fc078f772e5e63669bc9773eabc8e9cdc7f699,
#'   <https://github.com/gadenbuie/rsthemes>.
#'
#' @name rstudiothemes-actions
#' @examples
#' list_rstudiothemes()
NULL

#' @describeIn rstudiothemes-actions Install RStudio themes
#' @param style Limit to a subgroup of themes (`all`, `dark`, `light`).
#' @param destdir The destination directory for the `.rstheme` files. By default
#'   uses [rstudioapi::addTheme()] to install themes, but this argument lets
#'   users install themes to non-standard directories, or in case the location
#'   of the RStudio theme directory has changed.
#' @param themes Vector of theme names (`list_rstudiothemes()`).
#'   If provided just those themes would be tried, and `style` will be ignored.
#'
#' @export
install_rstudiothemes <- function(
  style = c("all", "dark", "light"),
  themes = NULL,
  destdir = NULL
) {
  # Only works in RStudio
  if (!on_rstudio()) {
    gui <- detect_gui() # nolint
    cli::cli_alert_danger(
      paste0(
        "{.fn rstudiothemes::install_rstudiothemes} only works in RStudio, ",
        "not in {gui}."
      )
    )
    cli::cli_alert("Bye")
    return(NULL)
  }

  theme_files <- list_pkg_rstudiothemes(style = style, themes = themes)
  theme_files <- unname(theme_files)
  if (is.null(theme_files)) {
    return(invisible(NULL))
  }

  if (!is.null(destdir)) {
    cli::cli_alert(
      "Installing {length(theme_files)} theme{?s} to {.file {destdir}}"
    )
    destdir <- path.expand(destdir)

    if (!dir.exists(destdir)) {
      dir.create(destdir, recursive = TRUE)
    }

    file.copy(theme_files, destdir, overwrite = TRUE)
  } else {
    for (theme in theme_files) {
      suppressWarnings(rstudioapi::addTheme(theme, force = TRUE))
    }
  }
  cli::cli_alert_success(
    "Installed {length(theme_files)} theme{?s}"
  )
  cli::cli_alert_info(
    "Use {.fn rstudiothemes::list_rstudiothemes} to list installed themes"
  )
  cli::cli_alert_info(
    "Use {.fn rstudiothemes::try_rstudiothemes} to try all installed themes"
  )
}

#' @describeIn rstudiothemes-actions Remove \pkg{rstudiothemes} from RStudio
#' @export
remove_rstudiothemes <- function(style = c("all", "dark", "light")) {
  # Only works in RStudio
  if (!on_rstudio()) {
    gui <- detect_gui() # nolint
    cli::cli_alert_danger(
      paste0(
        "{.fn rstudiothemes::remove_rstudiothemes} only works in RStudio, ",
        "not in {gui}."
      )
    )
    cli::cli_alert("Bye")
    return(NULL)
  }

  themes <- list_rstudiothemes(style = style)
  if (length(themes) == 0) {
    return(invisible())
  }

  for (theme in themes) {
    rstudioapi::removeTheme(theme)
  }

  cli::cli_alert_success("Uninstalled {length(themes)} themes")
}

# ncov end

#' @describeIn rstudiothemes-actions List installed themes (default) or
#'   available themes
#' @param list_installed Should the installed \pkg{rstudiothemes} themes be
#'   listed (default). If `FALSE`, the available themes in the
#'   \pkg{rstudiothemes} package are listed instead.
#' @export
list_rstudiothemes <- function(
  style = c("all", "dark", "light"),
  list_installed = TRUE
) {
  if (!list_installed) {
    return(names(list_pkg_rstudiothemes(style = style)))
  }

  # ncov start

  # Only works in RStudio
  if (!on_rstudio()) {
    gui <- detect_gui() # nolint
    cli::cli_alert_danger(
      paste0(
        "{.fn rstudiothemes::list_rstudiothemes} only works in RStudio, ",
        "not in {gui}."
      )
    )
    cli::cli_alert("Bye")
    return(NULL)
  }

  themes <- rstudioapi::getThemes()
  installed_themes <- vapply(
    rstudioapi::getThemes(),
    function(x) {
      unlist(x["name"], use.names = FALSE)
    },
    FUN.VALUE = character(1),
    USE.NAMES = FALSE
  )
  mythemes <- names(list_pkg_rstudiothemes(style = style))
  themes <- intersect(mythemes, installed_themes)

  if (list_installed && !length(themes)) {
    cli_how2install()
    return(invisible())
  }

  unname(themes)
  # nocov end
}

list_pkg_rstudiothemes <- function(
  style = c("all", "dark", "light"),
  themes = NULL
) {
  style <- match_arg_pretty(style)
  allt <- list.files(
    system.file("rsthemes", package = "rstudiothemes"),
    full.names = TRUE
  )

  nms <- vapply(
    allt,
    function(x) {
      lns <- readLines(x, n = 1)
      trimws(gsub("(.*):|\\*(.*)", "", lns))
    },
    FUN.VALUE = character(1),
    USE.NAMES = FALSE
  )

  names(allt) <- nms

  # If specific themes selected
  if (!is.null(themes)) {
    # Validate name

    sel <- ensure_null(allt[intersect(themes, nms)])

    # Inform if some themes not found
    if (length(sel) < length(themes)) {
      cli::cli_alert_warning(
        paste0(
          "Found {no({length(sel)})} theme{?s} with ",
          "{qty(length(themes))}name{?s} {.str {themes}}"
        )
      )
      cli::cli_alert_info(
        paste0(
          "Use {.fn rstudiothemes::list_rstudiothemes} to check the ",
          "available names"
        )
      )
    }

    if (is.null(sel)) {}

    return(sel)
  }

  if (style == "all") {
    return(allt)
  }

  # Need to assess the type of theme
  dark <- vapply(
    allt,
    function(x) {
      lns <- readLines(x, n = 2)[2]
      grepl("TRUE", lns, fixed = TRUE)
    },
    FUN.VALUE = logical(1),
    USE.NAMES = FALSE
  )

  if (style == "dark") {
    return(allt[dark])
  }

  allt[!dark]
}

#' @describeIn rstudiothemes-actions Try each \pkg{rstudiothemes} RStudio theme
#' @param delay Number of seconds to wait between themes. Set to 0 to be
#'   prompted to continue after each theme.
#' @export
try_rstudiothemes <- function(
  style = c("all", "dark", "light"),
  themes = NULL,
  delay = 0
) {
  # nocov start

  style <- match_arg_pretty(style)

  # Only works in RStudio
  if (!on_rstudio()) {
    gui <- detect_gui() # nolint
    cli::cli_alert_danger(
      paste0(
        "{.fn rstudiothemes::try_rs_themes} only works in RStudio, ",
        "not in {gui}."
      )
    )
    cli::cli_alert("Bye")
    return(NULL)
  }

  # Logic, extract in order (dark/light) and then select based in user inputs
  if (!is.null(themes)) {
    # Validate
    all_installed <- intersect(themes, list_rstudiothemes())
  } else {
    all_installed <- list_rstudiothemes(style)
  }

  # Now sort based on style
  try_themes <- unique(c(
    all_installed[all_installed %in% names(list_pkg_rstudiothemes("light"))],
    all_installed[all_installed %in% names(list_pkg_rstudiothemes("dark"))]
  ))

  # Arrange in dark/light

  current_theme <- rstudioapi::getThemeInfo()

  cli::cli_alert(c(
    "Trying {.strong {length(try_themes)}}",
    "{cli::qty(length(try_themes))} theme{?s} from {.pkg rstudiothemes}."
  ))
  cli::cli_alert("At the prompt, choose from:")
  cli::cli_bullets(c(
    "*" = "{.kbd n} or {.kbd {' '}} (empty) to try the {.strong next} theme",
    "*" = "{.kbd k} to {.strong keep} that theme",
    "*" = "{.kbd q} to {.strong quit} and restore your original theme"
  ))
  for (theme in try_themes) {
    cat("\u2022", theme, "\n")
    rstudioapi::applyTheme(theme)
    if (delay > 0) {
      Sys.sleep(delay)
    } else {
      res <- readline("[n,k,q]: ")
      if (tolower(res) == "k") {
        return(invisible())
      }
      if (tolower(res) == "q") break
    }
  }
  cli::cli_alert_success("Restoring \"{.strong {current_theme$editor}}\"")
  rstudioapi::applyTheme(current_theme$editor)

  # nocov end
}


cli_how2install <- function() {
  cli::cli_alert_danger("No {.pkg rstudiothemes} themes are installed.")
  cli::cli_alert_info(
    paste0(
      "Use {.fn rstudiothemes::install_rstudiothemes} to install",
      " our themes"
    )
  )
}
