local_mock_rstudio_theme_build <- function(
  converted_name = "Converted Theme",
  env = NULL
) {
  if (is.null(env)) {
    env <- parent.frame()
  }
  captured <- new.env(parent = emptyenv())
  captured$sass_input <- NULL
  captured$sass_options_seen <- NULL

  local_mocked_bindings(
    require_rstudio = function(...) TRUE,
    rstudioapi_convert_theme = function(path,
                                        add = FALSE,
                                        output_location,
                                        force = TRUE) {
      writeLines(
        c(
          "/* rs-theme-name: Converted Theme */",
          ".ace_marker-layer .ace_selection { filter: blur(1px); }"
        ),
        file.path(output_location, "converted.rstheme")
      )
      converted_name
    },
    sass_options = function(output_style = "expanded") {
      list(output_style = output_style)
    },
    sass_sass = function(input, output, cache = FALSE, options = NULL) {
      captured$sass_input <- input
      captured$sass_options_seen <- options
      writeLines(input, output)
      output
    },
    .env = env
  )

  captured
}

test_that("convert_to_rstudio_theme() returns NULL outside RStudio", {
  local_mocked_bindings(require_rstudio = function(...) FALSE)

  expect_null(convert_to_rstudio_theme("theme.tmTheme"))
})

test_that("convert_to_rstudio_theme() reports invalid inputs", {
  local_mocked_bindings(require_rstudio = function(...) TRUE)

  expect_snapshot(error = TRUE, convert_to_rstudio_theme())
  expect_snapshot(error = TRUE, convert_to_rstudio_theme("a.txt"))
})

test_that("convert_to_rstudio_theme() writes from TextMate input", {
  captured <- local_mock_rstudio_theme_build()

  tmtheme <- system.file(
    "ext/test-minimal.tmTheme",
    package = "rstudiothemes"
  )
  outfile <- theme_output_path(".rstheme")

  result <- convert_to_rstudio_theme(
    tmtheme,
    outfile = outfile,
    name = "Mock theme",
    use_italics = FALSE,
    output_style = "compressed"
  )

  expect_identical(result, outfile)
  expect_true(file.exists(outfile))
  expect_identical(
    captured$sass_options_seen,
    list(output_style = "compressed")
  )
  expect_contains(
    captured$sass_input,
    "/* Generated with rstudiothemes package */"
  )
  expect_true(any(grepl(
    "rs-theme-name: Mock theme",
    captured$sass_input,
    fixed = TRUE
  )))
  expect_true(any(grepl(
    "brightness(75%)",
    captured$sass_input,
    fixed = TRUE
  )))
})

test_that("convert_to_rstudio_theme() converts VS Code JSON input first", {
  converted_path <- NULL
  local_mock_rstudio_theme_build()

  tmtheme <- system.file("ext/test-minimal.tmTheme", package = "rstudiothemes")
  local_mocked_bindings(
    convert_vs_to_tm_theme = function(path, outfile, name = NULL) {
      converted_path <<- outfile
      file.copy(tmtheme, outfile, overwrite = TRUE)
      outfile
    }
  )

  vstheme <- system.file(
    "ext/test-simple-color-theme.json",
    package = "rstudiothemes"
  )
  outfile <- theme_output_path(".rstheme")

  result <- convert_to_rstudio_theme(vstheme, outfile = outfile)

  expect_identical(result, outfile)
  expect_match(converted_path, "[.]tmTheme$")
  expect_true(file.exists(outfile))
})

test_that("convert_to_rstudio_theme() installs and applies themes", {
  added <- NULL
  applied <- NULL
  local_mock_rstudio_theme_build()
  local_mocked_bindings(
    rstudioapi_add_theme = function(theme, force = TRUE) {
      added <<- list(theme = theme, force = force)
      "Installed theme"
    },
    rstudioapi_apply_theme = function(theme) {
      applied <<- theme
    }
  )

  tmtheme <- system.file(
    "ext/test-minimal.tmTheme",
    package = "rstudiothemes"
  )
  outfile <- theme_output_path(".rstheme")

  result <- NULL
  expect_snapshot({
    result <- convert_to_rstudio_theme(
      tmtheme,
      outfile = outfile,
      name = "Applied theme",
      force = TRUE,
      apply = TRUE
    )
    invisible(result)
  })
  expect_identical(result, outfile)
  expect_identical(added, list(theme = outfile, force = TRUE))
  expect_identical(applied, "Applied theme")
})

test_that("convert_to_rstudio_theme() reports installation warnings", {
  local_mock_rstudio_theme_build()
  local_mocked_bindings(
    rstudioapi_add_theme = function(theme, force = TRUE) {
      simpleWarning("Theme already exists")
    }
  )

  tmtheme <- system.file("ext/test-minimal.tmTheme", package = "rstudiothemes")
  outfile <- theme_output_path(".rstheme")

  result <- NULL
  expect_snapshot({
    result <- convert_to_rstudio_theme(
      tmtheme,
      outfile = outfile,
      force = TRUE
    )
    invisible(result)
  })
  expect_identical(result, outfile)
})

test_that("convert_to_rstudio_theme() reports installation errors", {
  local_mock_rstudio_theme_build()
  local_mocked_bindings(
    rstudioapi_add_theme = function(theme, force = TRUE) {
      stop("Cannot install theme")
    }
  )

  tmtheme <- system.file("ext/test-minimal.tmTheme", package = "rstudiothemes")
  outfile <- theme_output_path(".rstheme")

  result <- NULL
  expect_snapshot({
    result <- convert_to_rstudio_theme(
      tmtheme,
      outfile = outfile,
      force = TRUE
    )
    invisible(result)
  })
  expect_identical(result, outfile)
})
