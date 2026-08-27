# conversion rejects missing paths and unsupported extensions

    Code
      convert_to_rstudio_theme()
    Condition
      Error in `convert_to_rstudio_theme()`:
      ! The `path` argument is required.

---

    Code
      convert_to_rstudio_theme("a.txt")
    Condition
      Error in `convert_to_rstudio_theme()`:
      ! The `path` argument must be a 'tmTheme' or 'json' file, not "txt".

# successful installation applies the requested theme

    Code
      result <- convert_to_rstudio_theme(tmtheme, outfile = outfile, name = "Applied theme",
        force = TRUE, apply = TRUE)
    Message
      i Installing RStudio theme "Applied theme".
      v Installed theme "Installed theme".
      i Applying theme "Applied theme".
    Code
      invisible(result)

# installation warnings still allow an existing theme to be applied

    Code
      result <- convert_to_rstudio_theme(tmtheme, outfile = outfile, force = TRUE,
        apply = TRUE)
    Message
      i Installing RStudio theme "Converted Theme".
      ! Theme {already} exists
      i Applying theme "Converted Theme".
    Code
      invisible(result)

# installation errors prevent the theme from being applied

    Code
      result <- convert_to_rstudio_theme(tmtheme, outfile = outfile, force = TRUE,
        apply = TRUE)
    Message
      i Installing RStudio theme "Converted Theme".
      x Cannot install {theme}
    Code
      invisible(result)

