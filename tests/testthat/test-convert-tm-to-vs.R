test_that("Errors", {
  expect_snapshot(error = TRUE, convert_tm_to_vs_theme())
  expect_snapshot(error = TRUE, convert_tm_to_vs_theme("a.txt"))
  expect_snapshot(error = TRUE, convert_tm_to_vs_theme("a.tmTheme"))
})


test_that("Theme creation", {
  tmout <- file.path(tempdir(), "my_test.tmTheme")
  tmtheme <- system.file("ext/test.tmTheme", package = "rstudiothemes")

  expect_silent(
    thef <- convert_tm_to_vs_theme(tmtheme, outfile = tmout)
  )
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
  fpath <- system.file(
    "ext/test-error.tmTheme",
    package = "rstudiothemes"
  )

  expect_error(
    res <- convert_tm_to_vs_theme(fpath),
    regexp = '"lineHighlight" and "selection" values are'
  )
})

test_that("Produce the same results", {
  fpath <- system.file(
    "ext/Skeletor_Syntax.tmTheme",
    package = "rstudiothemes"
  )
  out <- convert_tm_to_vs_theme(fpath)
  expect_snapshot_file(
    out,
    "skeletor-syntax-color-theme.json",
    compare = compare_file_text
  )
})
