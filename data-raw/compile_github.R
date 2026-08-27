# Compile and build in the terminal with system tools.

current_wd <- getwd()

system(
  "git clone https://github.com/primer/github-vscode-theme.git data-raw/github-theme"
)
setwd("./data-raw/github-theme")
system("npm install")
system("npm run build")

# Copy the themes.
thems <- list.files("themes", pattern = ".json", full.names = TRUE)
file.copy(thems, "../vscode_themes", overwrite = TRUE)

# Restore the working directory and clean up.
setwd(current_wd)
system("rm -rf ./data-raw/github-theme")
