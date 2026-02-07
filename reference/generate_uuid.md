# Generate random UUIDs

Generate version 4 (pseudo-random) Universally Unique Identifiers
(UUIDs).

## Usage

``` r
generate_uuid(hint = NULL)
```

## Source

Heavily based on an unreleased version of
[`ids::uuid()`](https://rdrr.io/pkg/ids/man/uuid.html).

## Arguments

- hint:

  Optional. A character string (or object coercible with
  [`as.character()`](https://rdrr.io/r/base/character.html)) to be used
  as a random seed.

## Value

A character string representing a valid UUID that can be validated with
[`uuid::UUIDvalidate()`](https://rdrr.io/pkg/uuid/man/UUIDgenerate.html).

## Details

This helper function assigns a
[UUID](https://www.rfc-editor.org/rfc/rfc9562.html) for identifying
versions of generated themes.

## References

Davis KR, Peabody B, Leach P (2024). "Universally Unique IDentifiers
(UUIDs)." RFC 9562.
[doi:10.17487/RFC9562](https://doi.org/10.17487/RFC9562) ,
<https://www.rfc-editor.org/info/rfc9562>.

## See also

Other helpers:
[`on_rstudio()`](https://dieghernan.github.io/rstudiothemes/reference/on_rstudio.md)

## Examples

``` r
# Random
generate_uuid()
#> [1] "9ec3e5c8-c404-4e17-8e4c-81bd36aa3d2a"

generate_uuid()
#> [1] "04d42bbc-2145-4ebe-83ef-a1a2d8d52a86"

# Persistent with hint param

hint <- "something as seed"

generate_uuid(hint)
#> [1] "736f6d65-7468-496e-a720-617320736565"

generate_uuid(hint)
#> [1] "736f6d65-7468-496e-a720-617320736565"
```
