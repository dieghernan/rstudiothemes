theme_output_path <- function(ext = ".tmTheme") {
  withr::local_tempfile(fileext = ext)
}

mask_uuid_in_lines <- function(lines) {
  mask_line <- min(grep(">uuid<", lines, fixed = TRUE))
  lines[mask_line + 1] <- "<string>(masked_uuid)</string>"
  lines
}

mask_fixture_path <- function(lines, filename) {
  fixture <- normalizePath(
    system.file("ext", filename, package = "rstudiothemes"),
    winslash = "/",
    mustWork = TRUE
  )
  gsub(fixture, paste0("<", filename, ">"), lines, fixed = TRUE)
}

plist_top_value <- function(path, key) {
  doc <- xml2::read_xml(path)
  keys <- xml2::xml_find_all(doc, "/plist/dict/key")
  key_index <- which(xml2::xml_text(keys) == key)[1]

  if (is.na(key_index)) {
    return(NULL)
  }

  xml2::xml_text(xml2::xml_find_first(
    keys[[key_index]],
    "following-sibling::*[1]"
  ))
}

plist_color_value <- function(path, key) {
  doc <- xml2::read_xml(path)
  settings <- xml2::xml_find_first(
    doc,
    "/plist/dict/key[. = 'settings']/following-sibling::array[1]/dict[1]/dict"
  )
  keys <- xml2::xml_find_all(settings, "./key")
  key_index <- which(xml2::xml_text(keys) == key)[1]

  if (is.na(key_index)) {
    return(NULL)
  }

  xml2::xml_text(xml2::xml_find_first(
    keys[[key_index]],
    "following-sibling::*[1]"
  ))
}

local_mock_theme_download <- function(source) {
  testthat::local_mocked_bindings(
    download_theme_file = function(url, destfile, quiet = TRUE, mode = "wb") {
      file.copy(source, destfile, overwrite = TRUE)
      invisible(0)
    },
    .env = parent.frame()
  )
}

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

  testthat::local_mocked_bindings(
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

local_mock_rstudio_preview <- function(answers = character(), env = NULL) {
  if (is.null(env)) {
    env <- parent.frame()
  }
  captured <- new.env(parent = emptyenv())
  captured$answers <- answers
  captured$applied <- character()
  captured$slept <- numeric()

  testthat::local_mocked_bindings(
    require_rstudio = function(...) TRUE,
    list_rstudiothemes = function(...) c("Light Theme", "Dark Theme"),
    list_pkg_rstudiothemes = function(style = c("all", "dark", "light"),
                                      themes = NULL) {
      style <- match.arg(style)
      if (style == "light") {
        return(structure("light.rstheme", names = "Light Theme"))
      }
      if (style == "dark") {
        return(structure("dark.rstheme", names = "Dark Theme"))
      }
      structure(
        c("light.rstheme", "dark.rstheme"),
        names = c("Light Theme", "Dark Theme")
      )
    },
    rstudioapi_get_theme_info = function() list(editor = "Original Theme"),
    rstudioapi_apply_theme = function(theme) {
      captured$applied <- c(captured$applied, theme)
    },
    rstudiothemes_readline = function(prompt) {
      response <- captured$answers[[1]]
      captured$answers <- captured$answers[-1]
      response
    },
    rstudiothemes_sleep = function(time) {
      captured$slept <- c(captured$slept, time)
    },
    .env = env
  )

  captured
}
