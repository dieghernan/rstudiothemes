test_that("Errors", {
  expect_snapshot(error = TRUE, convert_vs_to_tm_theme())
  expect_snapshot(error = TRUE, convert_vs_to_tm_theme("a.txt"))
  expect_snapshot(error = TRUE, convert_vs_to_tm_theme("a.json"))

  # Theme with missing values
  vstheme <- system.file("ext/test-color-theme.json", package = "rstudiothemes")
  miss <- jsonlite::read_json(vstheme)
  miss$colors$editor.background <- NULL

  tmp_path <- tempfile("corrupt", fileext = ".json")
  jsonlite::write_json(miss, tmp_path)
  expect_snapshot(convert_vs_to_tm_theme(tmp_path), error = TRUE)
})

test_that("Theme creation", {
  tmout <- file.path(tempdir(), "my_test.tmTheme")
  vstheme <- system.file("ext/test-color-theme.json", package = "rstudiothemes")

  expect_silent(thef <- convert_vs_to_tm_theme(vstheme, outfile = tmout))
  expect_true(file.exists(thef))
  expect_identical(thef, tmout)

  skip_on_cran()

  out <- readLines(tmout)

  # Mask uuid from snapshot
  remove <- min(grep(">uuid<", out, fixed = TRUE)) + 1
  out[remove] <- "<string>(masked_uuid)</string>"

  expect_snapshot(cat(out[seq(1, 500)], sep = "\n"))
  unlink(tmout)
})

test_that("Simple Theme creation", {
  tmout <- file.path(tempdir(), "my_test_simple.tmTheme")
  vstheme <- system.file(
    "ext/test-simple-color-theme.json",
    package = "rstudiothemes"
  )

  thef <- convert_vs_to_tm_theme(vstheme, outfile = tmout)

  expect_true(file.exists(thef))
  expect_identical(thef, tmout)
  out <- readLines(tmout)

  # Mask uuid from snapshot
  remove <- min(grep(">uuid<", out, fixed = TRUE)) + 1
  out[remove] <- "<string>(masked_uuid)</string>"

  expect_snapshot(cat(out[seq(1, 15)], sep = "\n"))
  unlink(tmout)

  tmout2 <- file.path(tempdir(), "my_test_simple_params.tmTheme")
  expect_silent(convert_vs_to_tm_theme(
    vstheme,
    outfile = tmout2,
    name = "A test theme",
    author = "I am"
  ))

  expect_true(file.exists(tmout2))
  out <- readLines(tmout2)

  # Mask uuid from snapshot
  remove <- min(grep(">uuid<", out, fixed = TRUE)) + 1
  out[remove] <- "<string>(masked_uuid)</string>"

  expect_snapshot(cat(out[seq(1, 15)], sep = "\n"))
  unlink(tmout2)
})

test_that("Online", {
  skip_on_cran()

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

  expect_error(
    convert_vs_to_tm_theme(fpath),
    regexp = "Theme name not found"
  )
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

  tmp_path <- tempfile("corrupt", fileext = ".json")
  jsonlite::write_json(miss, tmp_path)
  expect_silent(convert_vs_to_tm_theme(tmp_path))

  miss2 <- jsonlite::read_json(vstheme)
  miss2$tokenColors <- NULL
  miss2$semanticTokenColors <- NULL
  tmp_path <- tempfile("corrupt2", fileext = ".json")
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
