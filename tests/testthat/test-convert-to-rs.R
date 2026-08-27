test_that("conversion stops cleanly when RStudio is unavailable", {
  local_mocked_bindings(require_rstudio = function(...) FALSE)

  expect_null(convert_to_rstudio_theme("theme.tmTheme"))
})

test_that("conversion rejects missing paths and unsupported extensions", {
  local_mocked_bindings(require_rstudio = function(...) TRUE)

  expect_snapshot(error = TRUE, convert_to_rstudio_theme())
  expect_snapshot(error = TRUE, convert_to_rstudio_theme("a.txt"))
})

test_that("TextMate input produces customized RStudio CSS", {
  captured <- local_mock_rstudio_theme_build()

  tmtheme <- system.file("ext/test-minimal.tmTheme", package = "rstudiothemes")
  outfile <- theme_output_path(".rstheme")

  result <- convert_to_rstudio_theme(
    tmtheme,
    outfile = outfile,
    name = "Mock theme",
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
    "/* Generated with the rstudiothemes R package */"
  )
  expect_true(any(grepl(
    "rs-theme-name: Mock theme",
    captured$sass_input,
    fixed = TRUE
  )))
  expect_true(any(grepl("brightness(75%)", captured$sass_input, fixed = TRUE)))
})

test_that("italic styles can be included or removed", {
  captured <- local_mock_rstudio_theme_build()
  tmtheme <- system.file(
    "ext/Skeletor_Syntax.tmTheme",
    package = "rstudiothemes"
  )

  convert_to_rstudio_theme(
    tmtheme,
    outfile = theme_output_path(".rstheme"),
    use_italics = FALSE
  )
  without_italics <- captured$sass_input

  convert_to_rstudio_theme(
    tmtheme,
    outfile = theme_output_path(".rstheme"),
    use_italics = TRUE
  )
  with_italics <- captured$sass_input

  expect_length(grep("font-style: italic", without_italics, fixed = TRUE), 1L)
  expect_gt(length(grep("font-style: italic", with_italics, fixed = TRUE)), 1L)
})

test_that("ACE cascades inherit colors but not higher-level font styles", {
  scopes <- data.frame(
    scope = c("comment", "comment.block.r"),
    foreground = c("#222222", "#111111"),
    background = c(NA_character_, "#000000"),
    fontStyle = c("bold", "italic")
  )

  cascade <- create_ace_cascade(scopes)
  top <- cascade[cascade$rstheme == ".ace_comment", ]
  middle <- cascade[cascade$rstheme == ".ace_comment.ace_block", ]
  leaf <- cascade[cascade$rstheme == ".ace_comment.ace_block.ace_r", ]

  expect_identical(top$foreground, "#222222")
  expect_identical(top$fontStyle, "bold")
  expect_identical(middle$foreground, "#111111")
  expect_true(is.na(middle$fontStyle))
  expect_identical(leaf$background, "#000000")
  expect_identical(leaf$fontStyle, "italic")
})

test_that("scope aliases produce heading, link and XML ACE selectors", {
  captured <- local_mock_rstudio_theme_build()
  tmtheme <- system.file("ext/test.tmTheme", package = "rstudiothemes")

  convert_to_rstudio_theme(tmtheme, outfile = theme_output_path(".rstheme"))
  css <- paste(captured$sass_input, collapse = "\n")

  expect_match(css, ".ace_heading", fixed = TRUE)
  expect_match(css, ".ace_markup.ace_href", fixed = TRUE)
  expect_match(css, ".ace_xml-pe", fixed = TRUE)
})

test_that("guide colors produce ruler and indent guide CSS", {
  captured <- local_mock_rstudio_theme_build()
  tmtheme <- system.file("ext/test-hc-dark.tmTheme", package = "rstudiothemes")

  convert_to_rstudio_theme(tmtheme, outfile = theme_output_path(".rstheme"))
  css <- paste(captured$sass_input, collapse = "\n")

  expect_match(
    css,
    ".ace_print-margin {background: #4C4C4C;}",
    fixed = TRUE
  )
  expect_match(
    css,
    paste0(
      ".ace_line .ace_indent-guide { background: linear-gradient(to left, ",
      "#FCC36E 1px, transparent 1px, transparent); }"
    ),
    fixed = TRUE
  )
})

test_that("Visual Studio Code input is converted through TextMate", {
  converted_path <- NULL
  local_mock_rstudio_theme_build()

  tmtheme <- system.file("ext/test-minimal.tmTheme", package = "rstudiothemes")
  local_mocked_bindings(convert_vs_to_tm_theme = function(
    path,
    outfile,
    name = NULL
  ) {
    converted_path <<- outfile
    file.copy(tmtheme, outfile, overwrite = TRUE)
    outfile
  })

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

test_that("successful installation applies the requested theme", {
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

  tmtheme <- system.file("ext/test-minimal.tmTheme", package = "rstudiothemes")
  outfile <- theme_output_path(".rstheme")

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

test_that("installation warnings still allow an existing theme to be applied", {
  applied <- NULL
  local_mock_rstudio_theme_build()
  local_mocked_bindings(
    rstudioapi_add_theme = function(theme, force = TRUE) {
      warning("Theme {already} exists", call. = FALSE)
    },
    rstudioapi_apply_theme = function(theme) {
      applied <<- theme
    }
  )

  tmtheme <- system.file("ext/test-minimal.tmTheme", package = "rstudiothemes")
  outfile <- theme_output_path(".rstheme")

  expect_snapshot({
    result <- convert_to_rstudio_theme(
      tmtheme,
      outfile = outfile,
      force = TRUE,
      apply = TRUE
    )
    invisible(result)
  })
  expect_identical(result, outfile)
  expect_identical(applied, "Converted Theme")
})

test_that("installation errors prevent the theme from being applied", {
  applied <- NULL
  local_mock_rstudio_theme_build()
  local_mocked_bindings(
    rstudioapi_add_theme = function(theme, force = TRUE) {
      stop("Cannot install {theme}", call. = FALSE)
    },
    rstudioapi_apply_theme = function(theme) {
      applied <<- theme
    }
  )

  tmtheme <- system.file("ext/test-minimal.tmTheme", package = "rstudiothemes")
  outfile <- theme_output_path(".rstheme")

  expect_snapshot({
    result <- convert_to_rstudio_theme(
      tmtheme,
      outfile = outfile,
      force = TRUE,
      apply = TRUE
    )
    invisible(result)
  })
  expect_identical(result, outfile)
  expect_null(applied)
})
