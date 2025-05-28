# Try to create HEX values
col2hex <- function(x) {
  x <- trimws(x)

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
      red = res[1], green = res[2], blue = res[3], alpha = res[4],
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

  rgb_values <- t(col2rgb(x))
  bright <- sum(rgb_values * c(.299, .587, .114))


  if (bright > 128) theme_type <- "light"

  theme_type
}
