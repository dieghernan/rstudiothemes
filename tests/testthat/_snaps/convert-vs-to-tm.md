# Errors

    Code
      convert_vs_to_tm_theme()
    Condition
      Error in `read_vs_theme()`:
      ! Argument `path` can't be empty.

---

    Code
      convert_vs_to_tm_theme("a.txt")
    Condition
      Error in `read_vs_theme()`:
      ! Argument `path` should be a "json" file not "txt".

---

    Code
      convert_vs_to_tm_theme("a.json")
    Condition
      Error in `read_vs_theme()`:
      ! File 'a.json' does not exists.

# Theme creation

    Code
      cat(out[seq(1, 500)], sep = "\n")
    Output
      <?xml version="1.0" encoding="UTF-8"?>
      <plist version="1.0">
        <dict>
          <key>name</key>
          <string>Tokyo Night</string>
          <key>author</key>
          <string>Enkia, rstudiothemes R package</string>
          <key>colorSpaceName</key>
          <string>sRGB</string>
          <key>semanticClass</key>
          <string>theme.dark.tokyo_night</string>
          <key>comment</key>
          <string>Generated with rstudiothemes R package</string>
          <key>uuid</key>
      <string>(masked_uuid)</string>
          <key>settings</key>
          <array>
            <dict>
              <key>settings</key>
              <dict>
                <key>background</key>
                <string>#1A1B26</string>
                <key>foreground</key>
                <string>#A9B1D6</string>
                <key>selection</key>
                <string>#515C7E4D</string>
                <key>inactiveSelection</key>
                <string>#515C7E25</string>
                <key>selectionHighlightColor</key>
                <string>#515C7E44</string>
                <key>wordHighlight</key>
                <string>#515C7E44</string>
                <key>wordHighlightStrong</key>
                <string>#515C7E55</string>
                <key>findMatchHighlight</key>
                <string>#3D59A166</string>
                <key>currentFindMatchHighlight</key>
                <string>#3D59A166</string>
                <key>findRangeHighlight</key>
                <string>#515C7E33</string>
                <key>referenceHighlight</key>
                <string>#3D59A166</string>
                <key>lineHighlight</key>
                <string>#1E202E</string>
                <key>rangeHighlight</key>
                <string>#515C7E20</string>
                <key>caret</key>
                <string>#C0CAF5</string>
                <key>invisibles</key>
                <string>#363B54</string>
                <key>ansiBlack</key>
                <string>#363B54</string>
                <key>ansiRed</key>
                <string>#F7768E</string>
                <key>ansiGreen</key>
                <string>#73DACA</string>
                <key>ansiYellow</key>
                <string>#E0AF68</string>
                <key>ansiBlue</key>
                <string>#7AA2F7</string>
                <key>ansiMagenta</key>
                <string>#BB9AF7</string>
                <key>ansiCyan</key>
                <string>#7DCFFF</string>
                <key>ansiWhite</key>
                <string>#787C99</string>
                <key>ansiBrightBlack</key>
                <string>#363B54</string>
                <key>ansiBrightRed</key>
                <string>#F7768E</string>
                <key>ansiBrightGreen</key>
                <string>#73DACA</string>
                <key>ansiBrightYellow</key>
                <string>#E0AF68</string>
                <key>ansiBrightBlue</key>
                <string>#7AA2F7</string>
                <key>ansiBrightMagenta</key>
                <string>#BB9AF7</string>
                <key>ansiBrightCyan</key>
                <string>#7DCFFF</string>
                <key>ansiBrightWhite</key>
                <string>#ACB0D0</string>
                <key>gutterForeground</key>
                <string>#363B54</string>
                <key>invalid</key>
                <string>#515670</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Semantic: parameter.declaration</string>
              <key>scope</key>
              <string>parameter.declaration</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#E0AF68</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Semantic: parameter</string>
              <key>scope</key>
              <string>parameter</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#D9D4CD</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Semantic: cobalt.variable</string>
              <key>scope</key>
              <string>cobalt.variable</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#FFFFFF</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Semantic: property.declaration</string>
              <key>scope</key>
              <string>property.declaration</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#73DACA</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Semantic: cobalt.type</string>
              <key>scope</key>
              <string>cobalt.type</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#FF68B8</string>
                <key>fontStyle</key>
                <string>italic</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Semantic: property.defaultLibrary</string>
              <key>scope</key>
              <string>property.defaultLibrary</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#2AC3DE</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Semantic: variable.defaultLibrary</string>
              <key>scope</key>
              <string>variable.defaultLibrary</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#2AC3DE</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Semantic: variable.declaration</string>
              <key>scope</key>
              <string>variable.declaration</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#BB9AF7</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Semantic: variable</string>
              <key>scope</key>
              <string>variable</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#C0CAF5</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Italics - Comments, Storage, Keyword Flow, Vue attributes, Decorators</string>
              <key>scope</key>
              <string>comment, string.quoted.docstring.multi, string.quoted.docstring.multi.python constant.character.escape, string.quoted.docstring.multi.python punctuation.definition.string.begin, string.quoted.docstring.multi.python punctuation.definition.string.end</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#51597D</string>
                <key>fontStyle</key>
                <string>italic</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Italics - Comments, Storage, Keyword Flow, Vue attributes, Decorators</string>
              <key>scope</key>
              <string>keyword.control.flow, keyword.control.return</string>
              <key>settings</key>
              <dict>
                <key>fontStyle</key>
                <string>italic</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Italics - Comments, Storage, Keyword Flow, Vue attributes, Decorators</string>
              <key>scope</key>
              <string>meta.directive.vue entity.other.attribute-name.html</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#BB9AF7</string>
                <key>fontStyle</key>
                <string>italic</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Italics - Comments, Storage, Keyword Flow, Vue attributes, Decorators</string>
              <key>scope</key>
              <string>meta.directive.vue punctuation.separator.key-value.html</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#89DDFF</string>
                <key>fontStyle</key>
                <string>italic</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Italics - Comments, Storage, Keyword Flow, Vue attributes, Decorators</string>
              <key>scope</key>
              <string>meta.var.expr storage.type, storage.modifier</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#9D7CD8</string>
                <key>fontStyle</key>
                <string>italic</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Italics - Comments, Storage, Keyword Flow, Vue attributes, Decorators</string>
              <key>scope</key>
              <string>tag.decorator.js entity.name.tag.js, tag.decorator.js punctuation.definition.tag.js</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#7AA2F7</string>
                <key>fontStyle</key>
                <string>italic</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Comment</string>
              <key>scope</key>
              <string>comment.block.documentation, comment.block.documentation punctuation, punctuation.definition.comment</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#51597D</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Comment Doc</string>
              <key>scope</key>
              <string>comment.block.documentation keyword, comment.block.documentation markup, comment.block.documentation markup.inline.raw.string.markdown, comment.block.documentation storage, comment.block.documentation support, comment.block.documentation variable, keyword.operator.assignment.jsdoc, keyword.other.phpdoc.php, log.date, meta.other.type.phpdoc.php keyword.other.type.php, meta.other.type.phpdoc.php punctuation.separator.inheritance.php, meta.other.type.phpdoc.php support.class, meta.other.type.phpdoc.php support.other.namespace.php</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#5A638C</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Comment Doc Emphasized</string>
              <key>scope</key>
              <string>comment.block.documentation entity.name.type.instance, comment.block.documentation punctuation.definition.block.tag, comment.block.documentation storage.type</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#646E9C</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Number, Boolean, Undefined, Null</string>
              <key>scope</key>
              <string>constant.language, constant.numeric, constant.other.caps, punctuation.definition.constant, support.constant, variable.other.constant</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#FF9E64</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>String, Symbols</string>
              <key>scope</key>
              <string>constant.other.key, constant.other.symbol, meta.attribute-selector, string, string constant.character</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#9ECE6A</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Colors</string>
              <key>scope</key>
              <string>constant.other.color, constant.other.color.rgb-value.hex punctuation.definition.constant</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#9AA5CE</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Invalid</string>
              <key>scope</key>
              <string>invalid, invalid.illegal</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#FF5370</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Invalid deprecated</string>
              <key>scope</key>
              <string>invalid.deprecated</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#BB9AF7</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Storage Type</string>
              <key>scope</key>
              <string>storage.type</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#BB9AF7</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Interpolation, PHP tags, Smarty tags</string>
              <key>scope</key>
              <string>meta.embedded.line.tag.smarty, punctuation.definition.template-expression, punctuation.section.embedded, punctuation.section.tag.twig, support.constant.handlebars</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#7DCFFF</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Blade, Twig, Smarty Handlebars keywords</string>
              <key>scope</key>
              <string>entity.name.function.blade, keyword.blade, keyword.control.smarty, keyword.control.twig, keyword.operator.comparison.twig, meta.tag.blade keyword.other.type.php, support.constant.handlebars keyword.control</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#0DB9D7</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Spread</string>
              <key>scope</key>
              <string>keyword.operator.rest, keyword.operator.spread</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#F7768E</string>
                <key>fontStyle</key>
                <string>bold</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Operator, Misc</string>
              <key>scope</key>
              <string>entity.name.operator, expression.embbeded.vue punctuation.definition.tag, keyword.control.as, keyword.operator, keyword.operator.bitwise.shift, keyword.other, keyword.other.substitution, keyword.other.template, meta.at-rule.function variable.parameter.url, meta.at-rule.mixin punctuation.separator.key-value, meta.attribute.directive, meta.embedded.inline.phpx punctuation.definition.tag.begin.html, meta.embedded.inline.phpx punctuation.definition.tag.end.html, meta.property-list punctuation.separator.key-value, meta.tag.template.value.twig meta.function.arguments.twig, punctuation, punctuation.definition.constant.markdown, punctuation.definition.entity, punctuation.definition.keyword, punctuation.definition.string, punctuation.separator.inheritance.php, punctuation.support.type.property-name, punctuation.terminator.rule, text.html.twig meta.tag.inline.any.html, text.html.vue-html meta.tag</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#89DDFF</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Import, Export, From, Default</string>
              <key>scope</key>
              <string>keyword.control.default, keyword.control.export, keyword.control.from, keyword.control.import, keyword.control.module.js, meta.import keyword.other</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#7DCFFF</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Keyword</string>
              <key>scope</key>
              <string>keyword, keyword.control, keyword.other.important</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#BB9AF7</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Keyword SQL</string>
              <key>scope</key>
              <string>keyword.other.DML</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#7DCFFF</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Keyword Operator Logical, Arrow, Ternary, Comparison</string>
              <key>scope</key>
              <string>keyword.operator.bitwise, keyword.operator.comparison, keyword.operator.logical, keyword.operator.or.regexp, keyword.operator.relational, keyword.operator.ternary, storage.type.function</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#BB9AF7</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Tag</string>
              <key>scope</key>
              <string>entity.name.tag</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#F7768E</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Tag - Custom / Unrecognized</string>
              <key>scope</key>
              <string>entity.name.tag support.class.component, meta.tag, meta.tag.custom entity.name.tag, meta.tag.other.unrecognized.html.derivative entity.name.tag</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#DE5971</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Tag Punctuation</string>
              <key>scope</key>
              <string>punctuation.definition.tag, text.html.php meta.embedded.block.html meta.tag.metadata.script.end.html punctuation.definition.tag.begin.html text.html.basic</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#BA3C97</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>
              <string>Globals, PHP Constants, etc</string>
              <key>scope</key>
              <string>constant.other, constant.other.php, variable.other.global, variable.other.global punctuation.definition.variable, variable.other.global.safer, variable.other.global.safer punctuation.definition.variable</string>
              <key>settings</key>
              <dict>
                <key>foreground</key>
                <string>#E0AF68</string>
              </dict>
            </dict>
            <dict>
              <key>name</key>

# Simple Theme creation

    Code
      cat(out[seq(1, 15)], sep = "\n")
    Output
      <?xml version="1.0" encoding="UTF-8"?>
      <plist version="1.0">
        <dict>
          <key>name</key>
          <string>Skeletor Syntax</string>
          <key>author</key>
          <string>rstudiothemes R package</string>
          <key>colorSpaceName</key>
          <string>sRGB</string>
          <key>semanticClass</key>
          <string>theme.dark.skeletor_syntax</string>
          <key>comment</key>
          <string>Generated with rstudiothemes R package</string>
          <key>uuid</key>
      <string>(masked_uuid)</string>

---

    Code
      cat(out[seq(1, 15)], sep = "\n")
    Output
      <?xml version="1.0" encoding="UTF-8"?>
      <plist version="1.0">
        <dict>
          <key>name</key>
          <string>A test theme</string>
          <key>author</key>
          <string>I am</string>
          <key>colorSpaceName</key>
          <string>sRGB</string>
          <key>semanticClass</key>
          <string>theme.dark.a_test_theme</string>
          <key>comment</key>
          <string>Generated with rstudiothemes R package</string>
          <key>uuid</key>
      <string>(masked_uuid)</string>

# Online

    Code
      thef <- convert_vs_to_tm_theme(path)
    Message
      i Downloading from <https://raw.githubusercontent.com/dieghernan/rstudiothemes/refs/heads/main/inst/ext/test-color-theme.json>

