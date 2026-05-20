# Errors

    Code
      read_tm_theme()
    Condition
      Error in `read_tm_theme()`:
      ! Argument `path` cannot be empty.

---

    Code
      read_tm_theme("a.txt")
    Condition
      Error in `read_tm_theme()`:
      ! Argument `path` should be a "tmTheme" file, not "txt".

---

    Code
      read_tm_theme("a.json")
    Condition
      Error in `read_tm_theme()`:
      ! Argument `path` should be a "tmTheme" file, not "json".

# Test simple theme

    Code
      fpath <- convert_vs_to_tm_theme(vstheme)
    Message
      ! Visual Studio Code theme "Skeletor Syntax" does not have an author. Use the `author` argument.
      i Using `author = "rstudiothemes R package"`.

# Test minimal theme

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

# Online

    Code
      res <- read_tm_theme(path)
    Message
      i Downloading from <https://raw.githubusercontent.com/dieghernan/rstudiothemes/refs/heads/main/inst/ext/test.tmTheme>.

