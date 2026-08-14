# read_vs_theme() reports invalid inputs

    Code
      read_vs_theme()
    Condition
      Error in `read_vs_theme()`:
      ! The `path` argument is required.

---

    Code
      read_vs_theme("a.txt")
    Condition
      Error in `read_vs_theme()`:
      ! The `path` argument must be a '.json' file, not "txt".

---

    Code
      read_vs_theme("a.json")
    Condition
      Error in `local_theme_file()`:
      ! File 'a.json' was not found.

# read_vs_theme() downloads URL inputs

    Code
      res <- read_vs_theme(path)
    Message
      i Downloading theme from <https://raw.githubusercontent.com/dieghernan/rstudiothemes/refs/heads/main/inst/ext/test-color-theme.json>.
    Code
      invisible(res)

