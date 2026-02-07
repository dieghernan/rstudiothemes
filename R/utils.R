# Convert values to HEX color strings
col2hex <- function(x) {
  x <- trimws(x)
  x <- expand_hex(x)

  # Try to interpret the input as a color and convert
  res <- try(col2rgb(x, alpha = TRUE), silent = TRUE)
  if (inherits(res, "try-error")) {
    return(x)
  }

  res <- t(res)

  # Handle alpha channel if present
  if (res[4] < 255) {
    # Convert to hexadecimal with alpha
    hex <- rgb(
      red = res[1],
      green = res[2],
      blue = res[3],
      alpha = res[4],
      maxColorValue = 255
    )
  } else {
    # Not needed
    hex <- rgb(red = res[1], green = res[2], blue = res[3], maxColorValue = 255)
  }

  toupper(hex)
}

# Determine theme type based on brightness
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

# Compatibility helper for R <= 4.4
expand_hex <- function(x) {
  if (all(grepl("^#", x), nchar(x) %in% c(4, 5))) {
    rem <- gsub("#", "", x, fixed = TRUE)
    pieces <- unlist(strsplit(rem, "*"))
    new <- paste(unlist(lapply(pieces, rep, 2)), collapse = "")
    x <- paste0("#", new)
  }

  x
}


#' Match argument with pretty error message
#'
#' @param arg The argument to match.
#' @param choices The possible choices for the argument.
#'
#' @returns
#' The matched argument.
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
  # Compute approximate match hint
  aproxmatch <- pmatch(arg, choices)[1]

  if (length(arg) > 1 || is.na(lmatch)) {
    # Create error message
    if (length(choices) == 1) {
      msg <- paste0("{.str ", choices, "}")
    } else {
      l_choices <- length(choices)
      msg <- paste0("{.str ", choices[-l_choices], "}", collapse = ", ")
      msg <- paste0(msg, " or {.str ", choices[l_choices], "}")
      # Add 'one of' at the beginning
      msg <- paste0("one of ", msg)
    }

    msg <- paste0(msg, ", not ")
    bad_arg <- paste0("{.str ", arg, "}", collapse = " or ")
    msg <- paste0(msg, bad_arg, ".")

    # Maybe it's a close match suggestion?
    reg_msg <- NULL
    if (!is.na(aproxmatch)) {
      aprox <- choices[aproxmatch]
      aprox_val <- paste0("{.str ", aprox, "}", collapse = " or ")
      reg_msg <- paste0("Did you mean ", aprox_val, "?")
    }

    cli::cli_abort(
      c(
        paste0("{.arg {arg_name}} should be ", msg),
        "i" = reg_msg
      ),
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
