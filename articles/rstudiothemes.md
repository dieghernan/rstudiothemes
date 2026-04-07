# Get started with rstudiothemes

The **rstudiothemes** package provides tools to convert **Visual Studio
Code/Positron** and **TextMate** themes into RStudio’s `.rstheme` format
and install them in your RStudio IDE. It also includes a set of
ready-to-use themes.

``` r
library(rstudiothemes)
```

## Installing built-in themes

To install all built-in RStudio themes that come with this package:

``` r
install_rstudiothemes()

#> ✔ Installed 30 themes
#> ℹ Use `rstudiothemes::list_rstudiothemes()` to list installed themes
#> ℹ Use `rstudiothemes::try_rstudiothemes()` to try all installed themes
```

This will add many popular themes (e.g., Tokyo Night, Nord, Winter is
Coming, Dracula, etc.) to your RStudio themes directory.

To see themes available now:

``` r
list_rstudiothemes(list_installed = FALSE)
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
#> [29] "SynthWave 84"               "Tokyo Night Light"         
#> [31] "Tokyo Night Storm"          "Tokyo Night"               
#> [33] "VSCode Dark"                "VSCode Light"              
#> [35] "Winter is Coming Dark Blue" "Winter is Coming Light"
```

## Trying themes

You can quickly preview themes directly from R:

``` r
try_rstudiothemes()
```

Pass a subset of styles (for example, `"dark"` or `"light"`) if needed.

## Applying a theme

After installing themes, apply one using the RStudio API:

``` r
rstudioapi::applyTheme("Winter is Coming Dark Blue")
```

![Screenshot of theme Winter is Coming Dark Blue](winteriscoming.png)

Figure 1: Screenshot of theme Winter is Coming Dark Blue

Alternatively, in RStudio go to **Tools \> Global Options \> Appearance
\> Add** and select the installed theme.

## Converting your own themes

You can convert a Visual Studio Code/Positron or TextMate theme file
into an RStudio theme:

``` r
convert_to_rstudio_theme(
  "<path/to/vscode-theme.json>",
  apply = TRUE,
  force = TRUE
)
```

This function will convert and install the theme immediately, optionally
applying it (with `apply = TRUE`).

## Workflow example: From Visual Studio Code/Positron theme to RStudio

1.  Choose a theme `.json` file from Visual Studio Code/Positron.
2.  Convert and install it with
    [`convert_to_rstudio_theme()`](https://dieghernan.github.io/rstudiothemes/reference/convert_to_rstudio_theme.md).
3.  Apply it with
    [`rstudioapi::applyTheme()`](https://rstudio.github.io/rstudioapi/reference/applyTheme.html)
    or via RStudio UI.

This workflow lets you bring your preferred editor theme into RStudio.

## Tips and tricks

- **List installed themes:** `list_rstudiothemes(list_installed = TRUE)`
- **Try specific categories:** filter themes by Light/Dark style
- **Use the Add-Theme UI**: RStudio’s **Global Options \> Appearance \>
  Add** to manually add `.rstheme` files you’ve created or converted.
