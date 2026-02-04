# Try to create HEX values
col2hex <- function(x) {
  x <- trimws(x)
  x <- expand_hex(x)

  # Guess if color and convert
  res <- try(col2rgb(x, alpha = TRUE), silent = TRUE)
  if (inherits(res, "try-error")) {
    return(x)
  }

  res <- t(res)

  # Guess if alpha is needed
  if (res[4] < 255) {
    # Hex
    hex <- rgb(
      red = res[1],
      green = res[2],
      blue = res[3],
      alpha = res[4],
      maxColorValue = 255
    )
  } else {
    # No needed
    hex <- rgb(red = res[1], green = res[2], blue = res[3], maxColorValue = 255)
  }

  toupper(hex)
}

# Guess theme type based on Brightness approach
dark_or_light <- function(x) {
  theme_type <- "dark"

  x <- expand_hex(x)
  rgb_values <- try(t(col2rgb(x)), silent = TRUE)

  if (inherits(rgb_values, "try-error")) {
    cli::cli_abort("Invalid color name {.str {x}}.")
  }

  bright <- sum(rgb_values * c(0.299, 0.587, 0.114))

  if (bright > 128) {
    theme_type <- "light"
  }

  theme_type
}

# Needed to work in R <= 4.4
expand_hex <- function(x) {
  if (all(grepl("^#", x), nchar(x) %in% c(4, 5))) {
    rem <- gsub("#", "", x, fixed = TRUE)
    pieces <- unlist(strsplit(rem, "*"))
    new <- paste(unlist(lapply(pieces, rep, 2)), collapse = "")
    x <- paste0("#", new)
  }

  x
}
