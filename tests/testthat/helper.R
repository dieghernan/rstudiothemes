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

local_mock_theme_download <- function(source) {
  local_mocked_bindings(
    download_theme_file = function(url, destfile, quiet = TRUE, mode = "wb") {
      file.copy(source, destfile, overwrite = TRUE)
      invisible(0)
    },
    .env = parent.frame()
  )
}
