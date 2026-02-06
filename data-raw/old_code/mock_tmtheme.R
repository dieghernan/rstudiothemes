library(rstudiothemes)

ff <- system.file("ext/test-simple-color-theme.json", package = "rstudiothemes")

convert_vs_to_tm_theme(
  ff,
  "inst/ext/test.tmTheme",
  author = "rstudiothemes",
  name = "Testing RStudioTheme"
)
