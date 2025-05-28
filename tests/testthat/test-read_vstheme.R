test_that("Test full theme", {
  vstheme <- system.file("ext/test-color-theme.json",
    package = "rstudiothemes"
  )

  res <- read_vstheme(vstheme)

  expect_identical(res[res$name == "name", ]$value, "Tokyo Night")
  expect_identical(res[res$name == "type", ]$value, "dark")


  # Extract semanticTokenColors
  expect_true("semanticTokenColors" %in% res$section)
})

test_that("Test simple theme", {
  vstheme <- system.file("ext/test-simple-color-theme.json",
    package = "rstudiothemes"
  )

  res <- read_vstheme(vstheme)

  expect_identical(res[res$name == "name", ]$value, "Skeletor Syntax")
  expect_length(res[res$name == "type", ]$value, 0)
})
