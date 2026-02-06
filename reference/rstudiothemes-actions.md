# Install, list, try or remove RStudio themes

Adaptation of some rsthemes functions, [MIT
License](https://github.com/gadenbuie/rsthemes/blob/main/LICENSE.md)
Copyright © rsthemes authors.

**Important**: These functions (except
`list_rstudiothemes(list_installed = FALSE)` only works in RStudio; it
returns `NULL` when called from other IDEs.

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

  Limit to a subgroup of themes (`all`, `dark`, `light`).

- themes:

  Vector of theme names (`list_rstudiothemes()`). If provided just those
  themes would be tried, and `style` will be ignored.

- destdir:

  The destination directory for the `.rstheme` files. By default uses
  [`rstudioapi::addTheme()`](https://rstudio.github.io/rstudioapi/reference/addTheme.html)
  to install themes, but this argument lets users install themes to
  non-standard directories, or in case the location of the RStudio theme
  directory has changed.

- list_installed:

  Should the installed rstudiothemes themes be listed (default). If
  `FALSE`, the available themes in the rstudiothemes package are listed
  instead.

- delay:

  Number of seconds to wait between themes. Set to 0 to be prompted to
  continue after each theme.

## Functions

- `install_rstudiothemes()`: Install RStudio themes

- `remove_rstudiothemes()`: Remove rstudiothemes from RStudio

- `list_rstudiothemes()`: List installed themes (default) or available
  themes

- `try_rstudiothemes()`: Try each rstudiothemes RStudio theme

## Palettes

rstudiothemes includes RStudio themes based on the following color
palettes.

    # {r child="man/fragments/palettes.Rmd"}
    TODO

## References

Aden-Buie G (2026). *rsthemes: Full Themes for RStudio v1.2+*. R package
version 0.5.1,commit 48fc078f772e5e63669bc9773eabc8e9cdc7f699,
<https://github.com/gadenbuie/rsthemes>.

## Author

Garrick Aden-Buie <https://github.com/gadenbuie>

## Examples

``` r
list_rstudiothemes()
#> ℹ Detected GUI: "RTerm".
#> ✖ `rstudiothemes::list_rstudiothemes()` only works in RStudio, not in RTerm.
#> → Bye
#> NULL
```
