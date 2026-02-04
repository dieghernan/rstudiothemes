# Read and parse a TextMate theme

Read a `*.tmTheme` file (really a `*.xml` file) representing a TextMate
or a Sublime Text theme.

## Usage

``` r
read_tmtheme(tmtheme)
```

## Arguments

- tmtheme:

  Path to a TextMate theme, in `*.tmTheme` format.

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html).

## See also

Other converters:
[`read_vstheme()`](https://dieghernan.github.io/rstudiothemes/reference/read_vstheme.md),
[`vstheme2tmtheme()`](https://dieghernan.github.io/rstudiothemes/reference/vstheme2tmtheme.md)

## Examples

``` r
the_theme <- system.file("ext/test-color-theme.json",
  package = "rstudiothemes"
) |>
  # Generate the theme
  vstheme2tmtheme()

# Check
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

read_tmtheme(the_theme)
#> # A tibble: 372 × 7
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
#> # ℹ 362 more rows
```
