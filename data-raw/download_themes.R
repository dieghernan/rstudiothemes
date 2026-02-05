## code to `download_themes`

devtools::load_all()

# cobalt ---

url <- paste0(
  "https://raw.githubusercontent.com/wesbos/",
  "cobalt2-vscode/refs/heads/master/theme/cobalt2.json"
)

dest <- file.path("inst", "rsthemes", basename(url))
dest <- gsub("json$|tmtheme$", "rstheme", dest, ignore.case = TRUE)

# Generate rstheme
dd <- convert_to_rstudio_theme(
  url,
  dest,
  name = "cobalt2"
)

# cran -------------------------------------------------------------------
url <- paste0(
  "https://raw.githubusercontent.com/dieghernan/pretty-themes/",
  "refs/heads/main/dist/tmTheme/cran.tmTheme"
)

dest <- file.path("inst", "rsthemes", basename(url))
dest <- gsub("json$|tmtheme$", "rstheme", dest, ignore.case = TRUE)

# Generate rstheme
dd <- convert_to_rstudio_theme(
  url,
  dest
)

# dracula (build) --------------------------------------------------------

in_terminal <-
  "
git clone https://github.com/dracula/visual-studio-code.git data-raw/theme-dracula
cd ./data-raw/theme-dracula

npm install
npm run build
cd ../..

"

# Generate rstheme
dd <- convert_to_rstudio_theme(
  "./data-raw/theme-dracula/theme/dracula.json",
  "inst/rsthemes/Dracula2025.rstheme",
  name = "Dracula2025"
)

# Remove on terminal
"
rm -rf ./data-raw/theme-dracula

"

# github ------------------------------------------------------------
# https://marketplace.visualstudio.com/items?itemName=GitHub.github-vscode-theme
dd <- convert_to_rstudio_theme(
  "data-raw/themes/dark.json",
  "inst/rsthemes/GitHub_Dark.rstheme",
  name = "GitHub Dark"
)

dd <- convert_to_rstudio_theme(
  "data-raw/themes/light.json",
  "inst/rsthemes/GitHub_Light.rstheme",
  name = "GitHub Light"
)
# JellyFish -------------------------------------------------------------------

dd <- convert_to_rstudio_theme(
  "data-raw/themes/JellyFish Theme-color-theme.json",
  "inst/rsthemes/JellyFish_Theme.rstheme",
  name = "JellyFish Theme"
)


# nord -------------------------------------------------------------------
url <- file.path(
  "https://raw.githubusercontent.com/nordtheme/visual-studio-code/refs/heads/",
  "develop/themes/nord-color-theme.json"
)
# Generate rstheme
dd <- convert_to_rstudio_theme(
  dest,
  "inst/rsthemes/Nord.rstheme",
  force = TRUE,
  apply = TRUE
)
