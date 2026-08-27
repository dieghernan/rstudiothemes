# Positron sessions are not treated as RStudio

    Code
      on_rstudio()
    Message
      ! Detected GUI "Positron".
    Output
      [1] FALSE

# RStudio sessions are detected

    Code
      on_rstudio()
    Output
      [1] TRUE

# RTerm sessions are not treated as RStudio

    Code
      on_rstudio()
    Message
      ! Detected GUI "RTerm".
    Output
      [1] FALSE

# Visual Studio Code sessions are not treated as RStudio

    Code
      on_rstudio()
    Message
      ! Detected GUI "Visual Studio Code".
    Output
      [1] FALSE

