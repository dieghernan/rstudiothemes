# reader rejects missing paths, wrong extensions and missing files

    Code
      read_tm_theme()
    Condition
      Error in `read_tm_theme()`:
      ! The `path` argument is required.

---

    Code
      read_tm_theme("a.txt")
    Condition
      Error in `read_tm_theme()`:
      ! The `path` argument must be a '.tmTheme' file, not "txt".

---

    Code
      read_tm_theme("a.json")
    Condition
      Error in `read_tm_theme()`:
      ! The `path` argument must be a '.tmTheme' file, not "json".

# converted simple themes receive generated metadata

    Code
      invisible(convert_vs_to_tm_theme(vstheme, outfile = fpath))
    Message
      ! The Visual Studio Code theme "Skeletor Syntax" does not list an author. Use the `author` argument.
      i Using default `author = "rstudiothemes R package"`.

# reader rejects themes missing required settings

    Code
      read_tm_theme(fpath)
    Condition
      Error in `read_tm_theme()`:
      ! TextMate theme in '<test-error.tmTheme>' is invalid.
      x Required settings lineHighlight and selection are missing.

# URL themes are downloaded before parsing

    Code
      res <- read_tm_theme(path)
    Message
      i Downloading theme from <https://raw.githubusercontent.com/dieghernan/rstudiothemes/refs/heads/main/inst/ext/test.tmTheme>.
    Code
      invisible(res)

