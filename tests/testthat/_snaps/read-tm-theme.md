# read_tm_theme() reports invalid inputs

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

# read_tm_theme() parses converted simple TextMate themes

    Code
      invisible(convert_vs_to_tm_theme(vstheme, outfile = fpath))
    Message
      ! The Visual Studio Code theme "Skeletor Syntax" does not list an author. Use the `author` argument.
      i Using default `author = "rstudiothemes R package"`.

# read_tm_theme() parses minimal TextMate themes

    Code
      unique(res$section)
    Output
      [1] "highlevel" "colors"   

---

    Code
      res$name
    Output
       [1] "name"           "uuid"           "colorSpaceName" "semanticClass" 
       [5] "author"         "comment"        "background"     "caret"         
       [9] "foreground"     "invisibles"     "lineHighlight"  "selection"     

# read_tm_theme() reports invalid TextMate fixtures

    Code
      read_tm_theme(fpath)
    Condition
      Error in `read_tm_theme()`:
      ! TextMate theme in '<test-error.tmTheme>' is invalid.
      x Required settings "lineHighlight" and "selection" are missing.

# read_tm_theme() downloads URL inputs

    Code
      res <- read_tm_theme(path)
    Message
      i Downloading theme from <https://raw.githubusercontent.com/dieghernan/rstudiothemes/refs/heads/main/inst/ext/test.tmTheme>.
    Code
      invisible(res)

