## Generate bundled themes.

devtools::load_all()

add_theme_notice <- function(path, notice) {
  theme <- readLines(path, warn = FALSE)
  theme <- append(theme, notice, after = 3L)
  writeLines(theme, path, useBytes = TRUE)
  invisible(path)
}

# Save the current theme.
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

# Andromeda -----
url <- paste0(
  "https://raw.githubusercontent.com/EliverLara/Andromeda/refs/heads/",
  "master/themes/Andromeda-color-theme.json"
)
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/Andromeda.rstheme",
  apply = TRUE,
  force = TRUE,
  output_style = "compact"
)

# Barbie -----
url <- paste0(
  "https://raw.githubusercontent.com/mihtoa/barbie-theme/refs/heads/",
  "main/themes/barbie-theme-color-theme.json"
)
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/Barbie_Theme.rstheme",
  name = "Barbie Theme",
  apply = TRUE,
  force = TRUE,
  output_style = "compact"
)

# Bluloco Light -----
url <- paste0(
  "https://raw.githubusercontent.com/uloco/theme-bluloco-light/refs/heads/",
  "main/themes/bluloco-light-color-theme.json"
)
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/Bluloco_Light.rstheme",
  name = "Bluloco Light",
  apply = TRUE,
  force = TRUE,
  output_style = "compact"
)

add_theme_notice(
  "inst/rsthemes/Bluloco_Light.rstheme",
  c(
    "/* Derived from Bluloco Light by Umut Topuzoglu. */",
    "/* Converted and modified for rstudiothemes in 2026. */",
    "/* LGPL-3.0; see licenses/Bluloco-Light-LICENSE and GPL-3. */"
  )
)

# Catppuccin (build) -----
source("./data-raw/compile_catppucin.R")
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

# Cobalt -----
url <- paste0(
  "https://raw.githubusercontent.com/wesbos/",
  "cobalt2-vscode/refs/heads/master/theme/cobalt2.json"
)

dest <- file.path("inst", "rsthemes", basename(url))
dest <- gsub("json$|tmtheme$", "rstheme", dest, ignore.case = TRUE)

# Generate the RStudio theme.
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/Cobalt2.rstheme",
  name = "cobalt2",
  apply = TRUE,
  force = TRUE,
  output_style = "compact"
)

# CRAN -------------------------------------------------------------------
url <- paste0(
  "https://raw.githubusercontent.com/dieghernan/pretty-themes/",
  "refs/heads/main/dist/tmTheme/cran.tmTheme"
)

dest <- file.path("inst", "rsthemes", basename(url))
dest <- gsub("json$|tmtheme$", "rstheme", dest, ignore.case = TRUE)

# Generate the RStudio theme.
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/CRAN.rstheme",
  apply = TRUE,
  force = TRUE,
  name = "CRAN",
  output_style = "compact"
)

# Dracula (build) --------------------------------------------------------
source("./data-raw/compile_dracula.R")
# Generate the RStudio theme.
dd <- convert_to_rstudio_theme(
  "./data-raw/vscode_themes/dracula.json",
  "inst/rsthemes/Dracula2025.rstheme",
  name = "Dracula2025",
  apply = TRUE,
  force = TRUE,
  output_style = "compact"
)

# GitHub (build) ---------------------------------------------------------
source("./data-raw/compile_github.R")
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

url <- paste0(
  "https://raw.githubusercontent.com/pawelborkar/vscode-jellyfish/",
  "refs/heads/star/themes/JellyFish%20Theme-color-theme.json"
)
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/JellyFish_Theme.rstheme",
  name = "JellyFish Theme",
  apply = TRUE,
  force = TRUE,
  output_style = "compact"
)

add_theme_notice(
  "inst/rsthemes/JellyFish_Theme.rstheme",
  c(
    "/* Derived from JellyFish by Pawel Borkar. */",
    "/* Converted and modified for rstudiothemes in 2026. */",
    "/* Apache-2.0; see licenses/JellyFish-LICENSE and COPYRIGHTS. */"
  )
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
url <- file.path(
  "https://raw.githubusercontent.com/UstymUkhman/matrix-theme/refs/heads/",
  "master/themes/Matrix-color-theme.json"
)
# Generate the RStudio theme.
dd <- convert_to_rstudio_theme(
  url,
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

# Generate the RStudio theme.
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

# Generate the RStudio theme.
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

# Generate the RStudio theme.
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

# Generate the RStudio theme.
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/OKSolar_Sky.rstheme",
  name = "OKSolar Sky",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

# One Dark Pro ---------------------------------------
url <- paste0(
  "https://raw.githubusercontent.com/Binaryify/OneDark-Pro/",
  "refs/heads/master/themes/OneDark-Pro.json"
)

dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/One_Dark_Pro.rstheme",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

# Overflow -------------------------------------------------------------------
url <- file.path(
  "https://raw.githubusercontent.com/dieghernan/overflow-theme/refs/heads/",
  "main/dist/vscode/themes/overflow-light-color-theme.json"
)
# Generate the RStudio theme.
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
# Generate the RStudio theme.
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
# Generate the RStudio theme.
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
# Generate the RStudio theme.
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
# Generate the RStudio theme.
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
# Generate the RStudio theme.
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/Skeletor_Syntax.rstheme",
  name = "Skeletor Syntax",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

# SynthWave '84 --------------------------------------------------------------

url <- file.path(
  "https://raw.githubusercontent.com/robb0wen/synthwave-vscode/refs/heads/",
  "master/themes/synthwave-color-theme.json"
)

# The `editor.foreground` setting is missing from SynthWave.

# Generate the RStudio theme.
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/SynthWave84.rstheme",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

# Tokyo Night --------------------------------------------------------------

url <- paste0(
  "https://raw.githubusercontent.com/tokyo-night/tokyo-night-vscode-theme/",
  "refs/heads/master/themes/tokyo-night-color-theme.json"
)

# Generate the RStudio theme.
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/Tokyo_Night.rstheme",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

# Generate the RStudio theme.
url <- paste0(
  "https://raw.githubusercontent.com/tokyo-night/tokyo-night-vscode-theme/",
  "refs/heads/master/themes/tokyo-night-light-color-theme.json"
)

dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/Tokyo_Night_Light.rstheme",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

url <- paste0(
  "https://raw.githubusercontent.com/tokyo-night/tokyo-night-vscode-theme/",
  "refs/heads/master/themes/tokyo-night-storm-color-theme.json"
)

dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/Tokyo_Night_Storm.rstheme",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

# Winter is Coming ---------------------------
url <- paste0(
  "https://raw.githubusercontent.com/johnpapa/vscode-winteriscoming/",
  "refs/heads/main/themes/",
  "WinterIsComing-dark-blue-color-no-italics-theme.json"
)

dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/Winter_is_Coming_Dark_Blue.rstheme",
  name = "Winter is Coming Dark Blue",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

url <- file.path(
  "https://raw.githubusercontent.com/johnpapa/vscode-winteriscoming/refs/",
  "heads/main/themes/WinterIsComing-light-color-no-italics-theme.json"
)
dd <- convert_to_rstudio_theme(
  url,
  "inst/rsthemes/Winter_is_Coming_Light.rstheme",
  name = "Winter is Coming Light",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

# Positron -------------------------------------------------------------------
# Generate the RStudio theme.
dd <- convert_to_rstudio_theme(
  "data-raw/vscode_themes/positron_dark.json",
  "inst/rsthemes/Positron_Dark.rstheme",
  name = "Positron Dark",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

positron_notice <- c(
  "/* Original rstudiothemes work inspired by the Positron IDE. */",
  "/* Copyright (c) 2026 Diego Hernangómez; licensed under MIT. */",
  "/* No Positron source code is distributed in this theme. */"
)

add_theme_notice(
  "inst/rsthemes/Positron_Dark.rstheme",
  positron_notice
)

# Generate the RStudio theme.
dd <- convert_to_rstudio_theme(
  "data-raw/vscode_themes/positron_light.json",
  "inst/rsthemes/Positron_Light.rstheme",
  name = "Positron Light",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

add_theme_notice(
  "inst/rsthemes/Positron_Light.rstheme",
  positron_notice
)

# VSCode -------------------------------------------------------------------

# Generate the RStudio theme.
dd <- convert_to_rstudio_theme(
  "data-raw/vscode_themes/vscode_dark.json",
  "inst/rsthemes/VSCode_Dark.rstheme",
  name = "VSCode Dark",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

# Generate the RStudio theme.
dd <- convert_to_rstudio_theme(
  "data-raw/vscode_themes/vscode_light.json",
  "inst/rsthemes/VSCode_Light.rstheme",
  name = "VSCode Light",
  force = TRUE,
  apply = TRUE,
  output_style = "compact"
)

# Create the distribution archive. -----
allt <- list.files("inst/rsthemes/", full.names = TRUE)
licenses <- list.files("inst/licenses/", full.names = TRUE)
copyrights <- "inst/COPYRIGHTS"
gpl3 <- file.path(R.home("share"), "licenses", "GPL-3")
zipfile <- normalizePath(
  "pkgdown/assets/dist/rstudiothemes.zip",
  winslash = "/",
  mustWork = FALSE
)
archive_root <- tempfile("rstudiothemes-")
archive_licenses <- file.path(archive_root, "licenses")

dir.create(dirname(zipfile), recursive = TRUE, showWarnings = FALSE)
dir.create(archive_root)
dir.create(archive_licenses)

copied <- c(
  file.copy(allt, archive_root),
  file.copy(licenses, archive_licenses),
  file.copy(copyrights, archive_root),
  file.copy(gpl3, archive_licenses)
)
stopifnot(all(copied))

unlink(zipfile, force = TRUE)

zip::zip(
  zipfile,
  list.files(archive_root, recursive = TRUE),
  root = archive_root,
  mode = "mirror"
)

unlink(archive_root, recursive = TRUE, force = TRUE)

# Remove and reinstall the themes.
devtools::load_all()
remove_rstudiothemes()
install_rstudiothemes()

# Restore the original theme.

rstudioapi::applyTheme(current_theme)

cli::cli_alert_success("OK, bye.")
