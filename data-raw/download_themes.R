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
