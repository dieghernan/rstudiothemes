# Theme mapping

This article summarizes how **rstudiothemes** maps theme elements
between **Visual Studio Code**, **Positron**, **TextMate** and
**RStudio** formats.

Sources:

- **TextMate** and **Visual Studio Code**:
  [vscode-generator-code](https://github.com/microsoft/vscode-generator-code/blob/main/generators/app/generate-colortheme.js)
- **TextMate** and **RStudio**:
  <https://rstudio.github.io/rstudio-extensions/rstudio-theme-creation.html>

When several source elements map to the same target element, priority
determines which mapping is used.

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

Table 1: Mapping between theme elements.
