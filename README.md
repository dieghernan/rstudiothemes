
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rstudiothemes <a href="https://dieghernan.github.io/rstudiothemes/"><img src="man/figures/logo.png" align="right" height="139"/></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/dieghernan/rstudiothemes/actions/workflows/check-full.yaml/badge.svg)](https://github.com/dieghernan/rstudiothemes/actions/workflows/check-full.yaml)
[![R-hub](https://github.com/dieghernan/rstudiothemes/actions/workflows/rhub.yaml/badge.svg)](https://github.com/dieghernan/rstudiothemes/actions/workflows/rhub.yaml)
[![codecov](https://codecov.io/gh/dieghernan/rstudiothemes/branch/main/graph/badge.svg?token=Us9sfPntdX)](https://app.codecov.io/gh/dieghernan/rstudiothemes)
[![CodeFactor](https://www.codefactor.io/repository/github/dieghernan/rstudiothemes/badge?s=db1aa5e9aa335100151678939d0b23ee5cb86b71)](https://www.codefactor.io/repository/github/dieghernan/rstudiothemes)
[![r-universe](https://dieghernan.r-universe.dev/badges/rstudiothemes)](https://dieghernan.r-universe.dev/rstudiothemes)

<!-- badges: end -->

Create custom **RStudio themes** from **Visual Studio Code** and
**TextMate** theme formats.

This project provides tools to convert and work with `.tmTheme` /
`.json` (VS Code / TextMate) theme files and generate `.rstheme` files
that can be installed into RStudio. RStudio supports custom themes (in
`.rstheme` format) as of [version
1.2+](https://rstudio.github.io/rstudio-extensions/rstudio-theme-creation.html).

## Features

- Convert VS Code and TextMate themes into RStudio `.rstheme` format
- Organize and manage custom themes in a reproducible way
- Integrates with R tooling for easier installation and testing

## Installation

You can install the developing version of **rstudiothemes** with:

``` r
# install.packages("pak")
pak::pak("dieghernan/rstudiothemes")
```

Alternatively, you can install **geobounds** using the
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

## Example workflow (high-level):

1.  Add your Visual Studio Code or TextMate theme files into the
    appropriate folder.
2.  Use provided functions or scripts to convert these files into
    .rstheme files.
3.  Install the generated `.rstheme` in RStudio using:

``` r
rstudioapi::addTheme("path/to/theme.rstheme", apply = TRUE)
```

Alternatively, install themes via the RStudio UI:

*Tools \> Global Options \> Appearance \> Add Theme…*

## Contributing

Contributions are welcome! Please:

1.  Open an issue to discuss changes or ideas.
2.  Fork the repository and submit a pull request.
3.  Follow standard GitHub workflows with clear commit messages.
