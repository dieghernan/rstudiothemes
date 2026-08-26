test_that("read_tm_theme() reports invalid inputs", {
  expect_snapshot(error = TRUE, read_tm_theme())
  expect_snapshot(error = TRUE, read_tm_theme("a.txt"))
  expect_snapshot(error = TRUE, read_tm_theme("a.json"))
})


test_that("read_tm_theme() parses converted full TextMate themes", {
  vstheme <- system.file("ext/test-color-theme.json", package = "rstudiothemes")

  tmpfile <- withr::local_tempfile(fileext = ".tmTheme")

  vstheme |> convert_vs_to_tm_theme(outfile = tmpfile)

  res <- read_tm_theme(tmpfile)

  expect_identical(res[res$name == "name", ]$value, "Tokyo Night")
  expect_identical(
    res[res$name == "semanticClass", ]$value,
    "theme.dark.tokyo_night"
  )
})

test_that("read_tm_theme() parses converted simple TextMate themes", {
  vstheme <- system.file(
    "ext/test-simple-color-theme.json",
    package = "rstudiothemes"
  )

  fpath <- withr::local_tempfile(fileext = ".tmTheme")
  expect_snapshot(invisible(convert_vs_to_tm_theme(vstheme, outfile = fpath)))

  res <- read_tm_theme(fpath)

  expect_identical(res[res$name == "name", ]$value, "Skeletor Syntax")
  expect_identical(
    res[res$name == "semanticClass", ]$value,
    "theme.dark.skeletor_syntax"
  )
})

test_that("read_tm_theme() parses minimal TextMate themes", {
  fpath <- system.file("ext/test-minimal.tmTheme", package = "rstudiothemes")

  res <- read_tm_theme(fpath)

  expect_snapshot(unique(res$section))
  expect_snapshot(res$name)
})

test_that("read_tm_theme() reports invalid TextMate fixtures", {
  fpath <- system.file("ext/test-error.tmTheme", package = "rstudiothemes")

  expect_snapshot(
    error = TRUE,
    read_tm_theme(fpath),
    transform = function(lines) mask_fixture_path(lines, "test-error.tmTheme")
  )
})


test_that("read_tm_theme() downloads URL inputs", {
  tmtheme <- system.file("ext/test.tmTheme", package = "rstudiothemes")
  local_mock_theme_download(tmtheme)

  path <- paste0(
    "https://raw.githubusercontent.com/dieghernan/",
    "rstudiothemes/refs/heads/main/inst/ext/test.tmTheme"
  )

  expect_snapshot({
    res <- read_tm_theme(path)
    invisible(res)
  })
  expect_s3_class(res, "tbl_df")
})

test_that("read_tm_theme() handles empty token fields", {
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
