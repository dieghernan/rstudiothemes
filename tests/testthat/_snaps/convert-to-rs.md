# convert_to_rstudio_theme() reports invalid inputs

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

# convert_to_rstudio_theme() installs and applies themes

    Code
      result <- convert_to_rstudio_theme(tmtheme, outfile = outfile, name = "Applied theme",
        force = TRUE, apply = TRUE)
    Message
      i Installing RStudio theme "Applied theme".
      v Installed theme "Installed theme".
      i Applying theme "Applied theme".
    Code
      invisible(result)

# convert_to_rstudio_theme() reports installation warnings

    Code
      result <- convert_to_rstudio_theme(tmtheme, outfile = outfile, force = TRUE)
    Message
      i Installing RStudio theme "Converted Theme".
      ! Theme already exists
    Code
      invisible(result)

# convert_to_rstudio_theme() reports installation errors

    Code
      result <- convert_to_rstudio_theme(tmtheme, outfile = outfile, force = TRUE)
    Message
      i Installing RStudio theme "Converted Theme".
      x Cannot install theme
    Code
      invisible(result)

