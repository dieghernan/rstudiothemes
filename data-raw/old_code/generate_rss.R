# library(rstudiothemes)
library(tidyverse)
devtools::load_all()
mythemes <- list.files(
  "./data-raw/tmthemes",
  pattern = "tmTheme",
  recursive = TRUE,
  full.names = TRUE
)
t <- mythemes[1]

for (t in mythemes) {
  out <- basename(t) |>
    str_replace("tmTheme", "rstheme") |>
    str_replace_all(" ", "_") %>%
    file.path("inst/rsthemes", .)

  create_rs_theme(t, out, force = TRUE)
}
