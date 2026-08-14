test_that("convert_vs_to_tm_theme() reports invalid inputs", {
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

test_that("convert_vs_to_tm_theme() writes to the requested output path", {
  tmout <- theme_output_path(".tmTheme")
  vstheme <- system.file("ext/test-color-theme.json", package = "rstudiothemes")

  expect_silent(thef <- convert_vs_to_tm_theme(vstheme, outfile = tmout))
  expect_identical(thef, tmout)
  expect_true(file.exists(thef))
})

test_that("convert_vs_to_tm_theme() preserves TextMate metadata", {
  skip_on_cran()
  tmout <- theme_output_path(".tmTheme")
  vstheme <- system.file(
    "ext/test-color-theme.json",
    package = "rstudiothemes"
  )

  # Ensure file exists from conversion step
  expect_silent(convert_vs_to_tm_theme(vstheme, outfile = tmout))
  expect_identical(plist_top_value(tmout, "name"), "Tokyo Night")
  expect_identical(
    plist_top_value(tmout, "semanticClass"),
    "theme.dark.tokyo_night"
  )
  expect_identical(plist_color_value(tmout, "background"), "#1A1B26")
  expect_identical(plist_color_value(tmout, "foreground"), "#A9B1D6")
  expect_identical(plist_color_value(tmout, "selection"), "#515C7E4D")

  out <- readLines(tmout)
  out <- mask_uuid_in_lines(out)

  expect_snapshot(cat(out[seq(1, 500)], sep = "\n"))
})

test_that("convert_vs_to_tm_theme() converts simple themes", {
  tmout <- theme_output_path(".tmTheme")
  vstheme <- system.file(
    "ext/test-simple-color-theme.json",
    package = "rstudiothemes"
  )

  thef <- convert_vs_to_tm_theme(vstheme, outfile = tmout)

  expect_identical(thef, tmout)
  expect_true(file.exists(thef))
  expect_identical(plist_top_value(tmout, "name"), "Skeletor Syntax")
  expect_identical(
    plist_top_value(tmout, "author"),
    "rstudiothemes R package"
  )
  expect_identical(
    plist_top_value(tmout, "semanticClass"),
    "theme.dark.skeletor_syntax"
  )

  out <- readLines(tmout)
  out <- mask_uuid_in_lines(out)
  expect_snapshot(cat(out[seq(1, 15)], sep = "\n"))
})

test_that("convert_vs_to_tm_theme() uses explicit name and author metadata", {
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
  expect_identical(plist_top_value(tmout2, "name"), "A test theme")
  expect_identical(plist_top_value(tmout2, "author"), "I am")
  expect_identical(
    plist_top_value(tmout2, "semanticClass"),
    "theme.dark.a_test_theme"
  )

  out <- readLines(tmout2)
  out <- mask_uuid_in_lines(out)

  expect_snapshot(cat(out[seq(1, 15)], sep = "\n"))
})

test_that("convert_vs_to_tm_theme() downloads URL inputs", {
  vstheme <- system.file(
    "ext/test-color-theme.json",
    package = "rstudiothemes"
  )
  local_mock_theme_download(vstheme)

  path <- paste0(
    "https://raw.githubusercontent.com/dieghernan/",
    "rstudiothemes/refs/heads/main/inst/ext/test-color-theme.json"
  )
  thef <- NULL
  expect_snapshot({
    thef <- convert_vs_to_tm_theme(path)
    invisible(thef)
  })
  read_tm <- read_tm_theme(thef)
  expect_s3_class(read_tm, "tbl_df")
  expect_identical(plist_top_value(thef, "name"), "Tokyo Night")
})


test_that("convert_vs_to_tm_theme() requires unnamed theme overrides", {
  fpath <- system.file(
    "ext/test-unnamed-color-theme.json",
    package = "rstudiothemes"
  )

  expect_snapshot(error = TRUE, convert_vs_to_tm_theme(fpath))
})

test_that("convert_vs_to_tm_theme() fills optional settings", {
  # Missing components, invisibles, lineHighlight, and caret

  mapping <- read.csv(
    system.file("csv/mapping.csv", package = "rstudiothemes"),
    na.strings = c("NA", "")
  )
  vs_miss <- mapping[
    mapping$tm %in% c("invisibles", "lineHighlight", "caret"),
  ]$vscode

  vstheme <- system.file(
    "ext/test-color-theme.json",
    package = "rstudiothemes"
  )
  miss <- jsonlite::read_json(vstheme)

  miss$colors[vs_miss] <- NULL

  tmp_path <- withr::local_tempfile(fileext = ".json")
  jsonlite::write_json(miss, tmp_path)
  out <- convert_vs_to_tm_theme(tmp_path)
  expect_identical(plist_color_value(out, "caret"), "#A9B1D6")
  expect_identical(plist_color_value(out, "invisibles"), "#515C7E4D")
  expect_identical(plist_color_value(out, "lineHighlight"), "#515C7E4D")

  miss2 <- jsonlite::read_json(vstheme)
  miss2$tokenColors <- NULL
  miss2$semanticTokenColors <- NULL
  tmp_path <- withr::local_tempfile(fileext = ".json")
  jsonlite::write_json(miss2, tmp_path)
  out <- convert_vs_to_tm_theme(tmp_path)
  expect_identical(plist_top_value(out, "name"), "Tokyo Night")
  expect_identical(plist_color_value(out, "background"), "#1A1B26")
  expect_identical(plist_color_value(out, "foreground"), "#A9B1D6")
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
