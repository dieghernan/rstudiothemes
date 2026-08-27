test_that("bundled themes filter by style", {
  expect_silent(all <- list_pkg_rstudiothemes())
  expect_silent(lg <- list_pkg_rstudiothemes(style = "light"))
  expect_silent(dk <- list_pkg_rstudiothemes(style = "dark"))

  expect_gt(length(all), length(dk))
  expect_gt(length(dk), length(lg))
})

test_that("explicit theme selections preserve requested matches", {
  expect_silent(
    selected <- list_pkg_rstudiothemes(
      style = "light",
      themes = c("Selenized Dark", "Selenized Light")
    )
  )
  expect_identical(c("Selenized Dark", "Selenized Light"), names(selected))
})

test_that("partial theme matches are returned with guidance", {
  expect_snapshot(
    selected <- list_pkg_rstudiothemes(
      style = "dark",
      themes = c("XXX", "Selenized Light")
    )
  )
  expect_identical("Selenized Light", names(selected))
})

test_that("two unmatched theme names use plural guidance", {
  expect_snapshot(result <- list_pkg_rstudiothemes(themes = c("a", "b")))
  expect_null(result)
})

test_that("three unmatched theme names use list guidance", {
  expect_snapshot(
    result <- list_pkg_rstudiothemes(themes = c("a", "b", "c"))
  )
  expect_null(result)
})

test_that("bundled themes can be listed without an RStudio session", {
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

test_that("missing installations provide actionable guidance", {
  expect_snapshot(cli_how2install())
})

test_that("custom installation directories receive copied theme files", {
  source_dir <- withr::local_tempdir()
  dest_dir <- file.path(withr::local_tempdir(), "themes")
  theme_file <- file.path(source_dir, "theme.rstheme")
  writeLines("dummy", theme_file)

  local_mocked_bindings(
    require_rstudio = function(...) TRUE,
    list_pkg_rstudiothemes = function(...) c(theme_file),
    rstudioapi_add_theme = function(...) NULL
  )

  expect_snapshot(
    install_rstudiothemes(destdir = dest_dir),
    transform = function(lines) {
      lines <- gsub("\\\\", "/", lines)
      dest_dir <- gsub("\\\\", "/", dest_dir)
      gsub(dest_dir, "<themes>", lines, fixed = TRUE)
    }
  )

  expect_true(file.exists(file.path(dest_dir, basename(theme_file))))
})

test_that("custom installation failures report uncopied theme files", {
  source_dir <- withr::local_tempdir()
  dest_dir <- withr::local_tempdir()
  theme_files <- file.path(source_dir, c("one.rstheme", "two.rstheme"))
  writeLines("dummy", theme_files[1])
  writeLines("dummy", theme_files[2])

  local_mocked_bindings(
    require_rstudio = function(...) TRUE,
    list_pkg_rstudiothemes = function(...) theme_files,
    copy_theme_files = function(...) c(TRUE, FALSE)
  )

  expect_snapshot(
    error = TRUE,
    install_rstudiothemes(destdir = dest_dir),
    transform = function(lines) {
      lines <- gsub("\\\\", "/", lines)
      dest_dir <- gsub("\\\\", "/", dest_dir)
      gsub(dest_dir, "<themes>", lines, fixed = TRUE)
    }
  )
})

test_that("default installation adds every selected theme", {
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

  expect_snapshot(install_rstudiothemes())
  expect_identical(added, c("theme-a.rstheme", "theme-b.rstheme"))
})

test_that("empty installation selections stop without side effects", {
  local_mocked_bindings(
    require_rstudio = function(...) TRUE,
    list_pkg_rstudiothemes = function(...) NULL
  )

  expect_null(install_rstudiothemes())
})

test_that("RStudio actions stop cleanly in other sessions", {
  local_mocked_bindings(require_rstudio = function(...) FALSE)

  expect_null(install_rstudiothemes())
  expect_null(remove_rstudiothemes())
  expect_null(list_rstudiothemes())
  expect_null(try_rstudiothemes())
})

test_that("removal deletes every installed bundled theme", {
  removed <- character()

  local_mocked_bindings(
    require_rstudio = function(...) TRUE,
    list_rstudiothemes = function(...) c("theme-a", "theme-b"),
    rstudioapi_remove_theme = function(theme) {
      removed <<- c(removed, theme)
    }
  )

  expect_snapshot(remove_rstudiothemes())

  expect_identical(removed, c("theme-a", "theme-b"))
})

test_that("removal stops cleanly when no bundled themes are installed", {
  local_mocked_bindings(
    require_rstudio = function(...) TRUE,
    list_rstudiothemes = function(...) character()
  )

  expect_null(remove_rstudiothemes())
})

test_that("installed listings retain only bundled theme names", {
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

test_that("installed listings explain when no bundled themes match", {
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

test_that("timed previews restore the original theme", {
  captured <- local_mock_rstudio_preview()

  expect_snapshot(try_rstudiothemes(delay = 1))
  expect_identical(captured$slept, c(1, 1))
  expect_identical(
    captured$applied,
    c("Light Theme", "Dark Theme", "Original Theme")
  )
})

test_that("quitting a prompted preview restores the original theme", {
  captured <- local_mock_rstudio_preview(c("n", "q"))

  expect_snapshot(try_rstudiothemes(themes = c("Light Theme", "Dark Theme")))
  expect_identical(
    captured$applied,
    c("Light Theme", "Dark Theme", "Original Theme")
  )
})

test_that("keeping a prompted preview leaves the selected theme active", {
  captured <- local_mock_rstudio_preview("k")

  expect_snapshot(try_rstudiothemes(themes = "Light Theme"))
  expect_identical(captured$applied, "Light Theme")
})

test_that("local interactive smoke test exercises real RStudio actions", {
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
