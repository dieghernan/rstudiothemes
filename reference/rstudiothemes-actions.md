# Install, list, try or remove RStudio themes

Adaptation of some rsthemes functions, [MIT
License](https://github.com/gadenbuie/rsthemes/blob/main/LICENSE.md)
Copyright © rsthemes authors.

**Important**: These functions (except
`list_rstudiothemes(list_installed = FALSE)`) only work in RStudio; they
return `NULL` when called from other IDEs.

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

  Character. Limit themes to a specific group: `all`, `dark`, or
  `light`.

- themes:

  Optional character vector of theme names. If provided, only these
  themes will be used, and `style` will be ignored.

- destdir:

  Optional directory for `.rstheme` files. By default uses
  [`rstudioapi::addTheme()`](https://rstudio.github.io/rstudioapi/reference/addTheme.html),
  but this argument allows installation to non-standard directories.

- list_installed:

  Should the installed rstudiothemes themes be listed (default). If
  `FALSE`, the available themes in the rstudiothemes package are listed
  instead.

- delay:

  Number of seconds to wait between themes. Set to 0 to be prompted to
  continue after each theme.

## Value

- `install_rstudiothemes()` and `remove_rstudiothemes()` return `NULL`
  invisibly.

&nbsp;

- `list_rstudiothemes()` returns a character vector of theme names.

&nbsp;

- `try_rstudiothemes()` has side effects of starting a widget that
  allows users to try different themes. The widget can be exited by
  following the prompts, which will restore the original theme.

## Functions

- `install_rstudiothemes()`: Install RStudio themes

- `remove_rstudiothemes()`: Remove rstudiothemes from RStudio

- `list_rstudiothemes()`: List installed or available themes

- `try_rstudiothemes()`: Try each rstudiothemes RStudio theme

## Ported Themes

rstudiothemes includes RStudio themes based on the following Visual
Studio Code themes:

- Ayu by teabyii.

- Cobalt2 Theme Official by Wes Bos.

- CRAN by dieghernan, based on the CRAN (R Project) website theme,
  created with Pandoc

- Dracula Official by <https://draculatheme.com/>.

- GitHub Dark and Light by GitHub.

- JellyFish Theme by Pawel Borkar.

- Matrix Theme by UstymUkhman.

- Night Owl Dark and Light (no italics) by Sarah Drasner.

- Nord by Arctic Ice Studio.

- OKSolar Theme by dieghernan.

- Overflow Theme by dieghernan.

- Panda Theme by Panda Theme.

- Selenized Themes by dieghernan.

- Skeletor Syntax by dieghernan.

- SynthWave '84 by Robb Owen.

- Tokyo Night by Enkia.

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
#>  [1] "ayu Dark"                   "ayu Light"                 
#>  [3] "Dracula2025"                "GitHub Dark"               
#>  [5] "GitHub Light"               "JellyFish Theme"           
#>  [7] "Matrix"                     "Night Owl"                 
#>  [9] "Night Owl Light"            "Nord"                      
#> [11] "OKSolar Dark"               "OKSolar Light"             
#> [13] "OKSolar Sky"                "Overflow Dark"             
#> [15] "Overflow Light"             "Panda Syntax"              
#> [17] "Selenized Dark"             "Selenized Light"           
#> [19] "Skeletor Syntax"            "SynthWave 84"              
#> [21] "Tokyo Night"                "Tokyo Night Light"         
#> [23] "Tokyo Night Storm"          "Winter is Coming Dark Blue"
#> [25] "Winter is Coming Light"     "cobalt2"                   
#> [27] "CRAN"                      
```
