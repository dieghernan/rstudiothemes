# Get started with rstudiothemes

The **rstudiothemes** package provides tools to convert **Visual Studio
Code** and **TextMate** themes into RStudio’s `.rstheme` format and
install them in your RStudio IDE. It also includes a set of ready-to-use
themes.

``` r
library(rstudiothemes)
```

## Installing Built-In Themes

To install all built-in RStudio themes that come with this package:

``` r
install_rstudiothemes()

#> ✔ Installed 27 themes
#> ℹ Use `rstudiothemes::list_rstudiothemes()` to list installed themes
#> ℹ Use `rstudiothemes::try_rstudiothemes()` to try all installed themes
```

This will add many popular themes (e.g., Tokyo Night, Nord, Winter is
Coming, Dracula, etc.) to your RStudio themes directory.

To see themes available now:

``` r
list_rstudiothemes(list_installed = FALSE)
#>  [1] "ayu Dark"                   "ayu Light"                 
#>  [3] "cobalt2"                    "CRAN"                      
#>  [5] "Dracula2025"                "GitHub Dark"               
#>  [7] "GitHub Light"               "JellyFish Theme"           
#>  [9] "Matrix"                     "Night Owl"                 
#> [11] "Night Owl Light"            "Nord"                      
#> [13] "OKSolar Dark"               "OKSolar Light"             
#> [15] "OKSolar Sky"                "Overflow Dark"             
#> [17] "Overflow Light"             "Panda Syntax"              
#> [19] "Selenized Dark"             "Selenized Light"           
#> [21] "Skeletor Syntax"            "SynthWave 84"              
#> [23] "Tokyo Night"                "Tokyo Night Light"         
#> [25] "Tokyo Night Storm"          "Winter is Coming Dark Blue"
#> [27] "Winter is Coming Light"
```

## Trying Themes

You can quickly preview themes directly from R:

``` r
try_rstudiothemes()
```

Pass a subset of styles (e.g., `"dark"` or `"light"`) if needed.

## Applying a Theme

After installing themes, apply one using the RStudio API:

``` r
rstudioapi::applyTheme("Winter is Coming Dark Blue")
```

![Screenshot of theme Winter is Coming Dark Blue](winteriscoming.png)

Screenshot of theme Winter is Coming Dark Blue

Alternatively, go to **Tools → Global Options → Appearance** in RStudio
and select the installed theme.

## Converting Your Own Themes

You can convert a VS Code or TextMate theme file into an RStudio theme:

``` r
convert_to_rstudio_theme("<path/to/vscode-theme.json>",
  apply = TRUE, force = TRUE
)
```

This function will convert and install the theme immediately, optionally
applying it (with `apply = TRUE`).

## Workflow Example: From VS Code Theme to RStudio

1.  Choose a theme `.json` from VS Code.
2.  Convert and install it with
    [`convert_to_rstudio_theme()`](https://dieghernan.github.io/rstudiothemes/dev/reference/convert_to_rstudio_theme.md).
3.  Apply it with
    [`rstudioapi::applyTheme()`](https://rstudio.github.io/rstudioapi/reference/applyTheme.html)
    or via RStudio UI.

This workflow lets you easily bring your preferred editor theme into
RStudio.

## Tips and Tricks

- **List installed themes:** `list_rstudiothemes(list_installed = TRUE)`
- **Try specific categories:** filter themes by Light/Dark style
- **Use the Add-Theme UI**: RStudio’s **Global Options → Appearance →
  Add Theme** to manually add `.rstheme` files you’ve created or
  converted.
