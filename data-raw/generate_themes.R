## code to `download_themes`

devtools::load_all()

# Current theme

current_theme <- rstudioapi::getThemeInfo()$editor

remove_rstudiothemes()

# Ayu -----
url <- paste0(
  "https://raw.githubusercontent.com/ayu-theme/vscode-ayu",
  "/refs/heads/master/ayu-light.json"
)
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/Ayu_Light.rstheme",
  name = "ayu Light",
  apply = TRUE,
  force = TRUE,
  output_style = "compact"
)

url <- paste0(
  "https://raw.githubusercontent.com/ayu-theme/vscode-ayu",
  "/refs/heads/master/ayu-dark.json"
)
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/Ayu_Dark.rstheme",
  name = "ayu Dark",
  apply = TRUE,
  force = TRUE,
  output_style = "compact"
)


# catpuccin -----
# source("./data-raw/compile_catppucin.R")

dd <- convert_to_rstudio_theme(
  "data-raw/vscode_themes/mocha.json",
  "inst/rsthemes/Catppuccin_Mocha.rstheme",
  apply = TRUE,
  force = TRUE,
  output_style = "compact"
)

dd <- convert_to_rstudio_theme(
  "data-raw/vscode_themes/latte.json",
  "inst/rsthemes/Catppuccin_Latte.rstheme",
  apply = TRUE,
  force = TRUE,
  output_style = "compact"
)

# cobalt -----

url <- paste0(
  "https://raw.githubusercontent.com/wesbos/",
  "cobalt2-vscode/refs/heads/master/theme/cobalt2.json"
)

dest <- file.path("inst", "rsthemes", basename(url))
dest <- gsub("json$|tmtheme$", "rstheme", dest, ignore.case = TRUE)

# Generate rstheme
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/Cobalt2.rstheme",
  name = "cobalt2",
  apply = TRUE,
  force = TRUE,
  output_style = "compact"
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
  "inst/rsthemes/CRAN.rstheme",
  apply = TRUE,
  force = TRUE,
  name = "CRAN",
  output_style = "compact"
)


# dracula (build) --------------------------------------------------------
# source("./data-raw/compile_dracula.R")
# Generate rstheme
dd <- convert_to_rstudio_theme(
  "./data-raw/vscode_themes/dracula.json",
  "inst/rsthemes/Dracula2025.rstheme",
  name = "Dracula2025",
  apply = TRUE,
  force = TRUE,
  output_style = "compact"
)

# github (build) -----------------------------------------------------------
# source("./data-raw/compile_github.R")

dd <- convert_to_rstudio_theme(
  "data-raw/vscode_themes/dark.json",
  "inst/rsthemes/GitHub_Dark.rstheme",
  name = "GitHub Dark",
  output_style = "compact",
  apply = TRUE,
  force = TRUE
)

dd <- convert_to_rstudio_theme(
  "data-raw/vscode_themes/light.json",
  "inst/rsthemes/GitHub_Light.rstheme",
  name = "GitHub Light",
  apply = TRUE,
  force = TRUE,
  output_style = "compact"
)


# JellyFish -------------------------------------------------------------------

dd <- convert_to_rstudio_theme(
  "data-raw/vscode_themes/JellyFish Theme-color-theme.json",
  "inst/rsthemes/JellyFish_Theme.rstheme",
  name = "JellyFish Theme",
  apply = TRUE,
  force = TRUE,
  output_style = "compact"
)


# Matcha -------------------------------------------------------------------
url <- paste0(
  "https://raw.githubusercontent.com/lucafalasco/matcha/",
  "refs/heads/master/themes/matcha-color-theme.json"
)

dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/Matcha.rstheme",
  name = "Matcha",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)


# Matrix -------------------------------------------------------------------
# url <- file.path(
#   "https://raw.githubusercontent.com/UstymUkhman/matrix-theme/refs/heads/",
#   "master/themes/Matrix-color-theme.json"
# )
# Generate rstheme

dd <- convert_to_rstudio_theme(
  "data-raw/vscode_themes/Matrix-color-theme.json",
  "inst/rsthemes/Matrix.rstheme",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

# Night Owl -------------------------------------------------------------------
url <- paste0(
  "https://raw.githubusercontent.com/sdras/night-owl-vscode-theme/",
  "refs/heads/main/themes/Night%20Owl-Light-color-theme-noitalic.json"
)

dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/Night_Owl_Light.rstheme",
  name = "Night Owl Light",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

url <- paste0(
  "https://raw.githubusercontent.com/sdras/night-owl-vscode-theme/",
  "refs/heads/main/themes/Night%20Owl-color-theme-noitalic.json"
)

dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/Night_Owl_Dark.rstheme",
  name = "Night Owl",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)


# Nord -------------------------------------------------------------------
url <- file.path(
  "https://raw.githubusercontent.com/nordtheme/visual-studio-code/refs/heads/",
  "develop/themes/nord-color-theme.json"
)
# Generate rstheme
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/Nord.rstheme",
  name = "Nord",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

# OKSolar -------------------------------------------------------------------
url <- file.path(
  "https://raw.githubusercontent.com/dieghernan/oksolar-theme/refs/heads/",
  "main/dist/vscode/themes/oksolar-light-color-theme.json"
)
# Generate rstheme
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/OKSolar_Light.rstheme",
  name = "OKSolar Light",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

url <- file.path(
  "https://raw.githubusercontent.com/dieghernan/oksolar-theme/refs/heads/",
  "main/dist/vscode/themes/oksolar-dark-color-theme.json"
)
# Generate rstheme
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/OKSolar_Dark.rstheme",
  name = "OKSolar Dark",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

url <- file.path(
  "https://raw.githubusercontent.com/dieghernan/oksolar-theme/refs/heads/",
  "main/dist/vscode/themes/oksolar-sky-color-theme.json"
)
# Generate rstheme
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/OKSolar_Sky.rstheme",
  name = "OKSolar Sky",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

# Overflow -------------------------------------------------------------------
url <- file.path(
  "https://raw.githubusercontent.com/dieghernan/overflow-theme/refs/heads/",
  "main/dist/vscode/themes/overflow-light-color-theme.json"
)
# Generate rstheme
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/Overflow_Light.rstheme",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

url <- file.path(
  "https://raw.githubusercontent.com/dieghernan/overflow-theme/refs/heads/",
  "main/dist/vscode/themes/overflow-dark-color-theme.json"
)
# Generate rstheme
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/Overflow_Dark.rstheme",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

# Panda -------------------------------------------------------------------
url <- file.path(
  "https://raw.githubusercontent.com/siamak/panda-syntax-vscode/refs/heads/",
  "main/dist/Panda.json"
)
# Generate rstheme
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/Panda_Syntax.rstheme",
  name = "Panda Syntax",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

# Selenized -------------------------------------------------------------------
url <- file.path(
  "https://raw.githubusercontent.com/dieghernan/selenized-theme/refs/heads/",
  "main/dist/vscode/themes/selenized-light-color-theme.json"
)
# Generate rstheme
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/Selenized_Light.rstheme",
  name = "Selenized Light",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

url <- file.path(
  "https://raw.githubusercontent.com/dieghernan/selenized-theme/refs/heads/",
  "main/dist/vscode/themes/selenized-dark-color-theme.json"
)
# Generate rstheme
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/Selenized_Dark.rstheme",
  name = "Selenized Dark",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

# Skeletor -------------------------------------------------------------------
url <- file.path(
  "https://raw.githubusercontent.com/dieghernan/skeletor-syntax/refs/heads/",
  "main/dist/vscode/themes/skeletor-syntax-color-theme.json"
)
# Generate rstheme
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/Skeletor_Syntax.rstheme",
  name = "Skeletor Syntax",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

# SynthWave '84 --------------------------------------------------------------

# url <- file.path(
#   "https://raw.githubusercontent.com/robb0wen/synthwave-vscode/refs/heads/",
#   "master/themes/synthwave-color-theme.json"
# )
# Generate rstheme
dd <- convert_to_rstudio_theme(
  "data-raw/vscode_themes/synthwave-color-theme.json",
  "inst/rsthemes/SynthWave84.rstheme",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)


# Tokyo Night --------------------------------------------------------------

# Generate rstheme
dd <- convert_to_rstudio_theme(
  "data-raw/vscode_themes/tokyo-night-color-theme.json",
  "inst/rsthemes/Tokio_Night_Dark.rstheme",
  name = "Tokio Night Dark",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)


# Generate rstheme
dd <- convert_to_rstudio_theme(
  "data-raw/vscode_themes/tokyo-night-light-color-theme.json",
  "inst/rsthemes/Tokio_Night_Light.rstheme",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

dd <- convert_to_rstudio_theme(
  "data-raw/vscode_themes/tokyo-night-storm-color-theme.json",
  "inst/rsthemes/Tokio_Night_Storm.rstheme",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

# Winter is Coming ---------------------------

dd <- convert_to_rstudio_theme(
  "data-raw/vscode_themes/WinterIsComing-dark-blue-color-no-italics-theme.json",
  "inst/rsthemes/Winter_is_Coming_Dark_Blue.rstheme",
  name = "Winter is Coming Dark Blue",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

url <- file.path(
  "https://raw.githubusercontent.com/johnpapa/vscode-winteriscoming/refs/",
  "heads/master/themes/WinterIsComing-light-color-no-italics-theme.json"
)
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/Winter_is_Coming_Light.rstheme",
  name = "Winter is Coming Light",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

# Create dist release
allt <- list.files("inst/rsthemes/", full.names = TRUE)

unlink("pkgdown/assets/dist/rstudiothemes.zip", force = TRUE)

zip::zip("pkgdown/assets/dist/rstudiothemes.zip", allt, mode = "cherry-pick")

# Remove and re-install
devtools::load_all()
remove_rstudiothemes()
install_rstudiothemes()

# Restore

rstudioapi::applyTheme(current_theme)

cli::cli_alert_success("OK, bye ;)")
