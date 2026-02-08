# Check whether the session is running in RStudio

Detect whether the current R session is running in RStudio; used to
decide if themes can be applied to the IDE.

## Usage

``` r
on_rstudio()
```

## Value

Logical; `TRUE` if running in RStudio, otherwise `FALSE`.

## See also

Other helpers:
[`generate_uuid()`](https://dieghernan.github.io/rstudiothemes/reference/generate_uuid.md)

## Examples

``` r
on_rstudio()
#> ! Detected GUI: "X11".
#> [1] FALSE
```
