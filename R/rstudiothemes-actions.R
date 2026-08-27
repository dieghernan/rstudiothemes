# nocov start
rstudioapi_add_theme <- function(theme, force = TRUE) {
  rstudioapi::addTheme(theme, force = force)
}

rstudioapi_remove_theme <- function(theme) {
  rstudioapi::removeTheme(theme)
}

rstudioapi_get_themes <- function() {
  rstudioapi::getThemes()
}

rstudioapi_get_theme_info <- function() {
  rstudioapi::getThemeInfo()
}

rstudioapi_apply_theme <- function(theme) {
  rstudioapi::applyTheme(theme)
}

rstudiothemes_readline <- function(prompt) {
  readline(prompt)
}

rstudiothemes_sleep <- function(time) {
  Sys.sleep(time)
}
# nocov end

#' Manage **RStudio** themes
#'
#' @description
#' Install, list, preview or remove the **RStudio** themes included in
#' \CRANpkg{rstudiothemes}. These functions are adapted from selected
#' \pkg{rsthemes} functions.
#'
#' ```{r, echo=FALSE, results='asis'}
#'
#' paste0(" [MIT License](https://github.com/gadenbuie/rsthemes/blob/",
#'   "main/LICENSE.md) Copyright \u00a9 rsthemes authors.") |> cat()
#'
#' ```
#'
#' **Important**: These functions only work in **RStudio** and return `NULL`
#' when called from other IDEs. The exception is
#' `list_rstudiothemes(list_installed = FALSE)`.
#'
#' @section Functions:
#' - `install_rstudiothemes()` installs bundled themes.
#' - `remove_rstudiothemes()` removes bundled themes.
#' - `list_rstudiothemes()` lists installed or available themes.
#' - `try_rstudiothemes()` previews bundled themes.
#'
#' @section Bundled themes:
#' \CRANpkg{rstudiothemes} includes **RStudio** themes based on the following
#' editor themes:
#'
#' ```{r child="man/chunks/themes.Rmd"}
#'
#' ```
#' @references
#' Aden-Buie G (2026). _rsthemes: Full Themes for RStudio v1.2+_. R package
#' version 0.5.1, commit 48fc078f772e5e63669bc9773eabc8e9cdc7f699,
#' <https://github.com/gadenbuie/rsthemes>.
#'
#' @seealso [convert_to_rstudio_theme()] to convert and install a custom theme
#'   file.
#' @author Garrick Aden-Buie <https://github.com/gadenbuie>
#' @name rstudiothemes-actions
#'
#' @examples
#' list_rstudiothemes(list_installed = FALSE)
NULL

#' @param style Theme group: `"all"`, `"dark"` or `"light"`.
#' @param destdir Optional directory for `.rstheme` files. By default, themes
#'   are installed with [rstudioapi::addTheme()]. Use this argument to copy
#'   themes to a non-standard directory instead.
#' @param themes Optional character vector of theme names. If provided, only
#'   these themes are used and `style` is ignored.
#'
#' @returns
#' `install_rstudiothemes()` and `remove_rstudiothemes()` return `NULL`
#' invisibly.
#'
#' @rdname rstudiothemes-actions
#' @export
#' @encoding UTF-8
install_rstudiothemes <- function(
  style = c("all", "dark", "light"),
  themes = NULL,
  destdir = NULL
) {
  # Require RStudio.
  if (!require_rstudio("install_rstudiothemes")) {
    return(NULL)
  }

  theme_files <- list_pkg_rstudiothemes(style = style, themes = themes)
  theme_files <- unname(theme_files)
  if (is.null(theme_files)) {
    return(invisible(NULL))
  }

  if (!is.null(destdir)) {
    cli::cli_alert(
      "Installing {length(theme_files)} theme{?s} to {.file {destdir}}."
    )
    destdir <- path.expand(destdir)

    if (!dir.exists(destdir)) {
      dir.create(destdir, recursive = TRUE)
    }

    file.copy(theme_files, destdir, overwrite = TRUE)
  } else {
    for (theme in theme_files) {
      suppressWarnings(rstudioapi_add_theme(theme, force = TRUE))
    }
  }
  cli::cli_alert_success("Installed {length(theme_files)} theme{?s}.")
  cli::cli_alert_info(
    "Use {.run rstudiothemes::list_rstudiothemes()} to list installed themes."
  )
  cli::cli_alert_info(
    "Use {.run rstudiothemes::try_rstudiothemes()} to preview installed themes."
  )
}

#' @rdname rstudiothemes-actions
#' @export
remove_rstudiothemes <- function(style = c("all", "dark", "light")) {
  # Require RStudio.
  if (!require_rstudio("remove_rstudiothemes")) {
    return(NULL)
  }

  themes <- list_rstudiothemes(style = style)
  if (length(themes) == 0) {
    return(invisible())
  }

  for (theme in themes) {
    rstudioapi_remove_theme(theme)
  }

  cli::cli_alert_success("Uninstalled {length(themes)} theme{?s}.")
}

#' @param list_installed If `TRUE` (default), list installed
#'   \CRANpkg{rstudiothemes} themes. If `FALSE`, list themes available in the
#'   package.
#'
#' @returns
#' `list_rstudiothemes()` returns a character vector of theme names.
#'
#' @rdname rstudiothemes-actions
#' @export
list_rstudiothemes <- function(
  style = c("all", "dark", "light"),
  list_installed = TRUE
) {
  if (!list_installed) {
    return(names(list_pkg_rstudiothemes(style = style)))
  }

  # Require RStudio.
  if (!require_rstudio("list_rstudiothemes")) {
    return(NULL)
  }

  installed_themes <- vapply(
    rstudioapi_get_themes(),
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

  # Validate specific theme selections.
  if (!is.null(themes)) {
    sel <- ensure_null(allt[intersect(themes, nms)])

    # Inform the user if some themes are not found.
    if (length(sel) < length(themes)) {
      cli::cli_alert_warning(paste0(
        "Matched {cli::no(length(sel))} theme{?s} among ",
        "{length(themes)} requested name{?s}: {.val {themes}}."
      ))
      cli::cli_alert_info(paste0(
        "Use {.run rstudiothemes::list_rstudiothemes()} to check ",
        "available names."
      ))
    }

    if (is.null(sel)) {}

    return(sel)
  }

  if (style == "all") {
    return(allt)
  }

  # Determine the theme type.
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

#' @param delay Number of seconds to wait between themes. Set to 0 to be
#'   prompted to continue after each theme.
#'
#' @returns
#' `try_rstudiothemes()` has side effects. It cycles through bundled themes,
#' lets you preview each one and restores your original theme when you quit.
#'
#' @rdname rstudiothemes-actions
#' @export
try_rstudiothemes <- function(
  style = c("all", "dark", "light"),
  themes = NULL,
  delay = 0
) {
  style <- match_arg_pretty(style)

  # Require RStudio.
  if (!require_rstudio("try_rstudiothemes")) {
    return(NULL)
  }

  # Filter themes by style before applying user selections.
  if (!is.null(themes)) {
    # Validate theme names.
    all_installed <- intersect(themes, list_rstudiothemes())
  } else {
    all_installed <- list_rstudiothemes(style)
  }

  # Order themes light before dark.
  try_themes <- unique(c(
    all_installed[all_installed %in% names(list_pkg_rstudiothemes("light"))],
    all_installed[all_installed %in% names(list_pkg_rstudiothemes("dark"))]
  ))

  current_theme <- rstudioapi_get_theme_info()

  cli::cli_alert(
    "Trying {length(try_themes)} theme{?s} from {.pkg rstudiothemes}."
  )
  cli::cli_alert("At the prompt, choose one of:")
  cli::cli_bullets(c(
    "*" = "{.kbd n} or {.kbd SPACE} to try the {.strong next} theme.",
    "*" = "{.kbd k} to {.strong keep} that theme.",
    "*" = "{.kbd q} to {.strong quit} and restore your original theme."
  ))
  for (theme in try_themes) {
    cli::cli_bullets(c("*" = "{.val {theme}}"))
    rstudioapi_apply_theme(theme)
    if (delay > 0) {
      rstudiothemes_sleep(delay)
    } else {
      res <- rstudiothemes_readline("[n,k,q]: ")
      if (tolower(res) == "k") {
        return(invisible())
      }
      if (tolower(res) == "q") break
    }
  }
  cli::cli_alert_success(
    "Restoring the original theme: {.strong {current_theme$editor}}."
  )
  rstudioapi_apply_theme(current_theme$editor)
}

cli_how2install <- function() {
  cli::cli_alert_warning("No {.pkg rstudiothemes} themes are installed.")
  cli::cli_alert_info(paste0(
    "Use {.run rstudiothemes::install_rstudiothemes()} to install ",
    "the package themes."
  ))
}
