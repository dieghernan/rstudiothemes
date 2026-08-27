# partial theme matches are returned with guidance

    Code
      selected <- list_pkg_rstudiothemes(style = "dark", themes = c("XXX",
        "Selenized Light"))
    Message
      ! Could not match 1 requested theme name: "XXX".
      i Use `rstudiothemes::list_rstudiothemes()` to check available names.

# two unmatched theme names use plural guidance

    Code
      result <- list_pkg_rstudiothemes(themes = c("a", "b"))
    Message
      ! Could not match 2 requested theme names: "a" and "b".
      i Use `rstudiothemes::list_rstudiothemes()` to check available names.

# three unmatched theme names use list guidance

    Code
      result <- list_pkg_rstudiothemes(themes = c("a", "b", "c"))
    Message
      ! Could not match 3 requested theme names: "a", "b", and "c".
      i Use `rstudiothemes::list_rstudiothemes()` to check available names.

# missing installations provide actionable guidance

    Code
      cli_how2install()
    Message
      ! No rstudiothemes themes are installed.
      i Use `rstudiothemes::install_rstudiothemes()` to install the package themes.

# custom installation directories receive copied theme files

    Code
      install_rstudiothemes(destdir = dest_dir)
    Message
      i Installing 1 theme to '<themes>'.
      v Installed 1 theme.
      i Use `rstudiothemes::list_rstudiothemes()` to list installed themes.
      i Use `rstudiothemes::try_rstudiothemes()` to preview installed themes.

# custom installation failures report uncopied theme files

    Code
      install_rstudiothemes(destdir = dest_dir)
    Message
      i Installing 2 themes to '<themes>'.
    Condition
      Error in `install_rstudiothemes()`:
      ! Could not install all requested themes.
      x Failed to copy 1 theme file: 'two.rstheme'.

# default installation adds every selected theme

    Code
      install_rstudiothemes()
    Message
      v Installed 2 themes.
      i Use `rstudiothemes::list_rstudiothemes()` to list installed themes.
      i Use `rstudiothemes::try_rstudiothemes()` to preview installed themes.

# removal deletes every installed bundled theme

    Code
      remove_rstudiothemes()
    Message
      v Uninstalled 2 themes.

# installed listings explain when no bundled themes match

    Code
      res <- list_rstudiothemes()
    Message
      ! No rstudiothemes themes are installed.
      i Use `rstudiothemes::install_rstudiothemes()` to install the package themes.

# timed previews restore the original theme

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
      v Restored the original theme "Original Theme".

# quitting a prompted preview restores the original theme

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
      v Restored the original theme "Original Theme".

# keeping a prompted preview leaves the selected theme active

    Code
      try_rstudiothemes(themes = "Light Theme")
    Message
      > Trying 1 theme from rstudiothemes.
      > At the prompt, choose one of:
      * [n] or [SPACE] to try the next theme.
      * [k] to keep that theme.
      * [q] to quit and restore your original theme.
      * "Light Theme"

