# Check list_pkg_rstudiothemes

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

# How to install

    Code
      cli_how2install()
    Message
      x No rstudiothemes themes are installed.
      i Use `rstudiothemes::install_rstudiothemes()` to install the package themes.

# list_rstudiothemes reports when no package themes are installed

    Code
      res <- list_rstudiothemes()
    Message
      x No rstudiothemes themes are installed.
      i Use `rstudiothemes::install_rstudiothemes()` to install the package themes.

# try_rstudiothemes previews themes with mocked RStudio calls

    Code
      try_rstudiothemes(delay = 1)
    Message
      > Trying 2 themes from rstudiothemes.
      > At the prompt, choose one of:
      * [n] or [SPACE] to try the next theme.
      * [k] to keep that theme.
      * [q] to quit and restore your original theme.
    Output
      • Light Theme 
      • Dark Theme 
    Message
      v Restoring the original theme, Original Theme.

# try_rstudiothemes handles selected themes and prompt choices

    Code
      try_rstudiothemes(themes = c("Light Theme", "Dark Theme"))
    Message
      > Trying 2 themes from rstudiothemes.
      > At the prompt, choose one of:
      * [n] or [SPACE] to try the next theme.
      * [k] to keep that theme.
      * [q] to quit and restore your original theme.
    Output
      • Light Theme 
      • Dark Theme 
    Message
      v Restoring the original theme, Original Theme.

---

    Code
      try_rstudiothemes(themes = "Light Theme")
    Message
      > Trying 1 theme from rstudiothemes.
      > At the prompt, choose one of:
      * [n] or [SPACE] to try the next theme.
      * [k] to keep that theme.
      * [q] to quit and restore your original theme.
    Output
      • Light Theme 

