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

test_that("Pretty match", {
  skip_on_cran()
  my_fun <- function(
    arg_one = c(10, 1000, 3000, 5000)
  ) {
    match_arg_pretty(arg_one)
  }

  # OK, returns character
  expect_identical(my_fun(1000), "1000")
  expect_identical(my_fun("1000"), "1000")
  expect_identical(my_fun(NULL), "10")
  expect_identical(my_fun(), "10")
  # Some errors here
  # Single value no match
  expect_snapshot(
    my_fun("error here"),
    error = TRUE
  )

  # Several values no match
  expect_snapshot(
    my_fun(c("an", "error")),
    error = TRUE
  )

  # One value regex
  expect_snapshot(
    my_fun("5"),
    error = TRUE
  )
  # Several value regex
  expect_snapshot(
    my_fun("00"),
    error = TRUE
  )

  my_fun2 <- function(year = 20) {
    match_arg_pretty(year)
  }

  # Pass more options than expected
  expect_snapshot(
    my_fun2(c(1, 2)),
    error = TRUE
  )

  # With custom options
  my_fun3 <- function(an_arg = 20) {
    match_arg_pretty(an_arg, c("30", "20"))
  }
  expect_identical(my_fun3(), "20")
  expect_snapshot(my_fun3("3"), error = TRUE)
  # Pass more options than expected
  expect_snapshot(
    my_fun2(c(1, 2)),
    error = TRUE
  )
})


test_that("Ensure NULL", {
  expect_null(ensure_null(NULL))
  expect_null(ensure_null(c(NULL, NA)))
  expect_null(ensure_null(c(NULL, NA, "")))
  expect_null(ensure_null(c("", character(0))))
  expect_identical(ensure_null(c(1, 2)), c(1, 2))
  expect_identical(letters, letters)
})
