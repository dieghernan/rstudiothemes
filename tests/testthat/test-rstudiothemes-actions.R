test_that("Check list_pkg_rstudiothemes", {
  skip_on_cran()
  expect_silent(all <- list_pkg_rstudiothemes())
  expect_silent(lg <- list_pkg_rstudiothemes(style = "light"))
  expect_silent(dk <- list_pkg_rstudiothemes(style = "dark"))

  expect_true(all(length(all) > length(dk), length(dk) > length(lg)))

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
})

test_that("Check list_rstudiothemes", {
  skip_on_cran()

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

test_that("How to install", {
  skip_on_cran()

  expect_snapshot(cli_how2install())
})

test_that("Dev testing install_themes", {
  # Warning! These tests would alter your theme configuration
  skip_on_cran()
  skip_if(!on_rstudio(), "Not in RStudio")
  skip_if(!interactive(), "Not interactive")

  current_theme <- rstudioapi::getThemeInfo()$editor

  expect_message(
    install_rstudiothemes(),
    paste("Installed", length(list_pkg_rstudiothemes()), "themes")
  )

  # Remove all at beginning
  expect_message(
    remove_rstudiothemes(),
    paste("Uninstalled", length(list_pkg_rstudiothemes()), "themes")
  )

  # Clean theme list now
  clean_list <- rstudioapi::getThemes()

  # Length of this should be 0 now
  expect_length(list_rstudiothemes(), 0)

  # How many themes?

  all <- length(list_pkg_rstudiothemes())
  lg <- length(list_pkg_rstudiothemes("light"))
  dk <- length(list_pkg_rstudiothemes("dark"))

  # Install only light
  expect_message(
    install_rstudiothemes("light"),
    paste("Installed", lg, "themes")
  )
  expect_identical(list_rstudiothemes(), list_rstudiothemes("light"))
  expect_identical(lg, list_rstudiothemes("light"))
  # But...
  remove_rstudiothemes()
  install_rstudiothemes("light", c("Selenized Black", "Skeletor Syntax"))
  expect_null(list_rstudiothemes("light"))
  expect_identical(
    list_rstudiothemes(),
    c("Selenized Black", "Skeletor Syntax")
  )
})
