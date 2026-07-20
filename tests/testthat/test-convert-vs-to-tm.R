test_that("Errors", {
  expect_snapshot(error = TRUE, convert_vs_to_tm_theme())
  expect_snapshot(error = TRUE, convert_vs_to_tm_theme("a.txt"))
  expect_snapshot(error = TRUE, convert_vs_to_tm_theme("a.json"))

  # Theme with missing values
  vstheme <- system.file("ext/test-color-theme.json", package = "rstudiothemes")
  miss <- jsonlite::read_json(vstheme)
  miss$colors$editor.background <- NULL

  tmp_path <- withr::local_tempfile(fileext = ".json")
  jsonlite::write_json(miss, tmp_path)
  expect_snapshot(error = TRUE, convert_vs_to_tm_theme(tmp_path))
})

test_that("Theme creation - output path and return value", {
  tmout <- theme_output_path(".tmTheme")
  vstheme <- system.file("ext/test-color-theme.json", package = "rstudiothemes")

  expect_silent(thef <- convert_vs_to_tm_theme(vstheme, outfile = tmout))
  expect_identical(thef, tmout)
  expect_true(file.exists(thef))
})

test_that("Theme creation - file contents snapshot", {
  skip_on_cran()
  tmout <- theme_output_path(".tmTheme")
  vstheme <- system.file("ext/test-color-theme.json", package = "rstudiothemes")

  # Ensure file exists from conversion step
  expect_silent(convert_vs_to_tm_theme(vstheme, outfile = tmout))
  out <- readLines(tmout)
  out <- mask_uuid_in_lines(out)

  expect_snapshot(cat(out[seq(1, 500)], sep = "\n"))
})

test_that("Simple Theme creation - basic file generation", {
  tmout <- theme_output_path(".tmTheme")
  vstheme <- system.file(
    "ext/test-simple-color-theme.json",
    package = "rstudiothemes"
  )

  thef <- convert_vs_to_tm_theme(vstheme, outfile = tmout)

  expect_identical(thef, tmout)
  expect_true(file.exists(thef))

  out <- readLines(tmout)
  out <- mask_uuid_in_lines(out)
  expect_snapshot(cat(out[seq(1, 15)], sep = "\n"))
})

test_that("Simple Theme creation - with metadata", {
  tmout2 <- theme_output_path(".tmTheme")
  vstheme <- system.file(
    "ext/test-simple-color-theme.json",
    package = "rstudiothemes"
  )

  expect_silent(convert_vs_to_tm_theme(
    vstheme,
    outfile = tmout2,
    name = "A test theme",
    author = "I am"
  ))

  expect_true(file.exists(tmout2))
  out <- readLines(tmout2)
  out <- mask_uuid_in_lines(out)

  expect_snapshot(cat(out[seq(1, 15)], sep = "\n"))
})

test_that("Online", {
  skip_on_cran()
  vstheme <- system.file("ext/test-color-theme.json", package = "rstudiothemes")
  local_mock_theme_download(vstheme)

  path <- paste0(
    "https://raw.githubusercontent.com/dieghernan/",
    "rstudiothemes/refs/heads/main/inst/ext/test-color-theme.json"
  )
  expect_snapshot(thef <- convert_vs_to_tm_theme(path))
  read_tm <- read_tm_theme(thef)
  expect_s3_class(read_tm, "tbl_df")
})


test_that("Unnamed", {
  fpath <- system.file(
    "ext/test-unnamed-color-theme.json",
    package = "rstudiothemes"
  )

  expect_snapshot(error = TRUE, res <- convert_vs_to_tm_theme(fpath))
})

test_that("Unnamed themes require an explicit name", {
  fpath <- system.file(
    "ext/test-unnamed-color-theme.json",
    package = "rstudiothemes"
  )

  expect_snapshot(error = TRUE, convert_vs_to_tm_theme(fpath))
})

test_that("Corner cases", {
  # Missing components, invisibles, lineHighlight, and caret

  mapping <- read.csv(
    system.file("csv/mapping.csv", package = "rstudiothemes"),
    na.strings = c("NA", "")
  )
  vs_miss <- mapping[
    mapping$tm %in% c("invisibles", "lineHighlight", "caret"),
  ]$vscode

  vstheme <- system.file("ext/test-color-theme.json", package = "rstudiothemes")
  miss <- jsonlite::read_json(vstheme)

  miss$colors[vs_miss] <- NULL

  tmp_path <- withr::local_tempfile(fileext = ".json")
  jsonlite::write_json(miss, tmp_path)
  expect_silent(convert_vs_to_tm_theme(tmp_path))

  miss2 <- jsonlite::read_json(vstheme)
  miss2$tokenColors <- NULL
  miss2$semanticTokenColors <- NULL
  tmp_path <- withr::local_tempfile(fileext = ".json")
  jsonlite::write_json(miss2, tmp_path)
  expect_silent(convert_vs_to_tm_theme(tmp_path))
})

test_that("TextMate scope builders skip empty settings", {
  scope_row <- dplyr::tibble(
    name = NA_character_,
    scope = "source.r",
    foreground = NA_character_,
    background = NA_character_,
    fontStyle = NA_character_
  )

  expect_null(tmtheme_scope_settings(scope_row))
  expect_null(tmtheme_scope_item(scope_row))

  scope_row$foreground <- "#FFFFFF"
  item <- tmtheme_scope_item(scope_row)

  expect_identical(item$dict[[1]][[1]], "name")
  expect_identical(item$dict[[2]][[1]], "")
})
