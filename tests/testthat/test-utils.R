test_that("col2hex() normalizes color names, hex values and alpha channels", {
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

test_that("dark_or_light() classifies colors by brightness", {
  expect_identical(dark_or_light("#fff"), "light")
  expect_identical(dark_or_light("#000"), "dark")
  expect_identical(dark_or_light("grey40"), "dark")
  expect_identical(dark_or_light("grey60"), "light")
  expect_identical(dark_or_light("skyblue"), "light")
  expect_identical(dark_or_light("darkblue"), "dark")
  expect_snapshot(error = TRUE, dark_or_light("not_a_color"))
})

test_that("match_arg_pretty() reports invalid choices with helpful errors", {
  my_fun <- function(arg_one = c(10, 1000, 3000, 5000)) {
    match_arg_pretty(arg_one)
  }

  # Single value no match
  expect_snapshot(my_fun("error here"), error = TRUE)

  # Several values no match
  expect_snapshot(my_fun(c("an", "error")), error = TRUE)

  # One value regex
  expect_snapshot(my_fun("5"), error = TRUE)
  # Several value regex
  expect_snapshot(my_fun("00"), error = TRUE)

  my_fun2 <- function(year = 20) {
    match_arg_pretty(year)
  }

  # Pass more options than expected
  expect_snapshot(my_fun2(c(1, 2)), error = TRUE)
})

test_that("match_arg_pretty() returns exact, default and custom matches", {
  my_fun <- function(arg_one = c(10, 1000, 3000, 5000)) {
    match_arg_pretty(arg_one)
  }

  expect_identical(my_fun(1000), "1000")
  expect_identical(my_fun("1000"), "1000")
  expect_identical(my_fun(NULL), "10")
  expect_identical(my_fun(), "10")

  my_fun2 <- function(an_arg = 20) {
    match_arg_pretty(an_arg, c("30", "20"))
  }
  expect_identical(my_fun2(), "20")
  expect_snapshot(my_fun2("3"), error = TRUE)
})

test_that("ensure_null() collapses empty values and preserves real values", {
  expect_null(ensure_null(NULL))
  expect_null(ensure_null(c(NULL, NA)))
  expect_null(ensure_null(c(NULL, NA, "")))
  expect_null(ensure_null(c("", character(0))))
  expect_identical(ensure_null(c(1, 2)), c(1, 2))
})

test_that("text normalization and mapping helpers return usable data", {
  expect_identical(normalize_theme_text("  a  b   c  "), "a b c")

  mapping <- theme_mapping()
  expect_s3_class(mapping, "data.frame")
  expect_contains(names(mapping), c("vscode", "tm"))
})

test_that("require_rstudio() succeeds inside RStudio", {
  local_mocked_bindings(on_rstudio = function() TRUE)

  expect_true(require_rstudio("test"))
})

test_that("require_rstudio() reports non-RStudio sessions", {
  local_mocked_bindings(
    on_rstudio = function() FALSE,
    detect_gui = function() "RTerm"
  )

  expect_snapshot(s <- require_rstudio("test"))
  expect_false(on_rstudio())
  expect_false(s)
})

test_that("local_theme_file() resolves local paths and downloads URLs", {
  local_file <- withr::local_tempfile(fileext = ".json")
  writeLines("{}", local_file)

  expect_identical(local_theme_file(local_file, "json"), local_file)
  expect_snapshot(error = TRUE, local_theme_file("missing.json", "json"))

  local_mocked_bindings(
    download_theme_file = function(url, destfile, quiet = TRUE, mode = "wb") {
      writeLines("{}", destfile)
      invisible(0)
    }
  )

  downloaded <- local_theme_file("https://example.com/theme.json", "json")
  expect_true(file.exists(downloaded))
  expect_match(basename(downloaded), "[.]json$")
})
