
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rstudiothemes <a href="https://dieghernan.github.io/rstudiothemes/"><img src="man/figures/logo.png" align="right" height="139"/></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/dieghernan/rstudiothemes/actions/workflows/check-full.yaml/badge.svg)](https://github.com/dieghernan/rstudiothemes/actions/workflows/check-full.yaml)
[![R-hub](https://github.com/dieghernan/rstudiothemes/actions/workflows/rhub.yaml/badge.svg)](https://github.com/dieghernan/rstudiothemes/actions/workflows/rhub.yaml)
[![codecov](https://codecov.io/gh/dieghernan/rstudiothemes/branch/main/graph/badge.svg?token=Us9sfPntdX)](https://app.codecov.io/gh/dieghernan/rstudiothemes)
[![CodeFactor](https://www.codefactor.io/repository/github/dieghernan/rstudiothemes/badge?s=db1aa5e9aa335100151678939d0b23ee5cb86b71)](https://www.codefactor.io/repository/github/dieghernan/rstudiothemes)
[![r-universe](https://dieghernan.r-universe.dev/badges/rstudiothemes)](https://dieghernan.r-universe.dev/rstudiothemes)

<!-- badges: end -->

Convert **Visual Studio Code** and **TextMate** themes into **RStudio**
custom themes.

This package provides tools to easily convert Visual Studio Code and
TextMate theme files (`.json` and `.tmTheme` formats) into
RStudio-compatible `.rstheme` files. RStudio has supported custom themes
in `.rstheme` format since [version
1.2+](https://rstudio.github.io/rstudio-extensions/rstudio-theme-creation.html).

## Features

- Convert VS Code and TextMate themes into RStudio `.rstheme` format.
- Organize and manage custom themes in a reproducible way.
- Integrates with R tooling for easier installation and testing.

## Built-in Themes

This package includes ports of several popular Visual Studio Code
themes, ready to use in RStudio. Simply use the
`install_rstudiothemes()` function to install them into your RStudio
environment:

``` r
rstudiothemes::install_rstudiothemes()
#> ℹ Detected GUI: "RTerm".
#> ✖ `rstudiothemes::try_rs_themes()` only works in RStudio, not in RTerm.
#> → Bye
#> NULL

rstudiothemes::list_rstudiothemes()
#> ℹ Detected GUI: "RTerm".
#> ✖ `rstudiothemes::try_rs_themes()` only works in RStudio, not in RTerm.
#> → Bye
#> NULL
```

Available themes include popular choices such as Tokyo Night, Night Owl,
Winter is Coming, SynthWave 84, Nord, and many others.

## Installation

You can install **rstudiothemes** using either of these methods:

``` r
# install.packages("pak")
pak::pak("dieghernan/rstudiothemes")
```

Or, install it from r-universe:

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

## Creating a new theme

You can convert any Visual Studio Code or TextMate theme to RStudio
format. Here’s how:

1.  Download your favorite Visual Studio Code or TextMate theme file.
2.  Use the `convert_to_rs_theme()` function to convert and install it:

``` r
rstudiothemes::convert_to_rs_theme("<path/to/file>", apply = TRUE, force = TRUE)
```

Alternatively, install the `.rstheme` file via the RStudio UI:

*Tools \> Global Options \> Appearance \> Add Theme*

<figure>
<img src="man/figures/rstudiogui.png"
alt="Example on how to update themes on RStudio IDE" />
<figcaption aria-hidden="true">Example on how to update themes on
RStudio IDE</figcaption>
</figure>

The package also includes the reverse conversion functions
`convert_vs_to_tm_theme()` and `convert_tm_to_vs_theme()`, allowing you
to convert themes in both directions if needed.

## Contributing

Contributions are welcome! To contribute to this project:

1.  Open an issue to discuss your ideas or proposed changes.
2.  Fork the repository and create a feature branch.
3.  Submit a pull request with clear commit messages and descriptions.
