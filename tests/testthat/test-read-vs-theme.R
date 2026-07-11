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
  expect_contains(res$section, "semanticTokenColors")
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
  vstheme <- system.file("ext/test-color-theme.json", package = "rstudiothemes")
  local_mock_theme_download(vstheme)

  path <- paste0(
    "https://raw.githubusercontent.com/dieghernan/",
    "rstudiothemes/refs/heads/main/inst/ext/test-color-theme.json"
  )

  expect_snapshot(res <- read_vs_theme(path))
  expect_s3_class(res, "tbl_df")
})

test_that("Corner case", {
  jelly <- system.file("ext/jellyfish.json", package = "rstudiothemes")

  expect_silent(df <- read_vs_theme(jelly))
  expect_s3_class(df, "tbl_df")

  expect_silent(convert_vs_to_tm_theme(jelly))
})

test_that("Empty Visual Studio Code color values are kept as missing", {
  theme <- withr::local_tempfile(fileext = ".json")
  writeLines(
    c(
      "{",
      '  "name": "Null color",',
      '  "colors": { "editor.background": null },',
      '  "tokenColors": []',
      "}"
    ),
    theme
  )

  parsed <- read_vs_theme(theme)

  expect_length(parsed$name[parsed$name == "editor.background"], 0L)
})
