# Check list_pkg_rstudiothemes

    Code
      sel_single <- list_pkg_rstudiothemes(style = "dark", themes = c("XXX",
        "Selenized Light"))
    Message
      ! Found 1 theme with names "XXX" and "Selenized Light"
      i Use `rstudiothemes::list_rstudiothemes()` to check the available names

---

    Code
      nn <- list_pkg_rstudiothemes(themes = c("a", "b"))
    Message
      ! Found no themes with names "a" and "b"
      i Use `rstudiothemes::list_rstudiothemes()` to check the available names

# How to install

    Code
      cli_how2install()
    Message
      x No rstudiothemes themes are installed.
      i Use `rstudiothemes::install_rstudiothemes()` to install our themes

