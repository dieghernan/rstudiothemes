test_that("Errors", {
  expect_snapshot(error = TRUE, convert_tm_to_vs_theme())
  expect_snapshot(error = TRUE, convert_tm_to_vs_theme("a.txt"))
  expect_snapshot(error = TRUE, convert_tm_to_vs_theme("a.tmTheme"))
})


test_that("Theme creation", {
  tmout <- file.path(tempdir(), "my_test.tmTheme")
  tmtheme <- system.file("ext/test.tmTheme", package = "rstudiothemes")

  expect_silent(thef <- convert_tm_to_vs_theme(tmtheme, outfile = tmout))
  expect_true(file.exists(thef))
  expect_identical(thef, tmout)

  skip_on_cran()

  out <- readLines(tmout)

  expect_snapshot(cat(out, sep = "\n"))
  unlink(tmout)
})

test_that("Simple Theme creation", {
  tmout <- file.path(tempdir(), "my_test_simple.json")
  tmtheme <- system.file("ext/test-minimal.tmTheme", package = "rstudiothemes")

  expect_true(file.exists(tmtheme))

  thef <- convert_tm_to_vs_theme(tmtheme, outfile = tmout)

  expect_identical(thef, tmout)
  out <- readLines(tmout)

  expect_snapshot(cat(out, sep = "\n"))
  unlink(tmout)

  tmout2 <- file.path(tempdir(), "my_test_simple_params.tmTheme")
  expect_silent(convert_tm_to_vs_theme(
    tmtheme,
    outfile = tmout2,
    name = "A test theme",
    author = "I am"
  ))

  expect_true(file.exists(tmout2))
  out <- readLines(tmout2)

  expect_snapshot(cat(out, sep = "\n"))
  unlink(tmout2)
})

test_that("Test error theme", {
  fpath <- system.file("ext/test-error.tmTheme", package = "rstudiothemes")

  expect_error(
    res <- convert_tm_to_vs_theme(fpath),
    regexp = 'Required setting "lineHighlight" and "selection" are missing'
  )
})

test_that("Produce the same results", {
  fpath <- system.file("ext/Skeletor_Syntax.tmTheme", package = "rstudiothemes")
  out <- convert_tm_to_vs_theme(fpath)
  expect_snapshot_file(
    out,
    "skeletor-syntax-color-theme.json",
    compare = compare_file_text
  )
})

test_that("Online", {
  skip_on_cran()

  path <- paste0(
    "https://raw.githubusercontent.com/dieghernan/",
    "rstudiothemes/refs/heads/main/inst/ext/test.tmTheme"
  )

  expect_snapshot(res <- convert_tm_to_vs_theme(path))
  df_json <- read_vs_theme(res)
  expect_s3_class(df_json, "tbl_df")
})

test_that("No author, high contrast", {
  tmout <- file.path(tempdir(), "my_test_author.json")
  tmtheme <- system.file("ext/test-hc-dark.tmTheme", package = "rstudiothemes")

  expect_true(file.exists(tmtheme))

  expect_snapshot(
    thef <- convert_tm_to_vs_theme(tmtheme, outfile = tmout)
  )
  expect_identical(thef, tmout)
  ss <- read_vs_theme(tmout)
  expect_identical(ss[ss$name == "type", ]$value, "hc-black")
  unlink(tmout)
  # Light
  tmtheme <- system.file("ext/test-hc-light.tmTheme", package = "rstudiothemes")

  expect_snapshot(
    thef <- convert_tm_to_vs_theme(tmtheme, outfile = tmout)
  )
  ss <- read_vs_theme(tmout)
  expect_identical(ss[ss$name == "type", ]$value, "hc-light")
})

test_that("TextMate token conversion handles backgrounds and empty settings", {
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
  expect_identical(
    tmtheme_vs_token(token)$scope,
    c("source.r", "keyword")
  )

  token$background <- NA_character_
  expect_null(tmtheme_vs_token(token))
})
