# conversion rejects invalid TextMate input paths

    Code
      convert_tm_to_vs_theme()
    Condition
      Error in `read_tm_theme()`:
      ! The `path` argument is required.

---

    Code
      convert_tm_to_vs_theme("a.txt")
    Condition
      Error in `read_tm_theme()`:
      ! The `path` argument must be a '.tmTheme' file, not "txt".

---

    Code
      convert_tm_to_vs_theme("a.tmTheme")
    Condition
      Error in `local_theme_file()`:
      ! File 'a.tmTheme' was not found.

# conversion rejects TextMate themes missing required settings

    Code
      convert_tm_to_vs_theme(fpath)
    Condition
      Error in `read_tm_theme()`:
      ! TextMate theme in '<test-error.tmTheme>' is invalid.
      x Required settings lineHighlight and selection are missing.

# URL TextMate inputs are downloaded and converted

    Code
      res <- convert_tm_to_vs_theme(path)
    Message
      i Downloading theme from <https://raw.githubusercontent.com/dieghernan/rstudiothemes/refs/heads/main/inst/ext/test.tmTheme>.
    Code
      invisible(res)

# dark high-contrast metadata produces hc-black output

    Code
      thef <- convert_tm_to_vs_theme(tmtheme, outfile = tmout)
    Message
      ! The TextMate theme "Overflow Dark High Contrast" does not list an author. Use the `author` argument.
      i Using default `author = "rstudiothemes R package"`.

# light high-contrast metadata produces hc-light output

    Code
      thef <- convert_tm_to_vs_theme(tmtheme, outfile = tmout)

