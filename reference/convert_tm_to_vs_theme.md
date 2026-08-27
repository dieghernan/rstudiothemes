# Convert a TextMate theme file to Visual Studio Code or Positron

Convert a `.tmTheme` file representing a TextMate theme and write the
equivalent Visual Studio Code theme file (`.json`).

`convert_tm_to_positron_theme()` is an alias for
`convert_tm_to_vs_theme()`.

## Usage

``` r
convert_tm_to_vs_theme(
  path,
  outfile = tempfile(fileext = ".json"),
  name = NULL,
  author = NULL
)

convert_tm_to_positron_theme(
  path,
  outfile = tempfile(fileext = ".json"),
  name = NULL,
  author = NULL
)
```

## Arguments

- path:

  Path or URL to a TextMate theme file in `.tmTheme` format.

- outfile:

  Path where the resulting file will be written. Defaults to a temporary
  file created with
  [`tempfile()`](https://rdrr.io/r/base/tempfile.html).

- name:

  Theme name. If `NULL`, the name from the input file is used.

- author:

  Theme author. If `NULL`, the author is extracted from the input file,
  otherwise it defaults to "rstudiothemes R package".

## Value

This function is called for its side effects. It writes a `.json` theme
file to `outfile` and returns the path.

## See also

[`read_tm_theme()`](https://dieghernan.github.io/rstudiothemes/reference/read_tm_theme.md)
to inspect the input theme and
[`read_vs_theme()`](https://dieghernan.github.io/rstudiothemes/reference/read_vs_theme.md)
to inspect the converted theme.

Theme file converters:
[`convert_to_rstudio_theme()`](https://dieghernan.github.io/rstudiothemes/reference/convert_to_rstudio_theme.md),
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
#>   // Created with the rstudiothemes R package (c) dieghernan.
#>   // https://github.com/dieghernan/rstudiothemes
#>   "$schema": "vscode://schemas/color-theme",
#>   "name": "Testing RStudioTheme",
#>   "author": "rstudiothemes",
#>   "semanticHighlighting": true,
#>   "type": "dark",
#>   "tokenColors": [
#>     {
#>       "settings": {
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
