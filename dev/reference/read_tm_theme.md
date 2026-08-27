# Read and parse a **TextMate** theme file

Read a `.tmTheme` XML file representing a **TextMate** or **Sublime
Text** theme.

## Usage

``` r
read_tm_theme(path)
```

## Arguments

- path:

  Path or URL to a **TextMate** theme file in `.tmTheme` format.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html)
containing the theme data.

## See also

[`convert_tm_to_vs_theme()`](https://dieghernan.github.io/rstudiothemes/dev/reference/convert_tm_to_vs_theme.md)
and
[`convert_to_rstudio_theme()`](https://dieghernan.github.io/rstudiothemes/dev/reference/convert_to_rstudio_theme.md)
to convert **TextMate** themes.

Theme file readers:
[`read_vs_theme()`](https://dieghernan.github.io/rstudiothemes/dev/reference/read_vs_theme.md)

## Examples

``` r
the_theme <- system.file("ext/test-color-theme.json",
  package = "rstudiothemes"
) |>
  # Convert the Visual Studio Code theme to TextMate format.
  convert_vs_to_tm_theme()

# Check the converted theme.
readLines(the_theme) |>
  head(10) |>
  cat(sep = "\n")
#> <?xml version="1.0" encoding="UTF-8"?>
#> <plist version="1.0">
#>   <dict>
#>     <key>name</key>
#>     <string>Tokyo Night</string>
#>     <key>author</key>
#>     <string>Enkia, rstudiothemes R package</string>
#>     <key>colorSpaceName</key>
#>     <string>sRGB</string>
#>     <key>semanticClass</key>

read_tm_theme(the_theme)
#> # A tibble: 373 × 7
#>    section   name              scope value       foreground background fontStyle
#>    <chr>     <chr>             <chr> <chr>       <chr>      <lgl>      <chr>    
#>  1 highlevel name              NA    Tokyo Night NA         NA         NA       
#>  2 highlevel author            NA    Enkia, rst… NA         NA         NA       
#>  3 highlevel colorSpaceName    NA    sRGB        NA         NA         NA       
#>  4 highlevel semanticClass     NA    theme.dark… NA         NA         NA       
#>  5 highlevel comment           NA    Generated … NA         NA         NA       
#>  6 highlevel uuid              NA    39376365-3… NA         NA         NA       
#>  7 colors    background        NA    NA          #1A1B26    NA         NA       
#>  8 colors    foreground        NA    NA          #A9B1D6    NA         NA       
#>  9 colors    selection         NA    NA          #515C7E4D  NA         NA       
#> 10 colors    inactiveSelection NA    NA          #515C7E25  NA         NA       
#> # ℹ 363 more rows
```
