# list_pkg_rstudiothemes() filters bundled themes by style and name

    Code
      sel_single <- list_pkg_rstudiothemes(style = "dark", themes = c("XXX",
        "Selenized Light"))
    Message
      ! Matched 1 theme among 2 requested names: "XXX" and "Selenized Light".
      i Use `rstudiothemes::list_rstudiothemes()` to check available names.

---

    Code
      nn <- list_pkg_rstudiothemes(themes = c("a", "b"))
    Message
      ! Matched no themes among 2 requested names: "a" and "b".
      i Use `rstudiothemes::list_rstudiothemes()` to check available names.

---

    Code
      nn <- list_pkg_rstudiothemes(themes = "a")
    Message
      ! Matched no themes among 1 requested name: "a".
      i Use `rstudiothemes::list_rstudiothemes()` to check available names.

---

    Code
      sel_single <- list_pkg_rstudiothemes(style = "dark", themes = c("XXX",
        "Selenized Light", "Selenized Dark"))
    Message
      ! Matched 2 themes among 3 requested names: "XXX", "Selenized Light", and "Selenized Dark".
      i Use `rstudiothemes::list_rstudiothemes()` to check available names.

# cli_how2install() explains how to install bundled themes

    Code
      cli_how2install()
    Message
      ! No rstudiothemes themes are installed.
      i Use `rstudiothemes::install_rstudiothemes()` to install the package themes.

# list_rstudiothemes() reports when no bundled themes are installed

    Code
      res <- list_rstudiothemes()
    Message
      ! No rstudiothemes themes are installed.
      i Use `rstudiothemes::install_rstudiothemes()` to install the package themes.

# try_rstudiothemes() restores the original theme

    Code
      try_rstudiothemes(delay = 1)
    Message
      > Trying 2 themes from rstudiothemes.
      > At the prompt, choose one of:
      * [n] or [SPACE] to try the next theme.
      * [k] to keep that theme.
      * [q] to quit and restore your original theme.
      * "Light Theme"
      * "Dark Theme"
      v Restoring the original theme: Original Theme.

# try_rstudiothemes() handles selected themes and prompt choices

    Code
      try_rstudiothemes(themes = c("Light Theme", "Dark Theme"))
    Message
      > Trying 2 themes from rstudiothemes.
      > At the prompt, choose one of:
      * [n] or [SPACE] to try the next theme.
      * [k] to keep that theme.
      * [q] to quit and restore your original theme.
      * "Light Theme"
      * "Dark Theme"
      v Restoring the original theme: Original Theme.

---

    Code
      try_rstudiothemes(themes = "Light Theme")
    Message
      > Trying 1 theme from rstudiothemes.
      > At the prompt, choose one of:
      * [n] or [SPACE] to try the next theme.
      * [k] to keep that theme.
      * [q] to quit and restore your original theme.
      * "Light Theme"

