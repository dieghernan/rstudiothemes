library(rstudiothemes)
list.files("./data-raw/vsthemesmod", pattern = ".json", recursive = TRUE)

convert_vs_to_tm_theme(
  "data-raw/vsthemesmod/cobalt2/cobalt2.json",
  "data-raw/tmthemes/cobalt2.tmTheme",
  name = "cobalt2"
)
convert_vs_to_tm_theme(
  "data-raw/vsthemesmod/cran/cran-color-theme.json",
  "data-raw/tmthemes/cran.tmTheme"
)

convert_vs_to_tm_theme(
  "data-raw/vsthemesmod/dracula/dracula.json",
  "data-raw/tmthemes/Dracula2025.tmTheme",
  name = "Dracula2025"
)

convert_vs_to_tm_theme(
  "data-raw/vsthemesmod/jellyfish/JellyFish Theme-color-theme.json",
  "data-raw/tmthemes/JellyFish Theme.tmTheme"
)

convert_vs_to_tm_theme(
  "data-raw/vsthemesmod/night-owl/Night Owl-color-theme-noitalic.json",
  "data-raw/tmthemes/Night Owl.tmTheme",
  name = "Night Owl"
)

convert_vs_to_tm_theme(
  "data-raw/vsthemesmod/synthwave/synthwave-color-theme.json",
  "data-raw/tmthemes/SynthWave 84.tmTheme"
)

convert_vs_to_tm_theme(
  "data-raw/vsthemesmod/tokyo-night/tokyo-night-color-theme.json",
  "data-raw/tmthemes/Tokyo Night.tmTheme"
)

convert_vs_to_tm_theme(
  "data-raw/vsthemesmod/winteriscoming/WinterIsComing-dark-blue-color-no-italics-theme.json",
  "data-raw/tmthemes/Winter is Coming Dark Blue.tmTheme",
  name = "Winter is Coming Dark Blue"
)
