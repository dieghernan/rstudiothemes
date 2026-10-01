# Get started with rstudiothemes

The **rstudiothemes** package provides tools to convert **Visual Studio
Code**, **Positron** and **TextMate** theme files to **RStudio**
`.rstheme` files and install them in your **RStudio** IDE. It also
includes bundled **RStudio** themes.

``` r

library(rstudiothemes)
```

## Install bundled themes

To install all bundled **RStudio** themes:

``` r

install_rstudiothemes()

#> ✔ Installed 38 themes
#> ℹ Use `rstudiothemes::list_rstudiothemes()` to list installed themes.
#> ℹ Use `rstudiothemes::try_rstudiothemes()` to preview installed themes.
```

This adds popular themes such as Tokyo Night, Nord, Winter is Coming and
Dracula2025 to your **RStudio** themes directory.

To list the themes available in the package:

``` r

list_rstudiothemes(list_installed = FALSE)
#>  [1] "Andromeda"                  "ayu Dark"                  
#>  [3] "ayu Light"                  "Barbie Theme"              
#>  [5] "Bluloco Light"              "Catppuccin Latte"          
#>  [7] "Catppuccin Mocha"           "cobalt2"                   
#>  [9] "CRAN"                       "Dracula2025"               
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
#> [31] "SynthWave 84"               "Tokyo Night Light"         
#> [33] "Tokyo Night Storm"          "Tokyo Night"               
#> [35] "VSCode Dark"                "VSCode Light"              
#> [37] "Winter is Coming Dark Blue" "Winter is Coming Light"
```

## Preview themes

You can preview installed themes from an **R** session:

``` r

try_rstudiothemes()
```

Set `style` to `"dark"` or `"light"` to filter the preview. During the
preview, press `k` to keep the current theme.

## Apply a theme

After installing themes, apply one with the **rstudioapi** package:

``` r

rstudioapi::applyTheme("Winter is Coming Dark Blue")
```

![RStudio screenshot with the Winter is Coming Dark Blue theme applied.
The editor and surrounding panes have dark blue backgrounds, with R code
highlighted in contrasting colors.](winteriscoming.png)

Figure 1: Screenshot of the Winter is Coming Dark Blue theme.

To apply an installed theme in **RStudio**, choose
`Tools > Global Options > Appearance` and select it from the editor
theme list.

## Convert your own themes

You can convert a **Visual Studio Code**, **Positron** or **TextMate**
theme file to an **RStudio** `.rstheme` file:

``` r

convert_to_rstudio_theme(
  "<path/to/vscode-theme.json>",
  apply = TRUE,
  force = TRUE
)
```

This function writes the `.rstheme` file, installs it and applies it
when `apply = TRUE`.

## Workflow example: from Visual Studio Code or Positron to RStudio

- Choose a `.json` theme file from **Visual Studio Code** or
  **Positron**.
- Convert and install it with
  [`convert_to_rstudio_theme()`](https://dieghernan.github.io/rstudiothemes/reference/convert_to_rstudio_theme.md).
- Apply it with
  [`rstudioapi::applyTheme()`](https://rstudio.github.io/rstudioapi/reference/applyTheme.html)
  or the **RStudio** interface.

This workflow brings your preferred editor theme to **RStudio**.

## Tips and tricks

- List installed themes with
  `list_rstudiothemes(list_installed = TRUE)`.
- Filter themes by `"light"` or `"dark"` style.
- In **RStudio**, choose `Tools > Global Options > Appearance > Add` to
  install `.rstheme` files that you have created or converted.
