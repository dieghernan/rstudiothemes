test_that("Test full theme", {
  vstheme <- system.file("ext/test-color-theme.json",
    package = "rstudiothemes"
  )

  fpath <- vstheme |> vstheme2tmtheme()

  res <- read_tmtheme(fpath)

  expect_identical(res[res$name == "name", ]$value, "Tokyo Night")
  expect_identical(
    res[res$name == "semanticClass", ]$value,
    "theme.dark.tokyo_night"
  )

  unlink(fpath)
})

test_that("Test simple theme", {
  vstheme <- system.file("ext/test-simple-color-theme.json",
    package = "rstudiothemes"
  )

  fpath <- vstheme |> vstheme2tmtheme()

  res <- read_tmtheme(fpath)

  expect_identical(res[res$name == "name", ]$value, "Skeletor Syntax")
  expect_identical(
    res[res$name == "semanticClass", ]$value,
    "theme.dark.skeletor_syntax"
  )
  unlink(fpath)
})
