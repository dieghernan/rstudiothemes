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
