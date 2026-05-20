# Changelog

## rstudiothemes 1.1.1

CRAN release: 2026-05-11

- Added package metadata comments to generated **Visual Studio Code**
  and **Positron** themes.

  ``` json
  {
    // Created with the R package rstudiothemes (c) dieghernan.
    // https://github.com/dieghernan/rstudiothemes
    "$schema": "vscode://schemas/color-theme",
    // Remaining keys.
  }
  ```

## rstudiothemes 1.1.0

CRAN release: 2026-04-07

- Added a **Shiny** app for online theme conversion:
  <https://dieghernan-themeconverter.share.connect.posit.cloud/>.
- Added `"Positron Dark"` and `"Positron Light"` by **Positron**.
- Added `"VSCode Dark"` and `"VSCode Light"` by **Visual Studio Code**.
- Improved JSON parsing by removing invalid trailing commas before `}`
  or `]`, which are common in **Visual Studio Code** themes.
- [`convert_positron_to_tm_theme()`](https://dieghernan.github.io/rstudiothemes/reference/convert_vs_to_tm_theme.md)
  is a new **Positron** alias for
  [`convert_vs_to_tm_theme()`](https://dieghernan.github.io/rstudiothemes/reference/convert_vs_to_tm_theme.md).
- [`convert_tm_to_positron_theme()`](https://dieghernan.github.io/rstudiothemes/reference/convert_tm_to_vs_theme.md)
  is a new **Positron** alias for
  [`convert_tm_to_vs_theme()`](https://dieghernan.github.io/rstudiothemes/reference/convert_tm_to_vs_theme.md).
- [`read_positron_theme()`](https://dieghernan.github.io/rstudiothemes/reference/read_vs_theme.md)
  is a new **Positron** alias for
  [`read_vs_theme()`](https://dieghernan.github.io/rstudiothemes/reference/read_vs_theme.md).

## rstudiothemes 1.0.0

CRAN release: 2026-03-03

Initial **CRAN** release.

- Added DOI:
  [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18519155.svg)](https://doi.org/10.5281/zenodo.18519155).
- Migrated vignettes and articles to Quarto
  ([\#9](https://github.com/dieghernan/rstudiothemes/issues/9)).
- Repository status is active: [![Project Status: Active - The project
  has reached a stable, usable state and is being actively
  developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active).

### Bundled RStudio themes

Updates to bundled RStudio themes.

- Added mapping of indent guides to RStudio themes.
- Added `"Andromeda"` by Eliver Lara.
- Added `"Catppuccin Latte"` and `"Catppuccin Mocha"` by
  <https://catppuccin.com/>.
- Added `"Matcha"` by Luca Falasco.
- Added ruler color for `"Matrix"`.
- Added `"One Dark Pro"` by binaryify.
- Adjusted invisible elements (whitespace) and ruler color for
  `"Tokyo Night Light"`.

## rstudiothemes 0.1.0

*Compatible with RStudio 2026.01.0+392 “Apple Blossom”.*

- First working version.
