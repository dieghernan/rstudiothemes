## code to prepare `sysdata` dataset goes here

# Mapping between tmTheme and vscode
# Based on
#  https://github.com/microsoft/vscode-generator-code/blob/6e3f05ab46b6186e588094517764fdf42f21d094/generators/app/generate-colortheme.js#L237C18-L261C2

mapping_db <- readr::read_csv("data-raw/mapping_db.csv")


usethis::use_data(mapping_db, overwrite = TRUE, internal = TRUE)
