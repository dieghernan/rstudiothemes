# Manage **RStudio** themes

Install, list, preview or remove the **RStudio** themes included in
[rstudiothemes](https://CRAN.R-project.org/package=rstudiothemes). These
functions are adapted from selected rsthemes functions. [MIT
License](https://github.com/gadenbuie/rsthemes/blob/main/LICENSE.md)
Copyright © rsthemes authors.

**Important**: These functions only work in **RStudio** and return
`NULL` when called from other IDEs. The exception is
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

- `install_rstudiothemes()` installs bundled themes.

- `remove_rstudiothemes()` removes bundled themes.

- `list_rstudiothemes()` lists installed or available themes.

- `try_rstudiothemes()` previews bundled themes.

## Bundled themes

[rstudiothemes](https://CRAN.R-project.org/package=rstudiothemes)
includes **RStudio** themes based on the following editor themes:

- Andromeda Theme by Eliver Lara (MIT License).

- Ayu Theme by teabyii (MIT License).

- [Barbie Theme](https://github.com/mihtoa/barbie-theme) by Milene
  Toazza (MIT License).

- [Bluloco Light Theme](https://github.com/uloco/theme-bluloco-light) by
  Umut Topuzoglu (GNU Lesser General Public License version 3).

- Catppuccin Theme by [Catppuccin](https://catppuccin.com/) (MIT
  License).

- Cobalt2 Theme by Wes Bos (MIT License).

- CRAN Theme by dieghernan, based on the **CRAN** (**R Project**)
  website theme created with **Pandoc** (MIT License).

- Dracula Theme by [Dracula](https://draculatheme.com/) (MIT License).

- GitHub Dark and Light Themes by GitHub (MIT License).

- JellyFish Theme by Pawel Borkar (Apache License 2.0).

- Matcha Theme by Luca Falasco (MIT License).

- Matrix Theme by UstymUkhman (MIT License).

- Night Owl Dark and Light Themes (no italics) by Sarah Drasner (MIT
  License).

- Nord Theme by Arctic Ice Studio (MIT License).

- OKSolar Theme by dieghernan (MIT License).

- One Dark Pro Theme by binaryify (MIT License).

- Overflow Theme by dieghernan (MIT License).

- Panda Theme by Panda Theme (no license declared).

- Positron Dark and Light Themes by dieghernan, inspired by the
  **Positron IDE** (MIT License).

- Selenized Themes by dieghernan (MIT License).

- Skeletor Syntax Theme by dieghernan (MIT License).

- SynthWave '84 Theme by Robb Owen (MIT License).

- Tokyo Night Theme by Enkia (MIT License).

- Visual Studio Code Dark and Light Themes by Microsoft (MIT License).

- Winter is Coming Theme by John Papa (MIT License).

## References

Aden-Buie G (2026). *rsthemes: Full Themes for **RStudio*** v1.2+.
rsthemes version 0.5.1, commit 48fc078f772e5e63669bc9773eabc8e9cdc7f699,
<https://github.com/gadenbuie/rsthemes>.

## See also

[`convert_to_rstudio_theme()`](https://dieghernan.github.io/rstudiothemes/reference/convert_to_rstudio_theme.md)
to convert and install a custom theme file.

## Author

Garrick Aden-Buie <https://github.com/gadenbuie>

## Examples

``` r
list_rstudiothemes(list_installed = FALSE)
#>  [1] "Andromeda"                  "ayu Dark"                  
#>  [3] "ayu Light"                  "Barbie Theme"              
#>  [5] "Bluloco Light"              "CRAN"                      
#>  [7] "Catppuccin Latte"           "Catppuccin Mocha"          
#>  [9] "cobalt2"                    "Dracula2025"               
#> [11] "GitHub Dark"                "GitHub Light"              
#> [13] "JellyFish Theme"            "Matcha"                    
#> [15] "Matrix"                     "Night Owl"                 
#> [17] "Night Owl Light"            "Nord"                      
#> [19] "OKSolar Dark"               "OKSolar Light"             
#> [21] "OKSolar Sky"                "One Dark Pro"              
#> [23] "Overflow Dark"              "Overflow Light"            
#> [25] "Panda Syntax"               "Positron Dark"             
#> [27] "Positron Light"             "Selenized Dark"            
#> [29] "Selenized Light"            "Skeletor Syntax"           
#> [31] "SynthWave 84"               "Tokyo Night"               
#> [33] "Tokyo Night Light"          "Tokyo Night Storm"         
#> [35] "VSCode Dark"                "VSCode Light"              
#> [37] "Winter is Coming Dark Blue" "Winter is Coming Light"    
```
