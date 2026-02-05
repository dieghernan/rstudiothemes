#' Convert a TextMate or VS Code theme to an RStudio theme
#'
#' @description
#' Read a `.tmTheme` or `.json` file that defines a TextMate or Visual
#' Studio Code theme and write the equivalent RStudio theme `.rstheme`.
#'
#' Optionally, the generated theme can be installed and applied to the
#' RStudio IDE.
#'
#' **Important**: This function only works in RStudio; it returns `NULL` when
#' called from other IDEs.
#'
#' ```{r, echo=FALSE, results='asis'}
#' v <- rstudioapi::versionInfo()
#' c("\n", paste0(
#'   " Function tested in **RStudio ", v$long_version,
#'   '** "', v$release_name, '".'
#' )) |> cat()
#'
#' ```
#'
#' @param path Path or URL to a TextMate theme (in `.tmTheme` format) or a
#'   Visual Studio Code theme, in `.json` format.
#' @param apply logical. Apply the theme with [rstudioapi::applyTheme()].
#' @param use_italics logical. Whether to use italics in the resulting theme.
#'   By default `TRUE`, but some themes may look better without italics.
#'
#' @inheritParams rstudioapi::addTheme
#' @inheritParams sass::sass_options
#' @inheritParams convert_vs_to_tm_theme
#'
#' @returns
#' This function is called for its side effects. It writes a new
#' `.rstheme` file to `outfile` and returns the path. If `force` or `apply`
#' are `TRUE`, it will install and apply the theme to your RStudio IDE.
#'
#' @details
#' RStudio supports custom editor themes in two formats: `.tmTheme` and
#' `.rstheme`. The `.tmTheme` format originated with TextMate and has become a
#' common theme format.
#' [This tmTheme editor](https://tmtheme-editor.linuxbox.ninja/) hosts a large
#' collection of `.tmTheme` files. The `.rstheme` format is specific to RStudio.
#'
#' To switch editor themes, go to `Tools > Global Options > Appearance` and
#' use the Editor theme selector.
#'
#' \if{html}{
#'   \out{<div style="text-align: center">}
#'
#'    \figure{rstudiogui.png}{options: alt="Install a theme from RStudio GUI"
#'        style="max-width:90\%;"}
#'
#'    \out{</div>}
#' }
#'
#' See more in <https://docs.posit.co/ide/user/ide/guide/ui/appearance.html>.
#'
#' @family functions for creating themes
#'
#' @export
#'
#' @seealso [rstudioapi::addTheme()], [rstudioapi::applyTheme()]
#' @examples
#' if (on_rstudio() && interactive()) {
#'   vstheme <- system.file("ext/skeletor-syntax-color-theme.json",
#'     package = "rstudiothemes"
#'   )
#'
#'
#'   # Apply the theme for 10 seconds to demonstrate the effect
#'
#'   current_theme <- rstudioapi::getThemeInfo()$editor
#'
#'   # Current theme name:
#'   current_theme
#'   new_rs_theme <- convert_to_rstudio_theme(vstheme,
#'     name = "A testing theme",
#'     apply = TRUE, force = TRUE
#'   )
#'
#'
#'   Sys.sleep(10)
#'
#'   rstudioapi::applyTheme(current_theme)
#'   rstudioapi::removeTheme("A testing theme")
#' }
convert_to_rstudio_theme <- function(
  path,
  outfile = tempfile(fileext = ".rstheme"),
  name = NULL,
  use_italics = TRUE,
  output_style = "expanded",
  force = FALSE,
  apply = FALSE
) {
  # Only works in RStudio
  if (!on_rstudio()) {
    gui <- detect_gui() # nolint
    cli::cli_alert_danger(
      paste0(
        "{.fn rstudiothemes::convert_to_rstudio_theme} only works in RStudio, ",
        "not in {gui}."
      )
    )
    cli::cli_alert("Bye")
    return(NULL)
  }

  # Validate inputs
  if (missing(path)) {
    cli::cli_abort("Argument {.arg path} can't be empty.")
  }

  ext <- tools::file_ext(path)
  valid_ext <- c("tmTheme", "json")

  if (!ext %in% valid_ext) {
    cli::cli_abort(
      paste0(
        "Argument {.arg path} should be a {.or {.str {valid_ext}}} file",
        " not {.str {ext}}."
      )
    )
  }

  if (!file.exists(path)) {
    cli::cli_abort("File {.path {path}} does not exist.")
  }

  if (ext == "json") {
    tm_temp <- tempfile(fileext = ".tmTheme")
    path <- convert_vs_to_tm_theme(path, tm_temp)
  }

  tmcols <- read_tm_theme(path)

  # Top-level colors
  tb_hlp_top <- dplyr::tibble(
    name = c("caret", "invisibles"),
    rstheme = c(".ace_cursor", ".ace_print-margin")
  )

  tmcols_top <- dplyr::inner_join(tmcols, tb_hlp_top, by = "name")
  keepvals <- c("rstheme", "foreground", "background", "fontStyle")
  rstheme_top <- tmcols_top[, keepvals]

  # Map tmTheme scopes to ACE editor CSS rules
  tmcols_scopes <- tmcols[
    !is.na(tmcols$scope),
    c("scope", "foreground", "background", "fontStyle")
  ]

  # Remove empty specifications
  empty_row <- is.na(tmcols_scopes$foreground) &
    is.na(tmcols_scopes$background) &
    is.na(tmcols_scopes$fontStyle)

  tmcols_scopes <- tmcols_scopes[!empty_row, ]

  # Modify some scopes to adapt to the ACE editor
  ## Convert link-like scopes to href

  tmcols_scopes[
    grepl(
      "markup[\\S]*link|link[\\S]*markdown",
      tmcols_scopes$scope,
      perl = TRUE
    ),
  ]$scope <- "markup.href"

  ## Additional markup heading
  heading <- tmcols_scopes[
    grepl("markup.heading", tmcols_scopes$scope, fixed = TRUE),
  ]
  heading$scope <- "heading"
  tmcols_scopes <- rbind(tmcols_scopes, heading)

  ## Meta tags
  metan <- c("entity.name.tag.html", "meta.tag")
  tmcols_scopes[tmcols_scopes$scope %in% metan, ]$scope <- "meta.tag"

  # Add XML pseudo-scope
  xmlpe <- tmcols_scopes[tmcols_scopes$scope == "comment", ]
  xmlpe$scope <- "xml-pe"
  tmcols_scopes <- rbind(tmcols_scopes, xmlpe)

  tmcols_scopes_end <- create_ace_cascade(tmcols_scopes)

  # Final adjustments
  end_df <- dplyr::bind_rows(rstheme_top, tmcols_scopes_end)

  end_df$fontweight <- ifelse(
    grepl("bold", end_df$fontStyle, ignore.case = TRUE),
    "bold",
    NA
  )

  if (use_italics) {
    end_df$fontstyle <- ifelse(
      grepl("italic", end_df$fontStyle, ignore.case = TRUE),
      "italic",
      NA
    )
  } else {
    end_df$fontstyle <- NA
  }

  new_css <- c("/* Rules from tmTheme */", "")

  for (cssrule in end_df$rstheme) {
    thisval <- end_df[end_df$rstheme == cssrule, ]
    if (cssrule == ".ace_print-margin") {
      thisrule <- paste0(
        ".ace_print-margin {background: ",
        thisval$foreground,
        ";}"
      )
      new_css <- c(new_css, thisrule, "")
    } else {
      newr <- list(
        color = thisval$foreground,
        "background-color" = thisval$background,
        "font-weight" = thisval$fontweight,
        "font-style" = thisval$fontstyle
      )
      newr_clean <- newr[!is.na(newr)]
      if (length(newr_clean) == 0) {
        next
      } # Empty model
      specs <- paste0(names(newr_clean), ": ", newr_clean, ";", collapse = " ")
      thisrule <- paste0(cssrule, " {", specs, "}")
      new_css <- c(new_css, thisrule, "")
    }
  }

  ## Build ----

  # Create initial compilation
  uuid <- generate_uuid()
  tmp <- file.path(tempdir(), uuid)
  dir.create(tmp, recursive = TRUE, showWarnings = FALSE)
  theme_name <- rstudioapi::convertTheme(
    path,
    add = FALSE,
    outputLocation = tmp,
    force = TRUE
  )

  # Read lines of the auto-generated rstheme (CSS)
  # and append new CSS rules and additional variables
  tmpfile <- list.files(tmp, full.names = TRUE)
  themelines <- readLines(tmpfile)

  # Replace theme name if requested
  if (!is.null(name)) {
    themelines[grepl("rs-theme-name", themelines, fixed = TRUE)] <- paste(
      "/* rs-theme-name:",
      name,
      "*/"
    )

    theme_name <- name
  }

  themelines <- gsub("blur(1px)", "brightness(75%)", themelines)

  vtext <- paste0(
    "/* Generated with rstudiothemes package */"
  )

  additional <- c("")

  hl_sass <- dplyr::tibble(
    section = "colors",
    name = c(
      "foreground",
      "background",
      "caret",
      "selection"
    ),
    var = c("fg", "bg", "accent", "selection")
  )

  hl_vars <- dplyr::inner_join(tmcols, hl_sass, by = c("section", "name"))
  comm <- tmcols[grepl("comment", tmcols$scope), ]$foreground
  sass_vars <- c(
    paste0("$", hl_vars$var, ": ", hl_vars$foreground, ";"),
    paste0("$comment: ", comm[!is.na(comm)][1], ";")
  )

  additional <- c(
    sass_vars,
    readLines(system.file("scss/_themed_ide.scss", package = "rstudiothemes"))
  )

  themelines <- c(themelines, vtext, "", new_css, additional)

  # Write
  sass::sass(
    themelines,
    output = outfile,
    cache = FALSE,
    options = sass::sass_options(output_style = output_style)
  )

  # Install theme
  if (any(apply, force)) {
    cli::cli_alert_info("Installing rstheme {.str {theme_name}}.")

    capture_log <- tryCatch(
      rstudioapi::addTheme(outfile, force = force),
      error = function(e) {
        e
      },
      warning = function(e) {
        e
      }
    )
    if ("warning" %in% attr(capture_log, "class")) {
      cli::cli_alert_warning(capture_log$message)
    } else if ("error" %in% attr(capture_log, "class")) {
      cli::cli_alert_danger(capture_log$message)
    } else {
      cli::cli_alert_success(
        "Theme {.arg {capture_log}} installed."
      )
    }
    if (apply) {
      cli::cli_alert_info(
        "Applying {.arg {theme_name}}..."
      )
      rstudioapi::applyTheme(theme_name)
    }
  }

  outfile
}

create_ace_cascade <- function(tmcols_scopes) {
  full <- tmcols_scopes
  full <- dplyr::distinct(full, .keep_all = FALSE)

  # Exclude scopes containing spaces (pseudo-CSS)
  full <- full[!grepl(" ", full$scope, fixed = TRUE), ]

  # Compute hierarchy levels

  level <- vapply(
    full$scope,
    function(x) {
      ll <- gregexpr(".", x, fixed = TRUE)
      if (-1 %in% ll) {
        return(1)
      }

      length(unlist(ll)) + 1
    },
    FUN.VALUE = numeric(1)
  )

  level <- unname(level)

  lev3 <- full[level == 3, ]
  lev2 <- full[level == 2, ]
  lev1 <- full[level == 1, ]

  # Ensure single value for scope
  lev3 <- more_freq_rule(lev3)

  # Enrich level-2 scopes with level-3 info

  lev2_xtra <- lev3

  # Limit fontStyle inheritance for propagated entries
  lev2_xtra$fontStyle <- NA

  lev2_xtra$scope <- vapply(
    lev3$scope,
    function(x) {
      l <- unlist(strsplit(x, split = ".", fixed = TRUE))

      paste0(l[seq_len(2)], collapse = ".")
    },
    FUN.VALUE = character(1)
  )

  lev2_xtra <- more_freq_rule(lev2_xtra)

  lev2_end <- dplyr::bind_rows(
    lev2,
    lev2_xtra[!lev2_xtra$scope %in% lev2$scope, ]
  )

  lev2_end <- more_freq_rule(lev2_end)
  # Enrich level-1 scopes with level-2 info

  lev1_xtra <- lev2_end

  # Limit fontStyle inheritance
  lev1_xtra$fontStyle <- NA

  lev1_xtra$scope <- vapply(
    lev2_end$scope,
    function(x) {
      l <- unlist(strsplit(x, split = ".", fixed = TRUE))

      l[1]
    },
    FUN.VALUE = character(1)
  )
  lev1_xtra <- more_freq_rule(lev1_xtra)

  lev1_end <- dplyr::bind_rows(
    lev1,
    lev1_xtra[!lev1_xtra$scope %in% lev1$scope, ]
  )

  lev1_end <- more_freq_rule(lev1_end)

  final_ace <- dplyr::bind_rows(lev1_end, lev2_end, lev3)
  final_ace <- more_freq_rule(final_ace)
  final_ace <- final_ace[!duplicated(final_ace$scope), ]
  final_ace <- final_ace[order(final_ace$scope), ]
  final_ace$rstheme <- paste0(
    ".ace_",
    gsub(".", ".ace_", final_ace$scope, fixed = TRUE)
  )
  final_ace[, c("rstheme", "foreground", "background", "fontStyle")]
}

more_freq_rule <- function(df) {
  df_g <- dplyr::grouped_df(df, names(df))
  df_g <- dplyr::mutate(df_g, n = dplyr::n())
  df_g <- df_g[order(df_g$scope, df_g$n), ]
  df_g <- dplyr::grouped_df(df_g, "scope")
  df_g <- dplyr::slice_tail(df_g, n = 1)
  df_g <- dplyr::ungroup(df_g)
  df_g[, names(df)]
}
