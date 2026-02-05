# Generate random UUIDs

Generate version 4 (pseudo-random) Universally Unique Identifiers
(UUIDs).

## Usage

``` r
generate_uuid(hint = NULL)
```

## Source

Heavily based on an unreleased version of `ids::uuid()`.

## Arguments

- hint:

  Optional. Character (or object coercible with
  [`as.character()`](https://rdrr.io/r/base/character.html)) that may be
  used as a random seed.

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

## Examples

``` r
# Random
generate_uuid()
#> [1] "6e2e9ec3-e5c8-4404-be17-4e4c81bd36aa"

generate_uuid()
#> [1] "3d2a04d4-2bbc-4145-bebe-03efa1a2d8d5"

# Persistent with hint param

hint <- "something as seed"

generate_uuid(hint)
#> [1] "736f6d65-7468-496e-a720-617320736565"

generate_uuid(hint)
#> [1] "736f6d65-7468-496e-a720-617320736565"
```
