# Check list_pkg_rstudiothemes

    Code
      sel_single <- list_pkg_rstudiothemes(style = "dark", themes = c("XXX",
        "Selenized Light"))
    Message
      ! Found 1 matching theme among 2 requested names, "XXX" and "Selenized Light".
      i Use `rstudiothemes::list_rstudiothemes()` to check the available names.

---

    Code
      nn <- list_pkg_rstudiothemes(themes = c("a", "b"))
    Message
      ! Found no matching themes among 2 requested names, "a" and "b".
      i Use `rstudiothemes::list_rstudiothemes()` to check the available names.

---

    Code
      nn <- list_pkg_rstudiothemes(themes = "a")
    Message
      ! Found no matching themes among 1 requested name, "a".
      i Use `rstudiothemes::list_rstudiothemes()` to check the available names.

---

    Code
      sel_single <- list_pkg_rstudiothemes(style = "dark", themes = c("XXX",
        "Selenized Light", "Selenized Dark"))
    Message
      ! Found 2 matching themes among 3 requested names, "XXX", "Selenized Light", and "Selenized Dark".
      i Use `rstudiothemes::list_rstudiothemes()` to check the available names.

# How to install

    Code
      cli_how2install()
    Message
      x No rstudiothemes themes are installed.
      i Use `rstudiothemes::install_rstudiothemes()` to install the package themes.

