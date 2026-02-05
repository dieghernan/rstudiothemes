# Convert a TextMate theme into a Visual Studio Code theme

Read a `*.tmTheme` file representing a TextMate theme and write the
equivalent Visual Studio Code theme (`*.json`).

## Usage

``` r
convert_tm_to_vs_theme(
  path,
  outfile = tempfile(fileext = ".json"),
  name = NULL,
  author = NULL
)
```

## Arguments

- path:

  Path to a TextMate theme, in `*.tmTheme` format.

- outfile:

  Path where the resulting file will be written. By default a temporary
  file ([`tempfile()`](https://rdrr.io/r/base/tempfile.html)).

- name:

  Optional. The name of the theme. If not provided, the name of the
  theme in `path` will be used.

- author:

  Optional. The author of the theme. If not provided, the name of the
  theme in `path` will be used.

## Value

This function is called for its side effects. It would write a new
`*.json` file in `outfile` and returns the path.

## See also

Other functions for creating themes:
[`convert_to_rs_theme()`](https://dieghernan.github.io/rstudiothemes/reference/convert_to_rs_theme.md),
[`convert_vs_to_tm_theme()`](https://dieghernan.github.io/rstudiothemes/reference/convert_vs_to_tm_theme.md)

## Examples

``` r
tmtheme <- system.file("ext/test.tmTheme",
  package = "rstudiothemes"
)
path <- convert_tm_to_vs_theme(tmtheme)

readLines(path) |>
  head(50) |>
  cat(sep = "\n")
#> {
#>   // Created with the R package rstudiothemes (c) dieghernan.
#>   // https://github.com/dieghernan/rstudiothemes
#>   "name": "Testing RStudioTheme",
#>   "author": "rstudiothemes",
#>   "semanticHighlighting": true,
#>   "type": "dark",
#>   "tokenColors": [
#>     {
#>       "settings": {
#>         "background": "#2B2836",
#>         "foreground": "#DCE7FD"
#>       }
#>     },
#>     {
#>       "name": "comment",
#>       "scope": "comment",
#>       "settings": {
#>         "foreground": "#655E7F"
#>       }
#>     },
#>     {
#>       "name": "doctype",
#>       "scope": ["meta.tag.metadata.doctype", "meta.tag.sgml.doctype.html", "meta.tag.sgml.html"],
#>       "settings": {
#>         "foreground": "#655E7F"
#>       }
#>     },
#>     {
#>       "name": "punctuation",
#>       "scope": ["punctuation.definition.tag", "punctuation.separator"],
#>       "settings": {
#>         "foreground": "#DCE7FD"
#>       }
#>     },
#>     {
#>       "name": "namespace,",
#>       "scope": ["entity.name.type.namespace", "storage.modifier.import"],
#>       "settings": {
#>         "foreground": "#6A6872"
#>       }
#>     },
#>     {
#>       "name": "string",
#>       "scope": "string",
#>       "settings": {
#>         "foreground": "#93B4FF"
#>       }
#>     },
#>     {
```
