test_that("list_pkg_rstudiothemes() filters bundled themes by style and name", {
  expect_silent(all <- list_pkg_rstudiothemes())
  expect_silent(lg <- list_pkg_rstudiothemes(style = "light"))
  expect_silent(dk <- list_pkg_rstudiothemes(style = "dark"))

  expect_gt(length(all), length(dk))
  expect_gt(length(dk), length(lg))

  expect_silent(
    sel_them <- list_pkg_rstudiothemes(
      style = "light",
      themes = c("Selenized Dark", "Selenized Light")
    )
  )
  expect_identical(c("Selenized Dark", "Selenized Light"), names(sel_them))

  expect_snapshot(
    sel_single <- list_pkg_rstudiothemes(
      style = "dark",
      themes = c("XXX", "Selenized Light")
    )
  )
  expect_identical("Selenized Light", names(sel_single))

  # NULL
  expect_snapshot(nn <- list_pkg_rstudiothemes(themes = c("a", "b")))
  expect_null(nn)

  expect_snapshot(nn <- list_pkg_rstudiothemes(themes = "a"))

  # Check plural
  expect_snapshot(
    sel_single <- list_pkg_rstudiothemes(
      style = "dark",
      themes = c("XXX", "Selenized Light", "Selenized Dark")
    )
  )
})

test_that("list_pkg_rstudiothemes() handles missing themes", {
  all <- list_pkg_rstudiothemes()
  light <- list_pkg_rstudiothemes(style = "light")
  dark <- list_pkg_rstudiothemes(style = "dark")

  expect_gt(length(all), length(dark))
  expect_gt(length(dark), length(light))

  selected <- suppressMessages(list_pkg_rstudiothemes(
    style = "light",
    themes = c("Selenized Dark", "Selenized Light")
  ))
  expect_identical(c("Selenized Dark", "Selenized Light"), names(selected))

  missing <- suppressMessages(list_pkg_rstudiothemes(themes = c("a", "b")))
  expect_null(missing)
})

test_that("list_rstudiothemes() lists bundled themes offline", {
  expect_identical(
    list_rstudiothemes(list_installed = FALSE),
    names(list_pkg_rstudiothemes())
  )

  expect_identical(
    list_rstudiothemes(style = "light", list_installed = FALSE),
    names(list_pkg_rstudiothemes(style = "light"))
  )

  expect_identical(
    list_rstudiothemes(style = "dark", list_installed = FALSE),
    names(list_pkg_rstudiothemes(style = "dark"))
  )
})

test_that("cli_how2install() explains how to install bundled themes", {
  expect_snapshot(cli_how2install())
})

test_that("install_rstudiothemes() copies themes to a custom directory", {
  source_dir <- withr::local_tempdir()
  dest_dir <- file.path(withr::local_tempdir(), "themes")
  theme_file <- file.path(source_dir, "theme.rstheme")
  writeLines("dummy", theme_file)

  local_mocked_bindings(
    require_rstudio = function(...) TRUE,
    list_pkg_rstudiothemes = function(...) c(theme_file),
    rstudioapi_add_theme = function(...) NULL
  )

  install_rstudiothemes(destdir = dest_dir)

  expect_true(file.exists(file.path(dest_dir, basename(theme_file))))
})

test_that("install_rstudiothemes() adds selected themes", {
  added <- character()

  local_mocked_bindings(
    require_rstudio = function(...) TRUE,
    list_pkg_rstudiothemes = function(...) {
      c("theme-a.rstheme", "theme-b.rstheme")
    },
    rstudioapi_add_theme = function(theme, force = TRUE) {
      added <<- c(added, theme)
    }
  )

  install_rstudiothemes()
  expect_identical(added, c("theme-a.rstheme", "theme-b.rstheme"))
})

test_that("install_rstudiothemes() returns NULL for empty selections", {
  local_mocked_bindings(
    require_rstudio = function(...) TRUE,
    list_pkg_rstudiothemes = function(...) NULL
  )

  expect_null(install_rstudiothemes())
})

test_that("RStudio actions return NULL outside RStudio", {
  local_mocked_bindings(require_rstudio = function(...) FALSE)

  expect_null(install_rstudiothemes())
  expect_null(remove_rstudiothemes())
  expect_null(list_rstudiothemes())
  expect_null(try_rstudiothemes())
})

test_that("remove_rstudiothemes() removes each installed bundled theme", {
  removed <- character()

  local_mocked_bindings(
    require_rstudio = function(...) TRUE,
    list_rstudiothemes = function(...) c("theme-a", "theme-b"),
    rstudioapi_remove_theme = function(theme) {
      removed <<- c(removed, theme)
    }
  )

  remove_rstudiothemes()

  expect_identical(removed, c("theme-a", "theme-b"))

  local_mocked_bindings(list_rstudiothemes = function(...) character())
  expect_null(remove_rstudiothemes())
})

test_that("list_rstudiothemes() intersects installed and bundled themes", {
  local_mocked_bindings(
    require_rstudio = function(...) TRUE,
    list_pkg_rstudiothemes = function(style = c("all", "dark", "light"),
                                      themes = NULL) {
      structure(c("/tmp/one", "/tmp/two"), names = c("Theme One", "Theme Two"))
    },
    rstudioapi_get_themes = function() {
      list(list(name = "Theme One"), list(name = "Theme Two"))
    }
  )

  expect_identical(list_rstudiothemes(), c("Theme One", "Theme Two"))
})

test_that("list_rstudiothemes() reports when no bundled themes are installed", {
  local_mocked_bindings(
    require_rstudio = function(...) TRUE,
    list_pkg_rstudiothemes = function(...) {
      structure(c("/tmp/one"), names = "Theme One")
    },
    rstudioapi_get_themes = function() {
      list(list(name = "Other Theme"))
    }
  )

  expect_snapshot(res <- list_rstudiothemes())
  expect_null(res)
})

test_that("try_rstudiothemes() restores the original theme", {
  applied <- character()

  local_mocked_bindings(
    require_rstudio = function(...) TRUE,
    list_rstudiothemes = function(...) c("Light Theme", "Dark Theme"),
    list_pkg_rstudiothemes = function(style = c("all", "dark", "light"),
                                      themes = NULL) {
      style <- match.arg(style)
      if (style == "light") {
        return(structure("light.rstheme", names = "Light Theme"))
      }
      if (style == "dark") {
        return(structure("dark.rstheme", names = "Dark Theme"))
      }
      structure(
        c("light.rstheme", "dark.rstheme"),
        names = c("Light Theme", "Dark Theme")
      )
    },
    rstudioapi_get_theme_info = function() list(editor = "Original Theme"),
    rstudioapi_apply_theme = function(theme) {
      applied <<- c(applied, theme)
    },
    rstudiothemes_sleep = function(time) NULL
  )

  expect_snapshot(try_rstudiothemes(delay = 1))
  expect_identical(applied, c("Light Theme", "Dark Theme", "Original Theme"))
})

test_that("try_rstudiothemes() handles selected themes and prompt choices", {
  applied <- character()
  answers <- c("n", "q")

  local_mocked_bindings(
    require_rstudio = function(...) TRUE,
    list_rstudiothemes = function(...) c("Light Theme", "Dark Theme"),
    list_pkg_rstudiothemes = function(style = c("all", "dark", "light"),
                                      themes = NULL) {
      style <- match.arg(style)
      if (style == "light") {
        return(structure("light.rstheme", names = "Light Theme"))
      }
      if (style == "dark") {
        return(structure("dark.rstheme", names = "Dark Theme"))
      }
      structure(
        c("light.rstheme", "dark.rstheme"),
        names = c("Light Theme", "Dark Theme")
      )
    },
    rstudioapi_get_theme_info = function() list(editor = "Original Theme"),
    rstudioapi_apply_theme = function(theme) {
      applied <<- c(applied, theme)
    },
    rstudiothemes_readline = function(prompt) {
      res <- answers[[1]]
      answers <<- answers[-1]
      res
    }
  )

  expect_snapshot(try_rstudiothemes(themes = c("Light Theme", "Dark Theme")))
  expect_identical(applied, c("Light Theme", "Dark Theme", "Original Theme"))

  applied <- character()
  local_mocked_bindings(rstudiothemes_readline = function(prompt) "k")

  expect_snapshot(try_rstudiothemes(themes = "Light Theme"))
  expect_identical(applied, "Light Theme")
})

test_that("RStudio theme actions work in an interactive RStudio session", {
  # Warning! These tests would alter your theme configuration
  skip_on_cran()
  skip_if(!on_rstudio(), "Not in RStudio")
  skip_if(!interactive(), "Not interactive")

  current_theme <- rstudioapi::getThemeInfo()$editor

  expect_snapshot(install_rstudiothemes())

  # Remove all at beginning
  expect_snapshot(remove_rstudiothemes())

  # Clean theme list now
  invisible(rstudioapi::getThemes())

  # Length of this should be 0 now
  expect_length(list_rstudiothemes(), 0)

  # How many themes?

  lg <- length(list_pkg_rstudiothemes("light"))

  # Install only light
  expect_snapshot(install_rstudiothemes("light"))

  expect_identical(list_rstudiothemes(), list_rstudiothemes("light"))
  expect_length(list_rstudiothemes("light"), lg)
  # But...
  remove_rstudiothemes()
  install_rstudiothemes("light", c("Selenized Dark", "Skeletor Syntax"))
  expect_null(list_rstudiothemes("light"))
  expect_identical(list_rstudiothemes(), c("Selenized Dark", "Skeletor Syntax"))

  # Install all again
  expect_snapshot(install_rstudiothemes())
  rstudioapi::applyTheme(current_theme)
})
