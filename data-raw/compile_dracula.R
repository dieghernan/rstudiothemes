# Compile and build on terminal using system

current_wd <- getwd()

system(
  "git clone https://github.com/dracula/visual-studio-code.git data-raw/theme-dracula"
)
setwd("./data-raw/theme-dracula")
system("npm install")
system("npm run build")

# Copy themes
thems <- list.files("theme", pattern = ".json", full.names = TRUE)
file.copy(thems, "../vscode_themes", overwrite = TRUE)

# Restore and clean
setwd(current_wd)
system("rm -rf ./data-raw/theme-dracula")
