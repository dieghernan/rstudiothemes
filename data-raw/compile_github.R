# Compile and build on terminal using system

current_wd <- getwd()

system(
  "git clone https://github.com/primer/github-vscode-theme.git data-raw/github-theme"
)
setwd("./data-raw/github-theme")
system("npm install")
system("npm run build")

# Copy themes
thems <- list.files("themes", pattern = ".json", full.names = TRUE)
file.copy(thems, "../vscode_themes", overwrite = TRUE)

# Restore and clean
setwd(current_wd)
system("rm -rf ./data-raw/github-theme")
