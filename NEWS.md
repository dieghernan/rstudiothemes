# rstudiothemes 1.1.1

- Added package metadata comments to **Visual Studio Code** and **Positron**
  themes:

  ``` json
  {
    // Created with the R package rstudiothemes (c) dieghernan.
    // https://github.com/dieghernan/rstudiothemes
    "$schema": "vscode://schemas/color-theme",
    // Rest of keys ...
  }
  ```

# rstudiothemes 1.1.0

- Improved JSON parsing: invalid trailing commas before `}` or `]`, which are
  common in **Visual Studio Code** themes, are now removed before parsing.
- Added **Positron** aliases for **Visual Studio Code** theme functions:
  - `convert_positron_to_tm_theme()`.
  - `convert_tm_to_positron_theme()`.
  - `read_positron_theme()`.
- New themes:
  - `"Positron Dark"` and `"Positron Light"` by **Positron**.
  - `"VSCode Dark"` and `"VSCode Light"` by **Visual Studio Code**.
- Added a **Shiny** app for online theme conversion:
  <https://dieghernan-themeconverter.share.connect.posit.cloud/>.

# rstudiothemes 1.0.0

Initial **CRAN** release.

- Migrated vignettes and articles to Quarto (#9).
- Added DOI:
  [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18519155.svg)](https://doi.org/10.5281/zenodo.18519155).
- Repository status is active: [![Project Status: Active - The project has reached a
  stable, usable state and is being actively
  developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active).

## Bundled RStudio themes

Updates to bundled RStudio themes.

- Added mapping of indent guides to RStudio themes.
- `"Tokyo Night Light"`: Adjusted invisible elements (whitespaces) and ruler
  color.
- `"Matrix"`: Added ruler color.
- New themes:
  - `"Catppuccin Latte"` and `"Catppuccin Mocha"` by <https://catppuccin.com/>.
  - `"Matcha"` by Luca Falasco.
  - `"Andromeda"` by Eliver Lara.
  - `"One Dark Pro"` by binaryify.

# rstudiothemes 0.1.0

*Compatible with RStudio 2026.01.0+392 "Apple Blossom".*

- First working version.
