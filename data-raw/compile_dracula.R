# Compile and build in the terminal with system tools.

current_wd <- getwd()

system(
  "git clone https://github.com/dracula/visual-studio-code.git data-raw/theme-dracula"
)
setwd("./data-raw/theme-dracula")
system("npm install")
system("npm run build")

# Copy the themes.
thems <- list.files("theme", pattern = ".json", full.names = TRUE)
file.copy(thems, "../vscode_themes", overwrite = TRUE)

# Restore the working directory and clean up.
setwd(current_wd)
system("rm -rf ./data-raw/theme-dracula")
