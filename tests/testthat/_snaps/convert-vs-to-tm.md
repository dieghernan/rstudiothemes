# conversion rejects invalid paths and missing required colors

    Code
      convert_vs_to_tm_theme()
    Condition
      Error in `read_vs_theme()`:
      ! The `path` argument is required.

---

    Code
      convert_vs_to_tm_theme("a.txt")
    Condition
      Error in `read_vs_theme()`:
      ! The `path` argument must be a '.json' file, not "txt".

---

    Code
      convert_vs_to_tm_theme("a.json")
    Condition
      Error in `local_theme_file()`:
      ! File 'a.json' was not found.

---

    Code
      convert_vs_to_tm_theme(tmp_path)
    Condition
      Error in `tmtheme_settings_df()`:
      ! Cannot convert theme because required colors are missing.
      x Missing 1 setting: background.
      i Ensure the input theme provides the required colors or pass overrides.

# simple themes receive default TextMate metadata

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

# explicit metadata overrides Visual Studio Code values

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

# URL Visual Studio Code inputs are downloaded and converted

    Code
      thef <- convert_vs_to_tm_theme(path)
    Message
      i Downloading theme from <https://raw.githubusercontent.com/dieghernan/rstudiothemes/refs/heads/main/inst/ext/test-color-theme.json>.
    Code
      invisible(thef)

# unnamed themes require an explicit name

    Code
      convert_vs_to_tm_theme(fpath)
    Condition
      Error in `convert_vs_to_tm_theme()`:
      ! Theme name not found. Use the `name` argument.

