library(rstudiothemes)
library(tidyverse)
mythemes <- list.files("./data-raw/tmthemes",
  pattern = "tmTheme", recursive = TRUE,
  full.names = TRUE
)
t <- mythemes[1]

for (t in mythemes) {
  out <- basename(t) |>
    str_replace("tmTheme", "rstheme") |>
    str_replace_all(" ", "_") %>%
    file.path("inst/rsthemes", .)

  create_rstheme(t, out, force = TRUE)
}
