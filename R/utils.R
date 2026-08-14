# Convert color values to hex strings (#RRGGBB or #RRGGBBAA format).
# Handle color names, RGB triples and hex inputs, then return uppercase hex.
col2hex <- function(x) {
  x <- trimws(x)
  x <- expand_hex(x)

  # Try to interpret the input as a color and convert it.
  res <- try(col2rgb(x, alpha = TRUE), silent = TRUE)
  if (inherits(res, "try-error")) {
    return(x)
  }

  res <- t(res)

  # Handle the alpha channel when present.
  if (res[4] < 255) {
    # Convert to hexadecimal with alpha.
    hex <- rgb(
      red = res[1],
      green = res[2],
      blue = res[3],
      alpha = res[4],
      maxColorValue = 255
    )
  } else {
    # Use an opaque color when no alpha channel is present.
    hex <- rgb(red = res[1], green = res[2], blue = res[3], maxColorValue = 255)
  }

  toupper(hex)
}

# Determine the theme type from brightness.
dark_or_light <- function(x) {
  theme_type <- "dark"

  x <- expand_hex(x)
  rgb_values <- try(t(col2rgb(x)), silent = TRUE)

  if (inherits(rgb_values, "try-error")) {
    cli::cli_abort("Color {.val {x}} is not valid.")
  }

  bright <- sum(rgb_values * c(0.299, 0.587, 0.114))

  if (bright > 128) {
    theme_type <- "light"
  }

  theme_type
}

# Compatibility helper for R <= 4.4.
expand_hex <- function(x) {
  if (all(grepl("^#", x), nchar(x) %in% c(4, 5))) {
    rem <- gsub("#", "", x, fixed = TRUE)
    pieces <- unlist(strsplit(rem, "*"))
    new <- paste(unlist(lapply(pieces, rep, 2)), collapse = "")
    x <- paste0("#", new)
  }

  x
}

#' Match an argument with a clear error message
#'
#' @param arg Argument to match.
#' @param choices Allowed values for `arg`.
#'
#' @returns
#' The matched argument value.
#'
#' @noRd
match_arg_pretty <- function(arg, choices) {
  arg_name <- as.character(substitute(arg)) # nolint

  if (missing(choices)) {
    formal_args <- formals(sys.function(sys_par <- sys.parent()))
    choices <- eval(
      formal_args[[as.character(substitute(arg))]],
      envir = sys.frame(sys_par)
    )
  }
  choices <- as.character(choices)

  if (is.null(arg)) {
    return(choices[1L])
  }

  arg <- as.character(arg)

  if (identical(arg, choices)) {
    return(arg[1])
  }

  lmatch <- match(arg, choices)
  # Compute the approximate match hint.
  aproxmatch <- pmatch(arg, choices)[1]

  if (length(arg) > 1 || is.na(lmatch)) {
    # Create the error message.
    if (length(choices) == 1) {
      msg <- paste0("{.str ", choices, "}")
    } else {
      l_choices <- length(choices)
      msg <- paste0("{.str ", choices[-l_choices], "}", collapse = ", ")
      msg <- paste0(msg, " or {.str ", choices[l_choices], "}")
      # Add "one of" at the beginning.
      msg <- paste0("one of ", msg)
    }

    msg <- paste0(msg, ", not ")
    bad_arg <- paste0("{.str ", arg, "}", collapse = " or ")
    msg <- paste0(msg, bad_arg, ".")

    # Build a close-match suggestion when available.
    reg_msg <- NULL
    if (!is.na(aproxmatch)) {
      aprox <- choices[aproxmatch]
      aprox_val <- paste0("{.str ", aprox, "}", collapse = " or ")
      reg_msg <- paste0("Did you mean ", aprox_val, "?")
    }

    cli::cli_abort(
      c(paste0("{.arg {arg_name}} should be ", msg), "i" = reg_msg),
      call = NULL
    )
  }

  choices[lmatch]
}

ensure_null <- function(x) {
  x_init <- x[!is.na(x)]
  x <- as.vector(x)
  x[is.null(x)] <- NA
  x[is.na(x)] <- NA
  x[nchar(as.character(x)) == 0] <- NA
  if (all(is.na(x))) {
    return(NULL)
  }

  x_init
}

normalize_theme_text <- function(x) {
  x <- gsub("  ", " ", x, fixed = TRUE)
  x <- gsub("  ", " ", x, fixed = TRUE)

  trimws(x)
}

theme_mapping <- function() {
  read.csv(
    system.file("csv/mapping.csv", package = "rstudiothemes"),
    na.strings = c("NA", "")
  )
}

require_rstudio <- function(caller) {
  if (on_rstudio()) {
    return(TRUE)
  }

  gui <- detect_gui() # nolint
  cli::cli_alert_danger(paste0(
    "{.fn rstudiothemes::{caller}} can only run in RStudio, ",
    "not in {.val {gui}}."
  ))
  cli::cli_alert_info("No changes made.")

  FALSE
}

local_theme_file <- function(path, fileext) {
  if (grepl("^http", path)) {
    local_file <- tempfile(fileext = paste0(".", fileext))
    cli::cli_alert_info("Downloading theme from {.url {path}}.")
    download_theme_file(path, local_file, quiet = TRUE, mode = "wb")
  } else {
    local_file <- path
  }

  if (!file.exists(local_file)) {
    cli::cli_abort("File {.file {local_file}} was not found.")
  }

  local_file
}

# nocov start
download_theme_file <- function(url, destfile, quiet = TRUE, mode = "wb") {
  download.file(url, destfile, quiet = quiet, mode = mode)
}
# nocov end
