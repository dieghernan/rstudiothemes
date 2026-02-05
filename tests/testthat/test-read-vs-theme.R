test_that("Errors", {
  expect_snapshot(error = TRUE, read_vs_theme())
  expect_snapshot(error = TRUE, read_vs_theme("a.txt"))
  expect_snapshot(error = TRUE, read_vs_theme("a.json"))
})


test_that("Test full theme", {
  vstheme <- system.file("ext/test-color-theme.json", package = "rstudiothemes")

  res <- read_vs_theme(vstheme)

  expect_identical(res[res$name == "name", ]$value, "Tokyo Night")
  expect_identical(res[res$name == "type", ]$value, "dark")

  # Extract semanticTokenColors
  expect_true("semanticTokenColors" %in% res$section)
})

test_that("Test simple theme", {
  vstheme <- system.file(
    "ext/test-simple-color-theme.json",
    package = "rstudiothemes"
  )

  res <- read_vs_theme(vstheme)

  expect_identical(res[res$name == "name", ]$value, "Skeletor Syntax")
  expect_length(res[res$name == "type", ]$value, 0)
})

test_that("Online", {
  skip_on_cran()

  path <- paste0(
    "https://raw.githubusercontent.com/dieghernan/",
    "rstudiothemes/refs/heads/main/inst/ext/test-color-theme.json"
  )

  expect_snapshot(
    res <- read_vs_theme(path),
  )
  expect_s3_class(res, "tbl_df")
})
