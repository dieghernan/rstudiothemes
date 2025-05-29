library(rstudiothemes)

ff <- system.file("ext/test-simple-color-theme.json",
  package = "rstudiothemes"
)

vstheme2tmtheme(ff, "inst/ext/test.tmTheme",
  author = "rstudiothemes",
  name = "Testing RStudioTheme"
)
