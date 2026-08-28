# Theme mapping

This article summarizes how **rstudiothemes** maps theme colors and
syntax scopes between **Visual Studio Code**, **Positron**, **TextMate**
and **RStudio** formats.

## RStudio theme generation

An **RStudio** `.rstheme` file is CSS, but converting a **TextMate**
`.tmTheme` file does not consist of mapping every setting directly to a
CSS selector. When **RStudio** imports a `.tmTheme` file, it converts
the theme to `.rstheme` before saving it.

[`convert_to_rstudio_theme()`](https://dieghernan.github.io/rstudiothemes/dev/reference/convert_to_rstudio_theme.md)
delegates the same base conversion to
[`rstudioapi::convertTheme()`](https://rstudio.github.io/rstudioapi/reference/convertTheme.html).
**RStudio** performs the following steps internally:

1.  It reads the global **TextMate** settings and supported scopes.
2.  It inserts the resulting styles into an [**ACE** CSS
    template](https://github.com/rstudio/rstudio/blob/main/src/cpp/session/resources/templates/ace_theme_template.css).
3.  It determines whether the theme is dark from the perceived luminance
    of its background, then compiles the **ACE** CSS into an `.rstheme`
    file.
4.  It derives additional editor and terminal styles from the background
    and foreground colors.

For example, **RStudio** copies the editor background to the gutter
background, mixes the foreground and background equally for the gutter
text and uses the selection color for the selected-word border. It also
derives colors for code chunks, debugging, errors and the terminal.
These operations are defined in
[`SessionThemes.R`](https://github.com/rstudio/rstudio/blob/main/src/cpp/session/modules/SessionThemes.R)
and
[`compile-themes.R`](https://github.com/rstudio/rstudio/blob/main/src/cpp/session/resources/themes/compile-themes.R).

After this internal conversion, **rstudiothemes** adds a
package-specific GUI layer. It uses four global **TextMate** colors as
its interface palette:

| **TextMate** setting | Role in the **RStudio** GUI |
|----|----|
| `background` | Base color for panes, toolbars, tabs, menus and popups. |
| `foreground` | Text color and a source for neutral backgrounds and borders. |
| `caret` | Accent color for active tabs, selected menu items and find results. |
| `selection` | Progress indicator color. |

The GUI stylesheet derives five intermediate colors from that palette:

| Derived color | Mix | Main uses |
|----|----|----|
| Background accent 1 | 98% background, 2% accent | Panel, tab, menu and popup backgrounds. |
| Background accent 2 | 80% background, 20% accent | Active and hovered tabs, borders, selected menus and scrollbars. |
| Foreground accent | 50% foreground, 50% accent | Checkboxes in dark themes. |
| Background foreground 1 | 90% background, 10% foreground | Window chrome, table headers and inactive tabs. |
| Background foreground 2 | 70% background, 30% foreground | Borders and separators. |

This GUI layer does not add syntax-highlighting token mappings. It
extends the generated `.rstheme` so that more of the **RStudio**
interface follows the source theme. Consequently, an empty cell in the
`rstheme` column below means there is no direct one-to-one CSS selector
in the package mapping. The value may still affect the generated theme
through **RStudio**’s internal conversion or the derived GUI palette.

## Sources

- **TextMate** and **Visual Studio Code**:
  [vscode-generator-code](https://github.com/microsoft/vscode-generator-code/blob/main/generators/app/generate-colortheme.js)
- **Visual Studio Code** syntax scopes: [Syntax Highlight
  Guide](https://code.visualstudio.com/api/language-extensions/syntax-highlight-guide)
- **rstudiothemes** scope conversion:
  [`convert-vs-to-tm.R`](https://github.com/dieghernan/rstudiothemes/blob/main/R/convert-vs-to-tm.R)
  and
  [`convert-tm-to-vs.R`](https://github.com/dieghernan/rstudiothemes/blob/main/R/convert-tm-to-vs.R).
- **TextMate** and **RStudio**:
  <https://rstudio.github.io/rstudio-extensions/rstudio-theme-creation.html>
- **RStudio** conversion internals:
  [`ace_theme_template.css`](https://github.com/rstudio/rstudio/blob/main/src/cpp/session/resources/templates/ace_theme_template.css),
  [`SessionThemes.R`](https://github.com/rstudio/rstudio/blob/main/src/cpp/session/modules/SessionThemes.R)
  and
  [`compile-themes.R`](https://github.com/rstudio/rstudio/blob/main/src/cpp/session/resources/themes/compile-themes.R).

## Color mapping

When several source elements map to the same target element, the mapping
priority determines which value is used.

| priority | tm | vscode | rstheme |
|---:|:---|:---|:---|
| 1 | background | editor.background |  |
| 2 | background | background |  |
| 1 | foreground | editor.foreground |  |
| 2 | foreground | foreground |  |
| 1 | hoverHighlight | editor.hoverHighlightBackground |  |
| 1 | linkForeground | editorLink.foreground |  |
| 1 | selection | editor.selectionBackground |  |
| 1 | inactiveSelection | editor.inactiveSelectionBackground |  |
| 1 | selectionHighlightColor | editor.selectionHighlightBackground |  |
| 1 | wordHighlight | editor.wordHighlightBackground |  |
| 1 | wordHighlightStrong | editor.wordHighlightStrongBackground |  |
| 1 | findMatchHighlight | editor.findMatchHighlightBackground |  |
| 2 | findMatchHighlight | peekViewResult.matchHighlightBackground |  |
| 1 | currentFindMatchHighlight | editor.findMatchBackground |  |
| 1 | findRangeHighlight | editor.findRangeHighlightBackground |  |
| 1 | referenceHighlight | peekViewEditor.matchHighlightBackground |  |
| 1 | lineHighlight | editor.lineHighlightBackground |  |
| 1 | rangeHighlight | editor.rangeHighlightBackground |  |
| 1 | caret | editorCursor.foreground | .ace_cursor |
| 1 | invisibles | editorWhitespace.foreground |  |
| 2 | invisibles | editorRuler.foreground | .ace_print-margin |
| 1 | guide | editorIndentGuide.background |  |
| 2 | guide | editorIndentGuide.background1 |  |
| 1 | ansiBlack | terminal.ansiBlack |  |
| 1 | ansiRed | terminal.ansiRed |  |
| 1 | ansiGreen | terminal.ansiGreen |  |
| 1 | ansiYellow | terminal.ansiYellow |  |
| 1 | ansiBlue | terminal.ansiBlue |  |
| 1 | ansiMagenta | terminal.ansiMagenta |  |
| 1 | ansiCyan | terminal.ansiCyan |  |
| 1 | ansiWhite | terminal.ansiWhite |  |
| 1 | ansiBrightBlack | terminal.ansiBrightBlack |  |
| 1 | ansiBrightRed | terminal.ansiBrightRed |  |
| 1 | ansiBrightGreen | terminal.ansiBrightGreen |  |
| 1 | ansiBrightYellow | terminal.ansiBrightYellow |  |
| 1 | ansiBrightBlue | terminal.ansiBrightBlue |  |
| 1 | ansiBrightMagenta | terminal.ansiBrightMagenta |  |
| 1 | ansiBrightCyan | terminal.ansiBrightCyan |  |
| 1 | ansiBrightWhite | terminal.ansiBrightWhite |  |
| 1 | gutter | editorGutter.background |  |
| 1 | gutterForeground | editorLineNumber.foreground |  |
| 1 | invalid | errorForeground |  |
| 2 | invalid | list.errorForeground |  |
| 3 | invalid | inputValidation.errorBorder |  |
| 4 | invalid | editorBracketHighlight.unexpectedBracket.foreground |  |
| 1 | markup.heading |  | .ace_heading |

Table 1: Color mapping between theme formats.

## Syntax scope mapping

Before calling the **RStudio** converter, **rstudiothemes** converts a
**Visual Studio Code** theme to **TextMate** internally. Rules from
`tokenColors` retain their **TextMate** scope names. The conversion
removes selectors containing `*`, gives `semanticTokenColors` precedence
when it supplies the same scope and combines scopes that share a name
and style into one **TextMate** rule. The reverse conversion writes the
**TextMate** scopes to `tokenColors[].scope`.

This process preserves scope names rather than translating one scope
vocabulary into another. **Visual Studio Code** also defines its
`tokenColors` rules using the **TextMate** theme syntax, so the two
formats share the scope shown in the middle column of
[Table 2](#tbl-scopes). This does not imply that arbitrary
`semanticTokenColors` keys are equivalent to **TextMate** scopes.

The table lists the exact scopes recognized by the internal **RStudio**
converter and the **ACE** selector it generates. **rstudiothemes** may
generate CSS rules for other compatible scopes with up to three
dot-separated components, so this is the **RStudio** baseline rather
than an exhaustive list of every selector that can appear in the final
`.rstheme` file.

| Category | **Visual Studio Code** / **TextMate** scope | **RStudio** **ACE** selector |
|----|----|----|
| Keyword | `keyword` | `.ace_keyword` |
| Keyword | `keyword.operator` | `.ace_keyword.ace_operator` |
| Keyword | `keyword.other.unit` | `.ace_keyword.ace_other.ace_unit` |
| Constant | `constant` | `.ace_constant` |
| Constant | `constant.language` | `.ace_constant.ace_language` |
| Constant | `constant.library` | `.ace_constant.ace_library` |
| Constant | `constant.numeric` | `.ace_constant.ace_numeric` |
| Constant | `constant.character` | `.ace_constant.ace_character` |
| Constant | `constant.character.escape` | `.ace_constant.ace_character.ace_escape` |
| Constant | `constant.character.entity` | `.ace_constant.ace_character.ace_entity` |
| Constant | `constant.other` | `.ace_constant.ace_other` |
| Support | `support` | `.ace_support` |
| Support | `support.function` | `.ace_support.ace_function` |
| Support | `support.function.dom` | `.ace_support.ace_function.ace_dom` |
| Support | `support.function.firebug` | `.ace_support.ace_firebug` |
| Support | `support.function.constant` | `.ace_support.ace_function.ace_constant` |
| Support | `support.constant` | `.ace_support.ace_constant` |
| Support | `support.constant.property-value` | `.ace_support.ace_constant.ace_property-value` |
| Support | `support.class` | `.ace_support.ace_class` |
| Support | `support.type` | `.ace_support.ace_type` |
| Support | `support.other` | `.ace_support.ace_other` |
| Function | `function` | `.ace_function` |
| Function | `function.buildin` | `.ace_function.ace_buildin` |
| Storage | `storage` | `.ace_storage` |
| Storage | `storage.type` | `.ace_storage.ace_type` |
| Invalid | `invalid` | `.ace_invalid` |
| Invalid | `invalid.illegal` | `.ace_invalid.ace_illegal` |
| Invalid | `invalid.deprecated` | `.ace_invalid.ace_deprecated` |
| String | `string` | `.ace_string` |
| String | `string.regexp` | `.ace_string.ace_regexp` |
| Comment | `comment` | `.ace_comment` |
| Comment | `comment.documentation` | `.ace_comment.ace_doc` |
| Comment | `comment.documentation.tag` | `.ace_comment.ace_doc.ace_tag` |
| Variable | `variable` | `.ace_variable` |
| Variable | `variable.language` | `.ace_variable.ace_language` |
| Variable | `variable.parameter` | `.ace_variable.ace_parameter` |
| Metadata | `meta` | `.ace_meta` |
| Metadata | `meta.tag.sgml.doctype` | `.ace_xml-pe` |
| Metadata | `meta.tag` | `.ace_meta.ace_tag` |
| Metadata | `meta.selector` | `.ace_meta.ace_selector` |
| Entity | `entity.other.attribute-name` | `.ace_entity.ace_other.ace_attribute-name` |
| Entity | `entity.name.function` | `.ace_entity.ace_name.ace_function` |
| Entity | `entity.name` | `.ace_entity.ace_name` |
| Entity | `entity.name.tag` | `.ace_entity.ace_name.ace_tag` |
| Markup | `markup.heading` | `.ace_markup.ace_heading` |
| Markup | `markup.heading.1` | `.ace_markup.ace_heading.ace_1` |
| Markup | `markup.heading.2` | `.ace_markup.ace_heading.ace_2` |
| Markup | `markup.heading.3` | `.ace_markup.ace_heading.ace_3` |
| Markup | `markup.heading.4` | `.ace_markup.ace_heading.ace_4` |
| Markup | `markup.heading.5` | `.ace_markup.ace_heading.ace_5` |
| Markup | `markup.heading.6` | `.ace_markup.ace_heading.ace_6` |
| Markup | `markup.list` | `.ace_markup.ace_list` |
| Collaboration | `collab.user1` | `.ace_collab.ace_user1` |
| Editor marker | `marker-layer.active_debug_line` | `.ace_marker-layer .ace_active_debug_line` |

Table 2: Syntax scopes shared by **Visual Studio Code** and
**TextMate**, with the selectors generated by **RStudio**.

The `function.buildin` spelling is reproduced exactly from **RStudio**’s
supported-scope list.
