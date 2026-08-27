test_that("reader rejects missing paths, wrong extensions and missing files", {
  expect_snapshot(error = TRUE, read_vs_theme())
  expect_snapshot(error = TRUE, read_vs_theme("a.txt"))
  expect_snapshot(error = TRUE, read_vs_theme("a.json"))
})


test_that("full themes retain metadata and semantic token colors", {
  vstheme <- system.file("ext/test-color-theme.json", package = "rstudiothemes")

  res <- read_vs_theme(vstheme)

  expect_identical(res[res$name == "name", ]$value, "Tokyo Night")
  expect_identical(res[res$name == "type", ]$value, "dark")

  # Extract semanticTokenColors
  expect_contains(res$section, "semanticTokenColors")
})

test_that("themes without type metadata remain valid", {
  vstheme <- system.file(
    "ext/test-simple-color-theme.json",
    package = "rstudiothemes"
  )

  res <- read_vs_theme(vstheme)

  expect_identical(res[res$name == "name", ]$value, "Skeletor Syntax")
  expect_length(res[res$name == "type", ]$value, 0)
})

test_that("URL themes are downloaded before parsing", {
  vstheme <- system.file("ext/test-color-theme.json", package = "rstudiothemes")
  local_mock_theme_download(vstheme)

  path <- paste0(
    "https://raw.githubusercontent.com/dieghernan/",
    "rstudiothemes/refs/heads/main/inst/ext/test-color-theme.json"
  )

  expect_snapshot({
    res <- read_vs_theme(path)
    invisible(res)
  })
  expect_s3_class(res, "tbl_df")
})

test_that("comments and trailing commas in Jellyfish are accepted", {
  jelly <- system.file("ext/jellyfish.json", package = "rstudiothemes")

  expect_silent(df <- read_vs_theme(jelly))
  expect_s3_class(df, "tbl_df")
  expect_identical(df[df$name == "name", ]$value, "JellyFish Theme")

  expect_silent(out <- convert_vs_to_tm_theme(jelly))
  expect_true(file.exists(out))
  expect_identical(plist_top_value(out, "name"), "JellyFish Theme")
})

test_that("null color values are omitted from parsed themes", {
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

test_that("double slashes inside JSON strings are preserved", {
  theme <- withr::local_tempfile(fileext = ".json")
  writeLines(
    c(
      "{",
      '  "name": "https://example.com/themes//night", // inline comment',
      '  "colors": { "editor.background": "#000000" },',
      '  "tokenColors": []',
      "}"
    ),
    theme
  )

  parsed <- safe_read_json(theme)

  expect_identical(unlist(parsed$name), "https://example.com/themes//night")
})

test_that("the Positron reader alias returns the same parsed data", {
  vstheme <- system.file("ext/test-color-theme.json", package = "rstudiothemes")

  expect_identical(read_positron_theme(vstheme), read_vs_theme(vstheme))
})
