# Convert a Visual Studio Code or Positron theme file to TextMate

Convert a `.json` file representing a Visual Studio Code or Positron
theme and write the equivalent TextMate theme file (`.tmTheme`).

`convert_positron_to_tm_theme()` is an alias of
`convert_vs_to_tm_theme()`.

## Usage

``` r
convert_vs_to_tm_theme(
  path,
  outfile = tempfile(fileext = ".tmTheme"),
  name = NULL,
  author = NULL
)

convert_positron_to_tm_theme(
  path,
  outfile = tempfile(fileext = ".tmTheme"),
  name = NULL,
  author = NULL
)
```

## Arguments

- path:

  Path or URL to a Visual Studio Code or Positron theme file, in `.json`
  format.

- outfile:

  Path where the resulting file will be written. Defaults to a temporary
  file created with
  [`tempfile()`](https://rdrr.io/r/base/tempfile.html).

- name:

  Theme name. If `NULL`, the name from the input file is used.

- author:

  Theme author. If `NULL`, it attempts to extract the author from the
  input file, otherwise it defaults to "rstudiothemes R package".

## Value

This function is called for its side effects. It writes a `.tmTheme`
file to `outfile` and returns the file path.

## See also

Theme converters:
[`convert_tm_to_vs_theme()`](https://dieghernan.github.io/rstudiothemes/dev/reference/convert_tm_to_vs_theme.md),
[`convert_to_rstudio_theme()`](https://dieghernan.github.io/rstudiothemes/dev/reference/convert_to_rstudio_theme.md)

## Examples

``` r
vstheme <- system.file("ext/test-simple-color-theme.json",
  package = "rstudiothemes"
)
path <- convert_vs_to_tm_theme(vstheme)
#> ! The Visual Studio Code theme "Skeletor Syntax" does not list an author. Use the `author` argument.
#> ℹ Using default `author = "rstudiothemes R package"`.

readLines(path) |>
  head(50) |>
  cat(sep = "\n")
#> <?xml version="1.0" encoding="UTF-8"?>
#> <plist version="1.0">
#>   <dict>
#>     <key>name</key>
#>     <string>Skeletor Syntax</string>
#>     <key>author</key>
#>     <string>rstudiothemes R package</string>
#>     <key>colorSpaceName</key>
#>     <string>sRGB</string>
#>     <key>semanticClass</key>
#>     <string>theme.dark.skeletor_syntax</string>
#>     <key>comment</key>
#>     <string>Generated with rstudiothemes R package</string>
#>     <key>uuid</key>
#>     <string>65623931-3630-4063-b063-653630303437</string>
#>     <key>settings</key>
#>     <array>
#>       <dict>
#>         <key>settings</key>
#>         <dict>
#>           <key>background</key>
#>           <string>#2B2836</string>
#>           <key>foreground</key>
#>           <string>#DCE7FD</string>
#>           <key>selection</key>
#>           <string>#55535E</string>
#>           <key>lineHighlight</key>
#>           <string>#55535E</string>
#>           <key>caret</key>
#>           <string>#BD93F9</string>
#>           <key>invisibles</key>
#>           <string>#363340</string>
#>           <key>gutterForeground</key>
#>           <string>#655E7F</string>
#>         </dict>
#>       </dict>
#>       <dict>
#>         <key>name</key>
#>         <string>comment</string>
#>         <key>scope</key>
#>         <string>comment</string>
#>         <key>settings</key>
#>         <dict>
#>           <key>foreground</key>
#>           <string>#655E7F</string>
#>         </dict>
#>       </dict>
#>       <dict>
#>         <key>name</key>
#>         <string>doctype</string>
```
