# Check whether the session is running in **RStudio**

Detect whether the current R session is running in **RStudio** to decide
whether themes can be applied to the IDE.

## Usage

``` r
on_rstudio()
```

## Value

A [logical](https://rdrr.io/r/base/logical.html) value, `TRUE` if
running in **RStudio** and `FALSE` otherwise.

## See also

Package helpers:
[`generate_uuid()`](https://dieghernan.github.io/rstudiothemes/reference/generate_uuid.md)

## Examples

``` r
on_rstudio()
#> ! Detected GUI "X11".
#> [1] FALSE
```
