## code to `download_themes`

devtools::load_all()

# cobalt ---

url <- file.path(
  "https://raw.githubusercontent.com/wesbos/",
  "cobalt2-vscode/refs/heads/master/theme/cobalt2.json"
)


dest <- file.path("data-raw", "themes", "src", basename(url))
download.file(url, dest, mode = "wb")


# Generate rstheme
dd <- convert_vs_to_tm_theme(
  dest,
  "data-raw/tmthemes/cobalt2.tmTheme",
  author = "Wes Bos",
  name = "cobalt2"
)

# nord -----

url <- file.path(
  "https://raw.githubusercontent.com/nordtheme/visual-studio-code/refs/heads/",
  "develop/themes/nord-color-theme.json"
)


dest <- file.path("data-raw", "themes", "src", basename(url))
download.file(url, dest, mode = "wb")


# Generate rstheme
convert_to_rstudio_theme("<path/to/file>", apply = TRUE, force = TRUE)
dd <- convert_to_rstudio_theme(
  dest,
  "inst/rsthemes/Nord.rstheme",
  force = TRUE,
  apply = TRUE
)
