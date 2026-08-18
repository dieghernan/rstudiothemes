# Manage RStudio themes

Install, list, preview or remove the RStudio themes included in
[rstudiothemes](https://CRAN.R-project.org/package=rstudiothemes). These
functions are adapted from selected rsthemes functions. [MIT
License](https://github.com/gadenbuie/rsthemes/blob/main/LICENSE.md)
Copyright © rsthemes authors.

**Important**: These functions only work in RStudio and return `NULL`
when called from other IDEs. The exception is
`list_rstudiothemes(list_installed = FALSE)`.

## Usage

``` r
install_rstudiothemes(
  style = c("all", "dark", "light"),
  themes = NULL,
  destdir = NULL
)

remove_rstudiothemes(style = c("all", "dark", "light"))

list_rstudiothemes(style = c("all", "dark", "light"), list_installed = TRUE)

try_rstudiothemes(style = c("all", "dark", "light"), themes = NULL, delay = 0)
```

## Arguments

- style:

  Theme group: `"all"`, `"dark"` or `"light"`.

- themes:

  Optional character vector of theme names. If provided, only these
  themes are used and `style` is ignored.

- destdir:

  Optional directory for `.rstheme` files. By default, themes are
  installed with
  [`rstudioapi::addTheme()`](https://rstudio.github.io/rstudioapi/reference/addTheme.html).
  Use this argument to copy themes to a non-standard directory instead.

- list_installed:

  If `TRUE` (default), list installed
  [rstudiothemes](https://CRAN.R-project.org/package=rstudiothemes)
  themes. If `FALSE`, list themes available in the package.

- delay:

  Number of seconds to wait between themes. Set to 0 to be prompted to
  continue after each theme.

## Value

`install_rstudiothemes()` and `remove_rstudiothemes()` return `NULL`
invisibly.

`list_rstudiothemes()` returns a character vector of theme names.

`try_rstudiothemes()` has side effects. It cycles through bundled
themes, lets you preview each one and restores your original theme when
you quit.

## Functions

- `install_rstudiothemes()`: Install RStudio themes.

- `remove_rstudiothemes()`: Remove bundled
  [rstudiothemes](https://CRAN.R-project.org/package=rstudiothemes)
  themes from RStudio.

- `list_rstudiothemes()`: List installed or available themes.

- `try_rstudiothemes()`: Preview bundled
  [rstudiothemes](https://CRAN.R-project.org/package=rstudiothemes)
  RStudio themes.

## Bundled themes

[rstudiothemes](https://CRAN.R-project.org/package=rstudiothemes)
includes RStudio themes based on the following editor themes:

- Ayu Theme by teabyii.

- Andromeda Theme by Eliver Lara.

- Catppuccin Theme by [Catppuccin](https://catppuccin.com/).

- Cobalt2 Theme by Wes Bos.

- CRAN Theme by dieghernan, based on the CRAN (R Project) website theme
  created with Pandoc.

- Dracula Theme by [Dracula](https://draculatheme.com/).

- GitHub Dark and Light Themes by GitHub.

- JellyFish Theme by Pawel Borkar.

- Matcha Theme by Luca Falasco.

- Matrix Theme by UstymUkhman.

- Night Owl Dark and Light Themes (no italics) by Sarah Drasner.

- Nord Theme by Arctic Ice Studio.

- OKSolar Theme by dieghernan.

- One Dark Pro Theme by binaryify.

- Overflow Theme by dieghernan.

- Panda Theme by Panda Theme.

- Selenized Themes by dieghernan.

- Skeletor Syntax Theme by dieghernan.

- SynthWave '84 Theme by Robb Owen.

- Tokyo Night Theme by Enkia.

- Winter is Coming Theme by John Papa.

## References

Aden-Buie G (2026). *rsthemes: Full Themes for RStudio v1.2+*. R package
version 0.5.1, commit 48fc078f772e5e63669bc9773eabc8e9cdc7f699,
<https://github.com/gadenbuie/rsthemes>.

## Author

Garrick Aden-Buie <https://github.com/gadenbuie>

## Examples

``` r
list_rstudiothemes(list_installed = FALSE)
#>  [1] "Andromeda"                  "ayu Dark"                  
#>  [3] "ayu Light"                  "CRAN"                      
#>  [5] "Catppuccin Latte"           "Catppuccin Mocha"          
#>  [7] "cobalt2"                    "Dracula2025"               
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
