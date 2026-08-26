test_that("convert_tm_to_vs_theme() reports invalid inputs", {
  expect_snapshot(error = TRUE, convert_tm_to_vs_theme())
  expect_snapshot(error = TRUE, convert_tm_to_vs_theme("a.txt"))
  expect_snapshot(error = TRUE, convert_tm_to_vs_theme("a.tmTheme"))
})


test_that("convert_tm_to_vs_theme() writes expected VS Code JSON", {
  tmout <- theme_output_path(".json")
  tmtheme <- system.file("ext/test.tmTheme", package = "rstudiothemes")

  expect_silent(thef <- convert_tm_to_vs_theme(tmtheme, outfile = tmout))
  expect_true(file.exists(thef))
  expect_identical(thef, tmout)
  json <- jsonlite::read_json(tmout)
  expect_identical(json$name, "Testing RStudioTheme")
  expect_identical(json$type, "dark")
  expect_contains(names(json), c("colors", "tokenColors"))
  expect_identical(json$colors$editor.background, "#2B2836")
  expect_identical(json$colors$editor.foreground, "#DCE7FD")
  expect_gt(length(json$tokenColors), 1)

  skip_on_cran()

  out <- readLines(tmout)

  expect_snapshot(cat(out, sep = "\n"))
})

test_that("convert_tm_to_vs_theme() handles minimal theme metadata", {
  tmout <- theme_output_path(".json")
  tmtheme <- system.file("ext/test-minimal.tmTheme", package = "rstudiothemes")

  expect_true(file.exists(tmtheme))

  thef <- convert_tm_to_vs_theme(tmtheme, outfile = tmout)

  expect_identical(thef, tmout)
  json <- jsonlite::read_json(tmout)
  expect_identical(json$name, "Empty theme")
  expect_identical(json$author, "dieghernan")
  expect_identical(json$type, "dark")
  expect_contains(
    names(json$colors),
    c("editor.background", "editor.foreground")
  )

  out <- readLines(tmout)

  expect_snapshot(cat(out, sep = "\n"))

  tmout2 <- theme_output_path(".json")
  expect_silent(convert_tm_to_vs_theme(
    tmtheme,
    outfile = tmout2,
    name = "A test theme",
    author = "I am"
  ))

  expect_true(file.exists(tmout2))
  json <- jsonlite::read_json(tmout2)
  expect_identical(json$name, "A test theme")
  expect_identical(json$author, "I am")
  expect_identical(json$type, "dark")

  out <- readLines(tmout2)

  expect_snapshot(cat(out, sep = "\n"))
})

test_that("convert_tm_to_vs_theme() reports invalid TextMate fixtures", {
  fpath <- system.file("ext/test-error.tmTheme", package = "rstudiothemes")

  expect_snapshot(
    error = TRUE,
    convert_tm_to_vs_theme(fpath),
    transform = function(lines) mask_fixture_path(lines, "test-error.tmTheme")
  )
})

test_that("convert_tm_to_vs_theme() matches the Skeletor snapshot", {
  fpath <- system.file("ext/Skeletor_Syntax.tmTheme", package = "rstudiothemes")
  out <- convert_tm_to_vs_theme(fpath)
  expect_snapshot_file(
    out,
    "skeletor-syntax-color-theme.json",
    compare = compare_file_text
  )
})

test_that("convert_tm_to_vs_theme() downloads URL inputs", {
  tmtheme <- system.file("ext/test.tmTheme", package = "rstudiothemes")
  local_mock_theme_download(tmtheme)

  path <- paste0(
    "https://raw.githubusercontent.com/dieghernan/",
    "rstudiothemes/refs/heads/main/inst/ext/test.tmTheme"
  )

  expect_snapshot({
    res <- convert_tm_to_vs_theme(path)
    invisible(res)
  })
  df_json <- read_vs_theme(res)
  expect_s3_class(df_json, "tbl_df")
  json <- jsonlite::read_json(res)
  expect_identical(json$name, "Testing RStudioTheme")
})

test_that("convert_tm_to_vs_theme() infers dark high contrast themes", {
  tmout <- theme_output_path(".json")
  tmtheme <- system.file("ext/test-hc-dark.tmTheme", package = "rstudiothemes")

  expect_true(file.exists(tmtheme))

  expect_snapshot(thef <- convert_tm_to_vs_theme(tmtheme, outfile = tmout))
  expect_identical(thef, tmout)
  ss <- read_vs_theme(tmout)
  expect_identical(ss[ss$name == "type", ]$value, "hc-black")
})

test_that("convert_tm_to_vs_theme() infers light high contrast themes", {
  tmout <- theme_output_path(".json")
  tmtheme <- system.file("ext/test-hc-light.tmTheme", package = "rstudiothemes")

  expect_true(file.exists(tmtheme))

  expect_snapshot(thef <- convert_tm_to_vs_theme(tmtheme, outfile = tmout))
  expect_identical(thef, tmout)
  ss <- read_vs_theme(tmout)
  expect_identical(ss[ss$name == "type", ]$value, "hc-light")
})

test_that("TextMate token conversion handles optional settings", {
  token <- data.frame(
    name = "Token",
    sc = "source.r, keyword",
    foreground = NA_character_,
    background = "#111111",
    fontStyle = NA_character_
  )

  expect_identical(
    tmtheme_vs_token(token)$settings,
    list(background = "#111111")
  )
  expect_identical(tmtheme_vs_token(token)$scope, c("source.r", "keyword"))

  token$background <- NA_character_
  expect_null(tmtheme_vs_token(token))
})
