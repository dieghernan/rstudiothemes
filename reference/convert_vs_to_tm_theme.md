# Convert a Visual Studio Code theme into a TextMate theme

Read a `*.json` file representing a Visual Studio Code theme and write
the equivalent TextMate theme (`*.tmTheme`).

## Usage

``` r
convert_vs_to_tm_theme(
  path,
  outfile = tempfile(fileext = ".tmTheme"),
  name = NULL,
  author = NULL
)
```

## Arguments

- path:

  Path to a Visual Studio Code theme, in `*.json` format.

- outfile:

  Path where the resulting file will be written. By default a temporary
  file ([`tempfile()`](https://rdrr.io/r/base/tempfile.html)).

- name:

  Optional. The name of the theme. If not provided, the name of the VS
  Code theme in `path` will be used.

- author:

  Optional. The author of the theme. If not provided, the name of the VS
  Code theme in `path` will be used.

## Value

This function is called for its side effects: it writes a `*.tmTheme`
file to `outfile` and returns the path.

## See also

Other functions for creating themes:
[`convert_tm_to_vs_theme()`](https://dieghernan.github.io/rstudiothemes/reference/convert_tm_to_vs_theme.md)

## Examples

``` r
vstheme <- system.file("ext/test-simple-color-theme.json",
  package = "rstudiothemes"
)
path <- convert_vs_to_tm_theme(vstheme)
#> ! VSCode theme "Skeletor Syntax" does not have author, use the `author` argument.
#> ℹ Using `author = "rstudiothemes R package"`.

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
#>     <string>65316264-3362-4031-a334-396431643737</string>
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
