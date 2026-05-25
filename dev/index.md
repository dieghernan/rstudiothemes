# rstudiothemes

Convert **Visual Studio Code**, **Positron** and **TextMate** themes
into custom **RStudio** themes.

This package provides tools to convert **Visual Studio Code**,
**Positron** and **TextMate** theme files (`.json` and `.tmTheme`
formats) into **RStudio**-compatible `.rstheme` files. **RStudio** has
supported custom themes in `.rstheme` format since **RStudio** 1.2. See
the [theme creation
documentation](https://rstudio.github.io/rstudio-extensions/rstudio-theme-creation.html).

## Features

- Convert **Visual Studio Code**, **Positron** and **TextMate** themes
  into **RStudio** `.rstheme` format.
- Convert themes bidirectionally between **Visual Studio Code** or
  **Positron** and **TextMate** formats.
- Install ports of popular **Visual Studio Code** and **Positron**
  themes ready to use in **RStudio**.
- Manage custom themes in a reproducible way.
- Work with standard **R** tooling for installation and testing.

## Built-in themes

This package includes ports of several popular **Visual Studio Code**
and **Positron** themes, ready to use in **RStudio**. Use
[`install_rstudiothemes()`](https://dieghernan.github.io/rstudiothemes/dev/reference/rstudiothemes-actions.md)
to install them into your **RStudio** environment:

``` r

rstudiothemes::install_rstudiothemes()

#> ✔ Installed 36 themes
#> ℹ Use `rstudiothemes::list_rstudiothemes()` to list installed themes.
#> ℹ Use `rstudiothemes::try_rstudiothemes()` to preview installed themes.

rstudioapi::applyTheme("Winter is Coming Dark Blue")
```

![Winter is Coming Dark Blue
theme](reference/figures/winteriscoming.png)

Available themes include popular choices such as Tokyo Night, Night Owl,
Winter is Coming, SynthWave 84, Nord and many more:

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
#> [23] "Panda Syntax"               "Positron Dark"             
#> [25] "Positron Light"             "Selenized Dark"            
#> [27] "Selenized Light"            "Skeletor Syntax"           
#> [29] "SynthWave 84"               "Tokyo Night"               
#> [31] "Tokyo Night Light"          "Tokyo Night Storm"         
#> [33] "VSCode Dark"                "VSCode Light"              
#> [35] "Winter is Coming Dark Blue" "Winter is Coming Light"
```

All bundled themes are also distributed in a single `.zip` file at
<https://dieghernan.github.io/rstudiothemes/dist/rstudiothemes.zip>.
Unzip and install them using the [**RStudio** IDE
interface](https://docs.posit.co/ide/user/ide/guide/ui/appearance.html).

## Installation

Read the documentation for the development version at
<https://dieghernan.github.io/rstudiothemes/dev/>.

You can install the development version of **rstudiothemes** with:

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

## Try the online converter

The online **Shiny** app includes many **rstudiothemes** features and
lets you convert themes in a browser:

<https://dieghernan-themeconverter.share.connect.posit.cloud/>

## Migrating an existing theme

You can convert any **Visual Studio Code**, **Positron** or **TextMate**
theme to **RStudio** format with this workflow:

1.  Start with a **Visual Studio Code**, **Positron** or **TextMate**
    theme file, or a URL to an online theme.
2.  Use the
    [`convert_to_rstudio_theme()`](https://dieghernan.github.io/rstudiothemes/dev/reference/convert_to_rstudio_theme.md)
    function to convert and install it:

``` r

rstudiothemes::convert_to_rstudio_theme(
  "<path/to/file>",
  apply = TRUE,
  force = TRUE
)
```

Alternatively, in **RStudio**, go to **Tools \> Global Options \>
Appearance \> Add** and select the installed theme.

![RStudio IDE add theme UI](reference/figures/rstudiogui.png)

### Bidirectional theme conversion

The package also includes
[`convert_vs_to_tm_theme()`](https://dieghernan.github.io/rstudiothemes/dev/reference/convert_vs_to_tm_theme.md)
and
[`convert_tm_to_vs_theme()`](https://dieghernan.github.io/rstudiothemes/dev/reference/convert_tm_to_vs_theme.md)
for conversion between **Visual Studio Code**, **Positron** and
**TextMate** formats.

## Creating themes from scratch

**rstudiothemes** does not provide a built-in theme editor, but you can
create themes from scratch with these tools:

- TextMate `.tmTheme`: Use <https://tmtheme-editor.linuxbox.ninja/>. See
  also the official **RStudio** documentation on [creating
  themes](https://rstudio.github.io/rstudio-extensions/rstudio-theme-creation.html).
- **Visual Studio Code** `.json`: See the official **Visual Studio
  Code** documentation on [creating color
  themes](https://code.visualstudio.com/api/extension-guides/color-theme).

## Contributing

Contributions are welcome! To contribute to this project:

1.  Open an issue to discuss your ideas or proposed changes.
2.  Fork the repository and create a feature branch.
3.  Submit a pull request with clear commit messages and descriptions.

## Citation

Hernangómez D (2026). *rstudiothemes: Create and Install Custom RStudio
Themes from Visual Studio Code, Positron and TextMate Themes*.
[doi:10.32614/CRAN.package.rstudiothemes](https://doi.org/10.32614/CRAN.package.rstudiothemes).
<https://dieghernan.github.io/rstudiothemes/>.

A BibTeX entry for LaTeX users:

``` R
@Manual{R-rstudiothemes,
  title = {{rstudiothemes}: Create and Install Custom {RStudio} Themes from Visual Studio
Code, {Positron} and {TextMate} Themes},
  doi = {10.32614/CRAN.package.rstudiothemes},
  author = {Diego Hernangómez},
  year = {2026},
  version = {1.1.1.9000},
  url = {https://dieghernan.github.io/rstudiothemes/},
  abstract = {Create, convert and install custom RStudio editor themes from Visual Studio Code, Positron and TextMate themes. Convert themes between TextMate, Visual Studio Code and Positron formats, and install bundled ports of popular themes for use in RStudio.},
}
```
