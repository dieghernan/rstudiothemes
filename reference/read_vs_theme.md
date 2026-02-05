# Read and parse a Visual Studio Code theme

Read a `*.json` file representing a Visual Studio Code theme.

## Usage

``` r
read_vs_theme(path)
```

## Arguments

- path:

  Path to a Visual Studio Code theme, in `*.json` format.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html)
with the data of the theme.

## See also

Other functions for reading themes:
[`read_tm_theme()`](https://dieghernan.github.io/rstudiothemes/reference/read_tm_theme.md)

## Examples

``` r
vstheme <- system.file("ext/test-color-theme.json",
  package = "rstudiothemes"
)
read_vs_theme(vstheme)
#> # A tibble: 706 × 7
#>    section   name                  scope value   foreground background fontStyle
#>    <chr>     <chr>                 <chr> <chr>   <chr>      <lgl>      <chr>    
#>  1 highlevel name                  NA    Tokyo … NA         NA         NA       
#>  2 highlevel author                NA    Enkia   NA         NA         NA       
#>  3 highlevel type                  NA    dark    NA         NA         NA       
#>  4 colors    foreground            NA    NA      #787C99    NA         NA       
#>  5 colors    descriptionForeground NA    NA      #515670    NA         NA       
#>  6 colors    disabledForeground    NA    NA      #545C7E    NA         NA       
#>  7 colors    focusBorder           NA    NA      #545C7E33  NA         NA       
#>  8 colors    errorForeground       NA    NA      #515670    NA         NA       
#>  9 colors    widget.shadow         NA    NA      #FFFFFF00  NA         NA       
#> 10 colors    scrollbar.shadow      NA    NA      #00000033  NA         NA       
#> # ℹ 696 more rows
```
