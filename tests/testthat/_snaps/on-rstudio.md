# on_rstudio() returns FALSE in Positron

    Code
      on_rstudio()
    Message
      ! Detected GUI "Positron".
    Output
      [1] FALSE

# on_rstudio() returns TRUE in RStudio

    Code
      on_rstudio()
    Output
      [1] TRUE

# on_rstudio() returns FALSE in RTerm

    Code
      on_rstudio()
    Message
      ! Detected GUI "RTerm".
    Output
      [1] FALSE

# on_rstudio() treats VS Code sessions as non-RStudio

    Code
      on_rstudio()
    Message
      ! Detected GUI "Visual Studio Code".
    Output
      [1] FALSE

