# Convert a Visual Studio Code theme into a TextMate theme

Read a `*.json` file representing a Visual Studio Code theme and write
the equivalent TextMate theme (`*.tmTheme`).

## Usage

``` r
convert_vs_to_tm_theme(
  path,
  out_tm = tempfile(fileext = ".tmTheme"),
  name = NULL,
  author = NULL
)
```

## Arguments

- path:

  Path to a Visual Studio Code theme, in `*.json` format.

- out_tm:

  Path were the resulting file would be written. By default is a
  temporal file ([`tempfile()`](https://rdrr.io/r/base/tempfile.html)).

- name:

  Optional. The name of the theme. If nor provided the name of the VS
  Code theme in `path` would be used.

- author:

  Optional. The author of the theme. If nor provided the name of the VS
  Code theme in `path` would be used.

## Value

This function is called for its side effects. It would return a
character with the path of the file `out_tm`.

## Examples

``` r
vstheme <- system.file("ext/test-simple-color-theme.json",
  package = "rstudiothemes"
)
path <- convert_vs_to_tm_theme(vstheme)
#> ! VSCode theme "Skeletor Syntax" does not have author, use the `author` argument.
#> ℹ Using `author = "rstudiothemes R package"`.

path
#> [1] "C:\\Users\\RUNNER~1\\AppData\\Local\\Temp\\RtmpaMxEaB\\file2180559b3cf5.tmTheme"

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
