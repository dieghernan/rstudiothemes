# Generate random UUIDs

Generate version 4 pseudo-random Universally Unique Identifiers (UUIDs).

## Usage

``` r
generate_uuid(hint = NULL)
```

## Source

Heavily based on an unreleased version of `ids::uuid()`.

## Arguments

- hint:

  Optional character string or object coercible with
  [`as.character()`](https://rdrr.io/r/base/character.html). Used as a
  random seed.

## Value

A character string representing a valid UUID that can be validated with
[`uuid::UUIDvalidate()`](https://rdrr.io/pkg/uuid/man/UUIDgenerate.html).

## Details

This helper generates a
[UUID](https://rdrr.io/pkg/uuid/man/UUIDgenerate.html) for identifying
generated theme versions.

## References

Davis KR, Peabody B and Leach P (2024). "Universally Unique Identifiers
(UUIDs)." RFC 9562.
[doi:10.17487/RFC9562](https://doi.org/10.17487/RFC9562) ,
<https://www.rfc-editor.org/info/rfc9562>.

## See also

Helper functions:
[`on_rstudio()`](https://dieghernan.github.io/rstudiothemes/reference/on_rstudio.md)

## Examples

``` r
# Random UUID.
generate_uuid()
#> [1] "ac96cb3e-e465-4e2e-9ec3-e5c8c404fe17"

generate_uuid()
#> [1] "4e4c81bd-36aa-4d2a-84d4-2bbc2145febe"

# Persistent UUID with `hint`.
hint <- "something as seed"

generate_uuid(hint)
#> [1] "736f6d65-7468-496e-a720-617320736565"

generate_uuid(hint)
#> [1] "736f6d65-7468-496e-a720-617320736565"
```
