# rstudiothemes (development version)

- Added `"Barbie Theme"` by Milene Toazza and `"Bluloco Light"` by Umut
  Topuzoglu.
- `convert_to_rstudio_theme()` no longer tries to apply a theme after its
  installation fails. It also builds inherited ACE scope styles reliably when a
  theme mixes top-level and nested scopes.
- `install_rstudiothemes()` now reports theme-copy failures instead of claiming
  that every requested theme was installed.
- `install_rstudiothemes()`, `list_rstudiothemes()` and `try_rstudiothemes()`
  now report actions and unmatched themes with safer, clearer **cli** markup.
- `read_vs_theme()` now preserves double slashes inside JSON strings when it
  removes comments.

# rstudiothemes 1.1.2

- Refreshed documentation to make package guidance, function references and
  maintenance notes clearer and more consistent.

# rstudiothemes 1.1.1

- Added package metadata comments to generated **Visual Studio Code** and
  **Positron** themes.

  ``` json
  {
    // Created with the R package rstudiothemes (c) dieghernan.
    // https://github.com/dieghernan/rstudiothemes
    "$schema": "vscode://schemas/color-theme",
    // Remaining keys.
  }
  ```

# rstudiothemes 1.1.0

- Added a **Shiny** app for online theme conversion:
  <https://dieghernan-themeconverter.share.connect.posit.cloud/>.
- Added `"Positron Dark"` and `"Positron Light"` by **Positron**.
- Added `"VSCode Dark"` and `"VSCode Light"` by **Visual Studio Code**.
- Improved JSON parsing by removing invalid trailing commas before `}` or `]`, a
  common pattern in **Visual Studio Code** themes.
- `convert_positron_to_tm_theme()` is a new **Positron** alias for
  `convert_vs_to_tm_theme()`.
- `convert_tm_to_positron_theme()` is a new **Positron** alias for
  `convert_tm_to_vs_theme()`.
- `read_positron_theme()` is a new **Positron** alias for `read_vs_theme()`.

# rstudiothemes 1.0.0

Initial **CRAN** release.

- Added DOI:
  [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18519155.svg)](https://doi.org/10.5281/zenodo.18519155).
- Migrated vignettes and articles to **Quarto** (#9).
- At release time, repository status was active: [![Project Status: Active - The
  project has reached a stable, usable state and is being actively
  developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active).

## Bundled RStudio themes

Changes to bundled **RStudio** themes.

- Added mapping of indent guides to **RStudio** themes.
- Added `"Andromeda"` by Eliver Lara.
- Added `"Catppuccin Latte"` and `"Catppuccin Mocha"` by
  <https://catppuccin.com/>.
- Added `"Matcha"` by Luca Falasco.
- Added ruler color for `"Matrix"`.
- Added `"One Dark Pro"` by binaryify.
- Adjusted invisible elements (whitespace) and ruler color for
  `"Tokyo Night Light"`.

# rstudiothemes 0.1.0

Compatible with **RStudio** 2026.01.0+392 "Apple Blossom".

- First working version.
