paste0(
  "https://github.com/catppuccin/vscode/releases/download/",
  "catppuccin-vsc-v3.18.1/catppuccin-vsc-3.18.1.vsix"
) |>
  download.file("data-raw/catppucin.vsix", mode = "wb")

dir.create("data-raw/catppucin")
unzip("data-raw/catppucin.vsix", exdir = "data-raw/catppucin", junkpaths = TRUE)

list.files("data-raw/catppucin", pattern = ".json", full.names = TRUE) |>
  file.copy("data-raw/vscode_themes")

unlink("data-raw/catppucin.vsix", force = TRUE)
unlink("data-raw/catppucin", force = TRUE, recursive = TRUE)
