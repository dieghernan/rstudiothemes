# Errors

    Code
      read_vs_theme()
    Condition
      Error in `read_vs_theme()`:
      ! Argument `path` can't be empty.

---

    Code
      read_vs_theme("a.txt")
    Condition
      Error in `read_vs_theme()`:
      ! Argument `path` should be a "json" file not "txt".

---

    Code
      read_vs_theme("a.json")
    Condition
      Error in `read_vs_theme()`:
      ! File 'a.json' does not exists.

# Online

    Code
      res <- read_vs_theme(path)
    Message
      i Downloading from <https://raw.githubusercontent.com/dieghernan/rstudiothemes/refs/heads/main/inst/ext/test-color-theme.json>

