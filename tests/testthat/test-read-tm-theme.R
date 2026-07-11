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
  fpath <- system.file("ext/test-minimal.tmTheme", package = "rstudiothemes")

  res <- read_tm_theme(fpath)

  expect_snapshot(unique(res$section))
  expect_snapshot(res$name)
})

test_that("Test error theme", {
  fpath <- system.file("ext/test-error.tmTheme", package = "rstudiothemes")

  expect_snapshot(
    error = TRUE,
    read_tm_theme(fpath),
    transform = function(lines) mask_fixture_path(lines, "test-error.tmTheme")
  )
})


test_that("Online", {
  skip_on_cran()
  tmtheme <- system.file("ext/test.tmTheme", package = "rstudiothemes")
  local_mock_theme_download(tmtheme)

  path <- paste0(
    "https://raw.githubusercontent.com/dieghernan/",
    "rstudiothemes/refs/heads/main/inst/ext/test.tmTheme"
  )

  expect_snapshot(res <- read_tm_theme(path))
  expect_s3_class(res, "tbl_df")
})

test_that("TextMate token parser handles empty token fields", {
  fpath <- withr::local_tempfile(fileext = ".tmTheme")
  writeLines(
    c(
      '<?xml version="1.0" encoding="UTF-8"?>',
      '<plist version="1.0">',
      "<dict>",
      "<key>name</key><string>Empty token</string>",
      "<key>settings</key>",
      "<array>",
      "<dict><key>settings</key><dict>",
      "<key>background</key><string>#000000</string>",
      "<key>caret</key><string>#FFFFFF</string>",
      "<key>foreground</key><string>#FFFFFF</string>",
      "<key>invisibles</key><string>#333333</string>",
      "<key>lineHighlight</key><string>#111111</string>",
      "<key>selection</key><string>#222222</string>",
      "</dict></dict>",
      "<dict><key>name</key><string/>",
      "<key>scope</key><string>source.r</string></dict>",
      "<dict><key>name</key><string>Empty setting</string>",
      "<key>scope</key><string>keyword</string>",
      "<key>settings</key><dict><key>foreground</key><string/></dict></dict>",
      "</array>",
      "</dict>",
      "</plist>"
    ),
    fpath
  )

  parsed <- read_tm_theme(fpath)

  expect_contains(parsed$scope, "keyword")
  expect_identical(
    parsed[which(parsed$scope == "keyword"), ]$foreground,
    "NULL"
  )
})
