# Check whether the session is running in RStudio

Detect whether the current R session is running in RStudio, which is
used to decide whether themes can be applied to the IDE.

## Usage

``` r
on_rstudio()
```

## Value

`TRUE` if running in RStudio, `FALSE` otherwise.

## See also

Other helpers:
[`generate_uuid()`](https://dieghernan.github.io/rstudiothemes/dev/reference/generate_uuid.md)

## Examples

``` r
on_rstudio()
#> ! Detected GUI "X11".
#> [1] FALSE
```
