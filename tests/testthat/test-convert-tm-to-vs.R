test_that("conversion rejects invalid TextMate input paths", {
  expect_snapshot(error = TRUE, convert_tm_to_vs_theme())
  expect_snapshot(error = TRUE, convert_tm_to_vs_theme("a.txt"))
  expect_snapshot(error = TRUE, convert_tm_to_vs_theme("a.tmTheme"))
})


test_that("a complete TextMate theme produces mapped VS Code JSON", {
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
})

test_that("minimal TextMate metadata uses source defaults", {
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
})

test_that("explicit metadata overrides TextMate values", {
  tmout <- theme_output_path(".json")
  tmtheme <- system.file("ext/test-minimal.tmTheme", package = "rstudiothemes")

  expect_silent(convert_tm_to_vs_theme(
    tmtheme,
    outfile = tmout,
    name = "A test theme",
    author = "I am"
  ))

  expect_true(file.exists(tmout))
  json <- jsonlite::read_json(tmout)
  expect_identical(json$name, "A test theme")
  expect_identical(json$author, "I am")
  expect_identical(json$type, "dark")
})

test_that("conversion rejects TextMate themes missing required settings", {
  fpath <- system.file("ext/test-error.tmTheme", package = "rstudiothemes")

  expect_snapshot(
    error = TRUE,
    convert_tm_to_vs_theme(fpath),
    transform = function(lines) mask_fixture_path(lines, "test-error.tmTheme")
  )
})

test_that("the Skeletor conversion matches its golden file", {
  fpath <- system.file("ext/Skeletor_Syntax.tmTheme", package = "rstudiothemes")
  out <- convert_tm_to_vs_theme(fpath)
  expect_snapshot_file(
    out,
    "skeletor-syntax-color-theme.json",
    compare = compare_file_text
  )
})

test_that("URL TextMate inputs are downloaded and converted", {
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

test_that("dark high-contrast metadata produces hc-black output", {
  tmout <- theme_output_path(".json")
  tmtheme <- system.file("ext/test-hc-dark.tmTheme", package = "rstudiothemes")

  expect_true(file.exists(tmtheme))

  expect_snapshot(thef <- convert_tm_to_vs_theme(tmtheme, outfile = tmout))
  expect_identical(thef, tmout)
  ss <- read_vs_theme(tmout)
  expect_identical(ss[ss$name == "type", ]$value, "hc-black")
})

test_that("light high-contrast metadata produces hc-light output", {
  tmout <- theme_output_path(".json")
  tmtheme <- system.file("ext/test-hc-light.tmTheme", package = "rstudiothemes")

  expect_true(file.exists(tmtheme))

  expect_snapshot(thef <- convert_tm_to_vs_theme(tmtheme, outfile = tmout))
  expect_identical(thef, tmout)
  ss <- read_vs_theme(tmout)
  expect_identical(ss[ss$name == "type", ]$value, "hc-light")
})

test_that("token conversion keeps available styles and omits empty tokens", {
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

test_that("the Positron alias matches the VS Code converter", {
  tmtheme <- system.file("ext/test-minimal.tmTheme", package = "rstudiothemes")
  vscode_out <- theme_output_path(".json")
  positron_out <- theme_output_path(".json")

  convert_tm_to_vs_theme(tmtheme, outfile = vscode_out)
  convert_tm_to_positron_theme(tmtheme, outfile = positron_out)

  expect_identical(readLines(positron_out), readLines(vscode_out))
})
