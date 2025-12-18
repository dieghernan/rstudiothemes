# Random UUIDs generation

Generate Universally Unique Identifiers (UUID) version 4 (pseudo-random
numbers).

## Usage

``` r
generate_uuid(hint = NULL)
```

## Source

Heavily based on unreleased version of `ids::uuid()`.

## Arguments

- hint:

  Optional. Character (or object coercible with
  [`as.character()`](https://rdrr.io/r/base/character.html)) that may be
  used as random seed.

## Value

A [`character()`](https://rdrr.io/r/base/character.html) representing
valid UUID that can be validated with
[`uuid::UUIDvalidate()`](https://rdrr.io/pkg/uuid/man/UUIDgenerate.html).

## Details

This is a helper function that assign
[UUID](https://www.rfc-editor.org/rfc/rfc9562.html) for identifying
versions of the generated themes.

## References

Davis KR, Peabody B, Leach P (2024). "Universally Unique IDentifiers
(UUIDs)." RFC 9562.
[doi:10.17487/RFC9562](https://doi.org/10.17487/RFC9562) ,
<https://www.rfc-editor.org/info/rfc9562>.

## Examples

``` r
# Random
generate_uuid()
#> [1] "cb3ee465-6e2e-4ec3-a5c8-c404fe174e4c"

generate_uuid()
#> [1] "81bd36aa-3d2a-44d4-abbc-2145febe03ef"

# Persistent with hint param

hint <- "something as seed"

generate_uuid(hint)
#> [1] "736f6d65-7468-496e-a720-617320736565"

generate_uuid(hint)
#> [1] "736f6d65-7468-496e-a720-617320736565"
```
