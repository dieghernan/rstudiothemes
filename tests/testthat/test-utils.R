test_that("Test color generator", {
  # Not parsed
  not <- "bold italic underline"
  expect_identical(not, col2hex(not))

  # Expand colors
  xpan <- "#FFF"
  expect_identical("#FFFFFF", expand_hex(xpan))
  expect_identical("#FFFFFF", col2hex(xpan))
  expect_identical("#FF002211", expand_hex("#F021"))
  expect_identical("#FF002211", col2hex("#F021"))
  expect_identical("not_a_color", expand_hex("not_a_color"))
  expect_snapshot(col2hex("not_a_color"))

  skip_on_cran()

  # Remove alpha if not needed
  alpha_1 <- "#FFF000FF"

  expect_identical("#FFF000", col2hex(alpha_1))

  # Keep alpha
  hex_alpha <- "#ff00008f"

  expect_snapshot(col2hex(hex_alpha))
})

test_that("Theme type", {
  expect_identical(dark_or_light("#fff"), "light")
  expect_identical(dark_or_light("#000"), "dark")
  expect_identical(dark_or_light("grey40"), "dark")
  expect_identical(dark_or_light("grey60"), "light")
  expect_identical(dark_or_light("skyblue"), "light")
  expect_identical(dark_or_light("darkblue"), "dark")
  expect_snapshot(error = TRUE, dark_or_light("not_a_color"))
})
