

<!-- README.md is generated from README.qmd. Please edit that file -->

# rstudiothemes <a href="https://dieghernan.github.io/rstudiothemes/"><img src="man/figures/logo.png" alt="rstudiothemes website" align="right" height="139"/></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/dieghernan/rstudiothemes/actions/workflows/check-full.yaml/badge.svg)](https://github.com/dieghernan/rstudiothemes/actions/workflows/check-full.yaml)
[![codecov](https://codecov.io/gh/dieghernan/rstudiothemes/branch/main/graph/badge.svg?token=Us9sfPntdX)](https://app.codecov.io/gh/dieghernan/rstudiothemes)
[![r-universe](https://dieghernan.r-universe.dev/badges/rstudiothemes)](https://dieghernan.r-universe.dev/rstudiothemes)
[![CodeFactor](https://www.codefactor.io/repository/github/dieghernan/rstudiothemes/badge?s=db1aa5e9aa335100151678939d0b23ee5cb86b71)](https://www.codefactor.io/repository/github/dieghernan/rstudiothemes)
[![Project Status: Active - The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18519155.svg)](https://doi.org/10.5281/zenodo.18519155)

<!-- badges: end -->

Convert **Visual Studio Code/Positron** and **TextMate** themes into
**RStudio** custom themes.

This package provides tools to easily convert Visual Studio
Code/Positron and TextMate theme files (`.json` and `.tmTheme` formats)
into RStudio-compatible `.rstheme` files. RStudio has supported custom
themes in `.rstheme` format since [version
1.2+](https://rstudio.github.io/rstudio-extensions/rstudio-theme-creation.html).

## Features

- Convert Visual Studio Code/Positron and TextMate themes into RStudio
  `.rstheme` format.
- Bidirectional conversion between Visual Studio Code/Positron and
  TextMate themes.
- Includes ports of popular Visual Studio Code/Positron themes ready to
  use in RStudio.
- Organize and manage custom themes in a reproducible way.
- Integrates with **R** tooling for easier installation and testing.

## Built-in themes

This package includes ports of several popular Visual Studio
Code/Positron themes, ready to use in RStudio. Simply use the
`install_rstudiothemes()` function to install them into your RStudio
environment:

``` r
rstudiothemes::install_rstudiothemes()

#> ✔ Installed 32 themes
#> ℹ Use `rstudiothemes::list_rstudiothemes()` to list installed themes
#> ℹ Use `rstudiothemes::try_rstudiothemes()` to try all installed themes

rstudioapi::applyTheme("Winter is Coming Dark Blue")
```

<div class="text-center">

<img src="man/figures/winteriscoming.png"
alt="Screenshot of theme Winter is Coming Dark Blue" />

</div>

Available themes include popular choices such as Tokyo Night, Night Owl,
Winter is Coming, SynthWave 84, Nord, and many others:

``` r
rstudiothemes::list_rstudiothemes(list_installed = FALSE)
#>  [1] "Andromeda"                  "ayu Dark"                  
#>  [3] "ayu Light"                  "Catppuccin Latte"          
#>  [5] "Catppuccin Mocha"           "cobalt2"                   
#>  [7] "CRAN"                       "Dracula2025"               
#>  [9] "GitHub Dark"                "GitHub Light"              
#> [11] "JellyFish Theme"            "Matcha"                    
#> [13] "Matrix"                     "Night Owl"                 
#> [15] "Night Owl Light"            "Nord"                      
#> [17] "OKSolar Dark"               "OKSolar Light"             
#> [19] "OKSolar Sky"                "One Dark Pro"              
#> [21] "Overflow Dark"              "Overflow Light"            
#> [23] "Panda Syntax"               "Selenized Dark"            
#> [25] "Selenized Light"            "Skeletor Syntax"           
#> [27] "SynthWave 84"               "Tokyo Night"               
#> [29] "Tokyo Night Light"          "Tokyo Night Storm"         
#> [31] "Winter is Coming Dark Blue" "Winter is Coming Light"
```

We also distribute all our themes in a single `.zip` file at
<https://dieghernan.github.io/rstudiothemes/dist/rstudiothemes.zip>.
Unzip and install using the [RStudio IDE
interface](https://docs.posit.co/ide/user/ide/guide/ui/appearance.html).

## Installation

Install **rstudiothemes** from **CRAN** with:

``` r
install.packages("rstudiothemes")
```

You can install the developing version of **rstudiothemes** with:

``` r
# install.packages("pak")
pak::pak("dieghernan/rstudiothemes")
```

Alternatively, you can install **rstudiothemes** using the
[r-universe](https://dieghernan.r-universe.dev/rstudiothemes):

``` r
# Install rstudiothemes in R:
install.packages(
  "rstudiothemes",
  repos = c(
    "https://dieghernan.r-universe.dev",
    "https://cloud.r-project.org"
  )
)
```

## Migrating an existing theme

You can convert any Visual Studio Code/Positron or TextMate theme to
RStudio format. Here’s how:

1.  Use your favorite Visual Studio Code/Positron or TextMate theme file
    or the URL of an online theme.
2.  Use the `convert_to_rstudio_theme()` function to convert and install
    it:

``` r
rstudiothemes::convert_to_rstudio_theme(
  "<path/to/file>",
  apply = TRUE,
  force = TRUE
)
```

Alternatively, install the `.rstheme` file via the RStudio UI:

**Tools \> Global Options \> Appearance \> Add**

<div class="text-center">

<img src="man/figures/rstudiogui.png" style="width:80.0%"
data-fig-alt="RStudio IDE, Add-Theme UI" />

</div>

### Bidirectional conversion between Visual Studio Code/Positron and TextMate themes

The package also includes the conversion functions
`convert_vs_to_tm_theme()` and `convert_tm_to_vs_theme()`, allowing you
to convert themes in both directions if needed.

## Creating themes from scratch

**rstudiothemes** does not provide a built-in theme editor, but you can
create your own themes from scratch using the following tools:

- TextMate `.tmTheme`: <https://tmtheme-editor.linuxbox.ninja/>. Also
  see the official RStudio documentation on [creating
  themes](https://rstudio.github.io/rstudio-extensions/rstudio-theme-creation.html).
- Visual Studio Code `.json`: See the official documentation on
  [creating color
  themes](https://code.visualstudio.com/api/extension-guides/color-theme).

## Contributing

Contributions are welcome! To contribute to this project:

1.  Open an issue to discuss your ideas or proposed changes.
2.  Fork the repository and create a feature branch.
3.  Submit a pull request with clear commit messages and descriptions.
