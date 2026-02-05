test_that("Errors", {
  expect_snapshot(error = TRUE, read_tm_theme())
  expect_snapshot(error = TRUE, read_tm_theme("a.txt"))
  expect_snapshot(error = TRUE, read_tm_theme("a.json"))
})


test_that("Test full theme", {
  vstheme <- system.file("ext/test-color-theme.json", package = "rstudiothemes")

  fpath <- vstheme |> convert_vs_to_tm_theme()

  res <- read_tm_theme(fpath)

  expect_identical(res[res$name == "name", ]$value, "Tokyo Night")
  expect_identical(
    res[res$name == "semanticClass", ]$value,
    "theme.dark.tokyo_night"
  )

  unlink(fpath)
})

test_that("Test simple theme", {
  vstheme <- system.file(
    "ext/test-simple-color-theme.json",
    package = "rstudiothemes"
  )

  expect_snapshot(fpath <- vstheme |> convert_vs_to_tm_theme())

  res <- read_tm_theme(fpath)

  expect_identical(res[res$name == "name", ]$value, "Skeletor Syntax")
  expect_identical(
    res[res$name == "semanticClass", ]$value,
    "theme.dark.skeletor_syntax"
  )
  unlink(fpath)
})

test_that("Test minimal theme", {
  fpath <- system.file(
    "ext/test-minimal.tmTheme",
    package = "rstudiothemes"
  )

  res <- read_tm_theme(fpath)

  expect_snapshot(unique(res$section))
  expect_snapshot(res$name)
})

test_that("Test error theme", {
  fpath <- system.file(
    "ext/test-error.tmTheme",
    package = "rstudiothemes"
  )

  expect_error(
    res <- read_tm_theme(fpath),
    regexp = '"lineHighlight" and "selection" values are'
  )
})


test_that("Online", {
  skip_on_cran()

  path <- paste0(
    "https://raw.githubusercontent.com/dieghernan/",
    "rstudiothemes/refs/heads/main/inst/ext/test.tmTheme"
  )

  expect_snapshot(
    res <- read_tm_theme(path),
  )
  expect_s3_class(res, "tbl_df")
})
