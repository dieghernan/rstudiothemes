test_that("Errors", {
  expect_snapshot(error = TRUE, convert_vs_to_tm_theme())
  expect_snapshot(error = TRUE, convert_vs_to_tm_theme("a.txt"))
  expect_snapshot(error = TRUE, convert_vs_to_tm_theme("a.json"))
})


test_that("Theme creation", {
  tmout <- file.path(tempdir(), "my_test.tmTheme")
  vstheme <- system.file("ext/test-color-theme.json", package = "rstudiothemes")

  expect_silent(
    thef <- convert_vs_to_tm_theme(vstheme, outfile = tmout)
  )
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
