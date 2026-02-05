# Errors

    Code
      convert_tm_to_vs_theme()
    Condition
      Error in `convert_tm_to_vs_theme()`:
      ! Argument `path` can't be empty.

---

    Code
      convert_tm_to_vs_theme("a.txt")
    Condition
      Error in `convert_tm_to_vs_theme()`:
      ! Argument `path` should be a "tmTheme" file not "txt".

---

    Code
      convert_tm_to_vs_theme("a.tmTheme")
    Condition
      Error in `convert_tm_to_vs_theme()`:
      ! File 'a.tmTheme' does not exists

# Theme creation

    Code
      cat(out, sep = "\n")
    Output
      {
        // Created with the R package rstudiothemes (c) dieghernan.
        // https://github.com/dieghernan/rstudiothemes
        "name": "Testing RStudioTheme",
        "author": "rstudiothemes",
        "semanticHighlighting": true,
        "type": "dark",
        "tokenColors": [
          {
            "settings": {
              "background": "#2B2836",
              "foreground": "#DCE7FD"
            }
          },
          {
            "name": "comment",
            "scope": "comment",
            "settings": {
              "foreground": "#655E7F"
            }
          },
          {
            "name": "doctype",
            "scope": ["meta.tag.metadata.doctype", "meta.tag.sgml.doctype.html", "meta.tag.sgml.html"],
            "settings": {
              "foreground": "#655E7F"
            }
          },
          {
            "name": "punctuation",
            "scope": ["punctuation.definition.tag", "punctuation.separator"],
            "settings": {
              "foreground": "#DCE7FD"
            }
          },
          {
            "name": "namespace,",
            "scope": ["entity.name.type.namespace", "storage.modifier.import"],
            "settings": {
              "foreground": "#6A6872"
            }
          },
          {
            "name": "string",
            "scope": "string",
            "settings": {
              "foreground": "#93B4FF"
            }
          },
          {
            "name": "attr-value",
            "scope": ["string.quoted.double.html", "string.quoted.single.html"],
            "settings": {
              "foreground": "#93B4FF"
            }
          },
          {
            "name": "property",
            "scope": ["meta.property-list", "support.type.property-name", "support.type.property-name.css", "support.type.vendored.property-name", "variable.other.property"],
            "settings": {
              "foreground": "#93B4FF"
            }
          },
          {
            "name": "constant",
            "scope": ["constant.language", "variable.other.constant.php"],
            "settings": {
              "foreground": "#93B4FF"
            }
          },
          {
            "name": "symbol",
            "scope": "constant.language.symbol",
            "settings": {
              "foreground": "#93B4FF"
            }
          },
          {
            "name": "attr-name",
            "scope": "entity.other.attribute-name.html",
            "settings": {
              "foreground": "#BD93F9"
            }
          },
          {
            "name": "boolean",
            "scope": "constant.language.boolean",
            "settings": {
              "foreground": "#FF8ADB"
            }
          },
          {
            "name": "number",
            "scope": "constant.numeric",
            "settings": {
              "foreground": "#FF8ADB"
            }
          },
          {
            "name": "operator",
            "scope": ["keyword.operator.arithmetic", "keyword.operator.assignment", "keyword.operator.class", "keyword.operator.comparison", "keyword.operator.logical", "keyword.operator.relational", "keyword.other", "punctuation.separator.dictionary.key-value"],
            "settings": {
              "foreground": "#F3E4A2"
            }
          },
          {
            "name": "tag",
            "scope": ["meta.document.yaml", "meta.tag", "storage.type.tag"],
            "settings": {
              "foreground": "#F3E4A2"
            }
          },
          {
            "name": "atrule",
            "scope": ["entity.name.tag.yaml", "keyword.control.at-rule", "meta.at-rule", "support.constant.media.css"],
            "settings": {
              "foreground": "#F3E4A2"
            }
          },
          {
            "name": "variable",
            "scope": "variable.other.object",
            "settings": {
              "foreground": "#DCE7FD"
            }
          },
          {
            "name": "selector",
            "scope": ["meta.selector", "source.css entity.name.tag", "source.css entity.other.attribute-name"],
            "settings": {
              "foreground": "#BD93F9"
            }
          },
          {
            "name": "function",
            "scope": ["entity.name.function", "support.function"],
            "settings": {
              "foreground": "#BD93F9"
            }
          },
          {
            "name": "keyword",
            "scope": ["constant.language.null", "constant.language.undefined", "keyword", "markup.inline.raw", "markup.raw", "storage"],
            "settings": {
              "foreground": "#BD93F9"
            }
          },
          {
            "name": "regex",
            "scope": "string.regexp",
            "settings": {
              "foreground": "#84FBA2"
            }
          },
          {
            "name": "unit",
            "scope": "keyword.other.unit",
            "settings": {
              "foreground": "#DCE7FD"
            }
          },
          {
            "name": "color",
            "scope": "constant.other.color",
            "settings": {
              "foreground": "#DCE7FD"
            }
          },
          {
            "name": "Skeletor JS keyword",
            "scope": ["source.js constant.language", "source.js constant.language.null", "source.js constant.language.undefined", "source.js keyword", "source.js storage"],
            "settings": {
              "foreground": "#F3E4A2"
            }
          },
          {
            "name": "Skeletor JS class-name",
            "scope": ["source.js entity.name.type.class", "source.js support.class"],
            "settings": {
              "foreground": "#93B4FF"
            }
          },
          {
            "name": "Skeletor CSS supports",
            "scope": "source.css support",
            "settings": {
              "foreground": "#DCE7FD"
            }
          },
          {
            "name": "Skeletor SCSS string",
            "scope": "source.css.scss string",
            "settings": {
              "foreground": "#DCE7FD"
            }
          },
          {
            "name": "Skeletor SCSS keyword",
            "scope": ["source.css.scss constant.language", "source.css.scss constant.language.null", "source.css.scss constant.language.undefined", "source.css.scss keyword", "source.css.scss storage"],
            "settings": {
              "foreground": "#F3E4A2"
            }
          },
          {
            "name": "Skeletor SCSS variable",
            "scope": ["source.css.scss variable", "source.css.scss variable.other.object"],
            "settings": {
              "foreground": "#84FBA2"
            }
          },
          {
            "name": "Skeletor PHP keyword",
            "scope": ["source.php constant.language.null", "source.php constant.language.undefined", "source.php keyword", "source.php storage", "source.php variable.language"],
            "settings": {
              "foreground": "#84FBA2"
            }
          },
          {
            "name": "Skeletor PHP constant",
            "scope": ["source.php constant.language", "source.php variable.other.constant.php"],
            "settings": {
              "foreground": "#FF8ADB"
            }
          },
          {
            "name": "Skeletor PHP delimiter",
            "scope": ["source.php punctuation.section.embedded", "text.html.php punctuation.section.embedded"],
            "settings": {
              "foreground": "#7B94A5"
            }
          },
          {
            "name": "Skeletor YAML string",
            "scope": ["source.yaml string", "text.yaml string"],
            "settings": {
              "foreground": "#DCE7FD"
            }
          },
          {
            "name": "Skeletor YAML scalar",
            "scope": ["source.yaml string.unquoted.block", "text.yaml string.unquoted.block"],
            "settings": {
              "foreground": "#93B4FF"
            }
          },
          {
            "name": "Skeletor YAML atrule",
            "scope": "text.yaml entity.name.tag.yaml",
            "settings": {
              "foreground": "#BD93F9"
            }
          },
          {
            "name": "Skeletor YAML important",
            "scope": ["text.yaml constant.numeric.yaml-version", "text.yaml entity.other.document", "text.yaml keyword.other.directive", "text.yaml keyword.other.important", "text.yaml markup.heading", "text.yaml meta.directives", "text.yaml punctuation.definition.alias", "text.yaml punctuation.definition.anchor", "text.yaml punctuation.section.embedded", "text.yaml variable.other.alias", "text.yaml variable.other.anchor"],
            "settings": {
              "foreground": "#84FBA2"
            }
          },
          {
            "name": "Skeletor Markdown reset",
            "scope": ["text.html.markdown markup.heading", "text.html.markdown punctuation.definition.heading"],
            "settings": {
              "foreground": "#DCE7FD"
            }
          },
          {
            "name": "Skeletor Markdown title",
            "scope": "markup.heading.markdown",
            "settings": {
              "foreground": "#BD93F9"
            }
          },
          {
            "name": "Skeletor Markdown code",
            "scope": ["text.html.markdown markup.inline.raw", "text.html.markdown markup.raw"],
            "settings": {
              "foreground": "#84FBA2"
            }
          },
          {
            "name": "Skeletor Markdown list.punctuation",
            "scope": "text.html.markdown punctuation.definition.list",
            "settings": {
              "foreground": "#93B4FF"
            }
          },
          {
            "name": "url",
            "scope": "markup.underline.link",
            "settings": {
              "foreground": "#93B4FF"
            }
          },
          {
            "name": "Skeletor Markdown url variable",
            "scope": "text.html.markdown constant.other.reference.link",
            "settings": {
              "foreground": "#F3E4A2"
            }
          },
          {
            "name": "invalid - not mapped",
            "scope": "invalid",
            "settings": {
              "foreground": "#F36A66"
            }
          }
        ],
        "colors": {
          "activityBar.activeBackground": "#483D5D",
          "activityBar.background": "#2E2A3A",
          "activityBar.foreground": "#BD93F9",
          "activityBar.inactiveForeground": "#655E7F",
          "activityBarBadge.background": "#BD93F9",
          "activityBarBadge.foreground": "#2B2836",
          "badge.background": "#BD93F9",
          "badge.foreground": "#2B2836",
          "breadcrumb.activeSelectionForeground": "#DCE7FD",
          "breadcrumb.background": "#3D3B4A",
          "breadcrumb.focusForeground": "#DCE7FD",
          "breadcrumb.foreground": "#655E7F",
          "button.background": "#BD93F9",
          "button.foreground": "#2B2836",
          "button.secondaryBackground": "#2E2A3A",
          "button.secondaryForeground": "#DCE7FD",
          "dropdown.background": "#3D3B4A",
          "dropdown.foreground": "#DCE7FD",
          "editor.background": "#2B2836",
          "editor.foreground": "#DCE7FD",
          "editor.lineHighlightBackground": "#55535E",
          "editor.lineHighlightBorder": "#55535E",
          "editor.selectionBackground": "#55535E",
          "editor.snippetFinalTabstopHighlightBackground": "#2B2836",
          "editor.snippetTabstopHighlightBackground": "#2B2836",
          "editor.snippetTabstopHighlightBorder": "#655E7F",
          "editorBracketHighlight.foreground1": "#DCE7FD",
          "editorCodeLens.foreground": "#655E7F",
          "editorCursor.foreground": "#BD93F9",
          "editorGroupHeader.tabsBackground": "#2E2A3A",
          "editorHoverWidget.background": "#2E2A3A",
          "editorHoverWidget.border": "#655E7F",
          "editorLineNumber.foreground": "#655E7F",
          "editorLink.activeForeground": "#BD93F9",
          "editorRuler.foreground": "#363340",
          "editorSuggestWidget.background": "#2E2A3A",
          "editorSuggestWidget.focusHighlightForeground": "#BD93F9",
          "editorSuggestWidget.foreground": "#DCE7FD",
          "editorSuggestWidget.highlightForeground": "#BD93F9",
          "editorSuggestWidget.selectedBackground": "#2E2A3A",
          "editorSuggestWidget.selectedIconForeground": "#BD93F9",
          "editorWhitespace.foreground": "#363340",
          "editorWidget.background": "#2E2A3A",
          "focusBorder": "#BD93F9",
          "foreground": "#DCE7FD",
          "gitDecoration.ignoredResourceForeground": "#655E7F",
          "icon.foreground": "#BD93F9",
          "input.background": "#3D3B4A",
          "input.foreground": "#DCE7FD",
          "input.placeholderForeground": "#655E7F",
          "keybindingLabel.background": "#2B2836",
          "keybindingLabel.foreground": "#DCE7FD",
          "list.activeSelectionBackground": "#55535E",
          "list.activeSelectionForeground": "#DCE7FD",
          "list.dropBackground": "#55535E",
          "list.focusBackground": "#55535E",
          "list.highlightForeground": "#BD93F9",
          "list.hoverBackground": "#55535E",
          "list.inactiveSelectionBackground": "#606172",
          "menu.background": "#2E2A3A",
          "menu.foreground": "#DCE7FD",
          "menu.selectionBackground": "#55535E",
          "menu.separatorBackground": "#483D5D",
          "menubar.selectionBackground": "#55535E",
          "notificationLink.foreground": "#BD93F9",
          "notifications.background": "#2E2A3A",
          "panel.background": "#3D3B4A",
          "panelTitle.activeForeground": "#DCE7FD",
          "panelTitle.inactiveForeground": "#655E7F",
          "peekView.border": "#55535E",
          "peekViewEditor.background": "#2B2836",
          "peekViewResult.fileForeground": "#DCE7FD",
          "peekViewResult.lineForeground": "#DCE7FD",
          "peekViewResult.selectionBackground": "#55535E",
          "peekViewResult.selectionForeground": "#DCE7FD",
          "peekViewTitleDescription.foreground": "#655E7F",
          "peekViewTitleLabel.foreground": "#DCE7FD",
          "pickerGroup.border": "#2E2A3A",
          "pickerGroup.foreground": "#BD93F9",
          "progressBar.background": "#BD93F9",
          "scrollbarSlider.activeBackground": "#606172",
          "scrollbarSlider.background": "#483D5D",
          "settings.checkboxForeground": "#DCE7FD",
          "settings.dropdownForeground": "#DCE7FD",
          "settings.headerForeground": "#DCE7FD",
          "settings.numberInputForeground": "#DCE7FD",
          "settings.textInputForeground": "#DCE7FD",
          "sideBar.background": "#3D3B4A",
          "sideBar.foreground": "#DCE7FD",
          "sideBarSectionHeader.background": "#2B2836",
          "sideBarTitle.background": "#2E2A3A",
          "sideBarTitle.foreground": "#DCE7FD",
          "statusBar.background": "#483D5D",
          "statusBar.foreground": "#DCE7FD",
          "statusBar.noFolderBackground": "#55535E",
          "statusBar.noFolderForeground": "#DCE7FD",
          "statusBarItem.remoteForeground": "#2B2836",
          "tab.activeBackground": "#483D5D",
          "tab.activeForeground": "#BD93F9",
          "tab.inactiveBackground": "#3D3B4A",
          "tab.inactiveForeground": "#DCE7FD",
          "terminal.background": "#2B2836",
          "terminal.border": "#483D5D",
          "terminal.cursor": "#BD93F9",
          "terminal.foreground": "#DCE7FD",
          "terminalCursor.background": "#2B2836",
          "terminalCursor.foreground": "#BD93F9",
          "textLink.foreground": "#BD93F9",
          "titleBar.activeBackground": "#2E2A3A",
          "titleBar.activeForeground": "#DCE7FD",
          "titleBar.inactiveForeground": "#655E7F"
        }
      }

# Simple Theme creation

    Code
      cat(out, sep = "\n")
    Output
      {
        // Created with the R package rstudiothemes (c) dieghernan.
        // https://github.com/dieghernan/rstudiothemes
        "name": "Empty theme",
        "author": "dieghernan",
        "semanticHighlighting": true,
        "type": "dark",
        "colors": {
          "activityBar.activeBackground": "#51524B",
          "activityBar.background": "#2B2C26",
          "activityBar.foreground": "#F8F8F0",
          "activityBarBadge.background": "#F8F8F0",
          "activityBarBadge.foreground": "#272822",
          "badge.background": "#F8F8F0",
          "badge.foreground": "#272822",
          "breadcrumb.activeSelectionForeground": "#F8F8F2",
          "breadcrumb.background": "#3C3D37",
          "breadcrumb.focusForeground": "#F8F8F2",
          "button.background": "#F8F8F0",
          "button.foreground": "#272822",
          "button.secondaryBackground": "#2B2C26",
          "button.secondaryForeground": "#F8F8F2",
          "dropdown.background": "#3C3D37",
          "dropdown.foreground": "#F8F8F2",
          "editor.background": "#272822",
          "editor.foreground": "#F8F8F2",
          "editor.lineHighlightBackground": "#3E3D32",
          "editor.lineHighlightBorder": "#49483E",
          "editor.selectionBackground": "#49483E",
          "editor.snippetFinalTabstopHighlightBackground": "#272822",
          "editor.snippetTabstopHighlightBackground": "#272822",
          "editorBracketHighlight.foreground1": "#F8F8F2",
          "editorCursor.foreground": "#F8F8F0",
          "editorGroupHeader.tabsBackground": "#2B2C26",
          "editorHoverWidget.background": "#2B2C26",
          "editorLink.activeForeground": "#F8F8F0",
          "editorRuler.foreground": "#3B3A32",
          "editorSuggestWidget.background": "#2B2C26",
          "editorSuggestWidget.focusHighlightForeground": "#F8F8F0",
          "editorSuggestWidget.foreground": "#F8F8F2",
          "editorSuggestWidget.highlightForeground": "#F8F8F0",
          "editorSuggestWidget.selectedBackground": "#2B2C26",
          "editorSuggestWidget.selectedIconForeground": "#F8F8F0",
          "editorWhitespace.foreground": "#3B3A32",
          "editorWidget.background": "#2B2C26",
          "focusBorder": "#F8F8F0",
          "foreground": "#F8F8F2",
          "icon.foreground": "#F8F8F0",
          "input.background": "#3C3D37",
          "input.foreground": "#F8F8F2",
          "keybindingLabel.background": "#272822",
          "keybindingLabel.foreground": "#F8F8F2",
          "list.activeSelectionBackground": "#49483E",
          "list.activeSelectionForeground": "#F8F8F2",
          "list.dropBackground": "#49483E",
          "list.focusBackground": "#49483E",
          "list.highlightForeground": "#F8F8F0",
          "list.hoverBackground": "#49483E",
          "list.inactiveSelectionBackground": "#666660",
          "menu.background": "#2B2C26",
          "menu.foreground": "#F8F8F2",
          "menu.selectionBackground": "#49483E",
          "menu.separatorBackground": "#51524B",
          "menubar.selectionBackground": "#49483E",
          "notificationLink.foreground": "#F8F8F0",
          "notifications.background": "#2B2C26",
          "panel.background": "#3C3D37",
          "panelTitle.activeForeground": "#F8F8F2",
          "peekView.border": "#49483E",
          "peekViewEditor.background": "#272822",
          "peekViewResult.fileForeground": "#F8F8F2",
          "peekViewResult.lineForeground": "#F8F8F2",
          "peekViewResult.selectionBackground": "#49483E",
          "peekViewResult.selectionForeground": "#F8F8F2",
          "peekViewTitleLabel.foreground": "#F8F8F2",
          "pickerGroup.border": "#2B2C26",
          "pickerGroup.foreground": "#F8F8F0",
          "progressBar.background": "#F8F8F0",
          "scrollbarSlider.activeBackground": "#666660",
          "scrollbarSlider.background": "#51524B",
          "settings.checkboxForeground": "#F8F8F2",
          "settings.dropdownForeground": "#F8F8F2",
          "settings.headerForeground": "#F8F8F2",
          "settings.numberInputForeground": "#F8F8F2",
          "settings.textInputForeground": "#F8F8F2",
          "sideBar.background": "#3C3D37",
          "sideBar.foreground": "#F8F8F2",
          "sideBarSectionHeader.background": "#272822",
          "sideBarTitle.background": "#2B2C26",
          "sideBarTitle.foreground": "#F8F8F2",
          "statusBar.background": "#51524B",
          "statusBar.foreground": "#F8F8F2",
          "statusBar.noFolderBackground": "#49483E",
          "statusBar.noFolderForeground": "#F8F8F2",
          "statusBarItem.remoteForeground": "#272822",
          "tab.activeBackground": "#51524B",
          "tab.activeForeground": "#F8F8F0",
          "tab.inactiveBackground": "#3C3D37",
          "tab.inactiveForeground": "#F8F8F2",
          "terminal.background": "#272822",
          "terminal.border": "#51524B",
          "terminal.cursor": "#F8F8F0",
          "terminal.foreground": "#F8F8F2",
          "terminalCursor.background": "#272822",
          "terminalCursor.foreground": "#F8F8F0",
          "textLink.foreground": "#F8F8F0",
          "titleBar.activeBackground": "#2B2C26",
          "titleBar.activeForeground": "#F8F8F2"
        }
      }

---

    Code
      cat(out, sep = "\n")
    Output
      {
        // Created with the R package rstudiothemes (c) dieghernan.
        // https://github.com/dieghernan/rstudiothemes
        "name": "A test theme",
        "author": "I am",
        "semanticHighlighting": true,
        "type": "dark",
        "colors": {
          "activityBar.activeBackground": "#51524B",
          "activityBar.background": "#2B2C26",
          "activityBar.foreground": "#F8F8F0",
          "activityBarBadge.background": "#F8F8F0",
          "activityBarBadge.foreground": "#272822",
          "badge.background": "#F8F8F0",
          "badge.foreground": "#272822",
          "breadcrumb.activeSelectionForeground": "#F8F8F2",
          "breadcrumb.background": "#3C3D37",
          "breadcrumb.focusForeground": "#F8F8F2",
          "button.background": "#F8F8F0",
          "button.foreground": "#272822",
          "button.secondaryBackground": "#2B2C26",
          "button.secondaryForeground": "#F8F8F2",
          "dropdown.background": "#3C3D37",
          "dropdown.foreground": "#F8F8F2",
          "editor.background": "#272822",
          "editor.foreground": "#F8F8F2",
          "editor.lineHighlightBackground": "#3E3D32",
          "editor.lineHighlightBorder": "#49483E",
          "editor.selectionBackground": "#49483E",
          "editor.snippetFinalTabstopHighlightBackground": "#272822",
          "editor.snippetTabstopHighlightBackground": "#272822",
          "editorBracketHighlight.foreground1": "#F8F8F2",
          "editorCursor.foreground": "#F8F8F0",
          "editorGroupHeader.tabsBackground": "#2B2C26",
          "editorHoverWidget.background": "#2B2C26",
          "editorLink.activeForeground": "#F8F8F0",
          "editorRuler.foreground": "#3B3A32",
          "editorSuggestWidget.background": "#2B2C26",
          "editorSuggestWidget.focusHighlightForeground": "#F8F8F0",
          "editorSuggestWidget.foreground": "#F8F8F2",
          "editorSuggestWidget.highlightForeground": "#F8F8F0",
          "editorSuggestWidget.selectedBackground": "#2B2C26",
          "editorSuggestWidget.selectedIconForeground": "#F8F8F0",
          "editorWhitespace.foreground": "#3B3A32",
          "editorWidget.background": "#2B2C26",
          "focusBorder": "#F8F8F0",
          "foreground": "#F8F8F2",
          "icon.foreground": "#F8F8F0",
          "input.background": "#3C3D37",
          "input.foreground": "#F8F8F2",
          "keybindingLabel.background": "#272822",
          "keybindingLabel.foreground": "#F8F8F2",
          "list.activeSelectionBackground": "#49483E",
          "list.activeSelectionForeground": "#F8F8F2",
          "list.dropBackground": "#49483E",
          "list.focusBackground": "#49483E",
          "list.highlightForeground": "#F8F8F0",
          "list.hoverBackground": "#49483E",
          "list.inactiveSelectionBackground": "#666660",
          "menu.background": "#2B2C26",
          "menu.foreground": "#F8F8F2",
          "menu.selectionBackground": "#49483E",
          "menu.separatorBackground": "#51524B",
          "menubar.selectionBackground": "#49483E",
          "notificationLink.foreground": "#F8F8F0",
          "notifications.background": "#2B2C26",
          "panel.background": "#3C3D37",
          "panelTitle.activeForeground": "#F8F8F2",
          "peekView.border": "#49483E",
          "peekViewEditor.background": "#272822",
          "peekViewResult.fileForeground": "#F8F8F2",
          "peekViewResult.lineForeground": "#F8F8F2",
          "peekViewResult.selectionBackground": "#49483E",
          "peekViewResult.selectionForeground": "#F8F8F2",
          "peekViewTitleLabel.foreground": "#F8F8F2",
          "pickerGroup.border": "#2B2C26",
          "pickerGroup.foreground": "#F8F8F0",
          "progressBar.background": "#F8F8F0",
          "scrollbarSlider.activeBackground": "#666660",
          "scrollbarSlider.background": "#51524B",
          "settings.checkboxForeground": "#F8F8F2",
          "settings.dropdownForeground": "#F8F8F2",
          "settings.headerForeground": "#F8F8F2",
          "settings.numberInputForeground": "#F8F8F2",
          "settings.textInputForeground": "#F8F8F2",
          "sideBar.background": "#3C3D37",
          "sideBar.foreground": "#F8F8F2",
          "sideBarSectionHeader.background": "#272822",
          "sideBarTitle.background": "#2B2C26",
          "sideBarTitle.foreground": "#F8F8F2",
          "statusBar.background": "#51524B",
          "statusBar.foreground": "#F8F8F2",
          "statusBar.noFolderBackground": "#49483E",
          "statusBar.noFolderForeground": "#F8F8F2",
          "statusBarItem.remoteForeground": "#272822",
          "tab.activeBackground": "#51524B",
          "tab.activeForeground": "#F8F8F0",
          "tab.inactiveBackground": "#3C3D37",
          "tab.inactiveForeground": "#F8F8F2",
          "terminal.background": "#272822",
          "terminal.border": "#51524B",
          "terminal.cursor": "#F8F8F0",
          "terminal.foreground": "#F8F8F2",
          "terminalCursor.background": "#272822",
          "terminalCursor.foreground": "#F8F8F0",
          "textLink.foreground": "#F8F8F0",
          "titleBar.activeBackground": "#2B2C26",
          "titleBar.activeForeground": "#F8F8F2"
        }
      }

