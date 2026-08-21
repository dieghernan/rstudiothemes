#' Convert a theme file to RStudio
#'
#' @description
#' Convert a `.tmTheme` or `.json` file that defines a TextMate or Visual
#' Studio Code theme and write the equivalent RStudio `.rstheme` file.
#'
#' Optionally, the generated theme can be installed and applied to the RStudio
#' IDE.
#'
#' **Important**: This function only works in RStudio. It returns `NULL` when
#' called from other IDEs.
#'
#' @details
#' RStudio supports custom editor themes in two formats, `.tmTheme` and
#' `.rstheme`. The `.tmTheme` format originated with TextMate and has become a
#' common theme format. [This tmTheme
#' editor](https://tmtheme-editor.linuxbox.ninja/) hosts a large collection of
#' `.tmTheme` files. The `.rstheme` format is specific to RStudio.
#'
#' To switch editor themes, go to `Tools > Global Options > Appearance > Add`
#' and use the editor theme selector.
#'
#' \if{html}{
#'   \out{<div style="text-align: center">}
#'
#'    \figure{rstudiogui.png}{options: alt="RStudio IDE add theme UI"
#'        style="max-width:80\%;"}
#'
#'    \out{</div>}
#' }
#'
#' For more information, see
#' <https://docs.posit.co/ide/user/ide/guide/ui/appearance.html>.
#'
#' @param path Path or URL to a TextMate theme file (`.tmTheme` format) or a
#'   Visual Studio Code theme file (`.json` format).
#' @param use_italics Logical. Use italics in the resulting theme. Defaults to
#'   `TRUE`, although some themes may look better without italics.
#' @inheritParams rstudioapi::addTheme
#' @inheritParams sass::sass_options
#' @inheritParams convert_vs_to_tm_theme
#' @param apply Logical. Apply the theme with [rstudioapi::applyTheme()].
#'
#' @returns
#' This function is called for its side effects. It writes a `.rstheme` file to
#' `outfile` and returns the path. If `force` or `apply` is `TRUE`, it installs
#' the theme. If `apply` is `TRUE`, it also applies the theme to your RStudio
#' IDE.
#'
#' @family converters
#' @seealso [rstudioapi::addTheme()], [rstudioapi::applyTheme()]
#' @encoding UTF-8
#' @export
#'
#' @examples
#' if (on_rstudio() && interactive()) {
#'   vstheme <- system.file("ext/skeletor-syntax-color-theme.json",
#'     package = "rstudiothemes"
#'   )
#'
#'   # Apply the theme for 10 seconds to demonstrate the effect.
#'   current_theme <- rstudioapi::getThemeInfo()$editor
#'
#'   # Print the current theme name.
#'   current_theme
#'   new_rs_theme <- convert_to_rstudio_theme(vstheme,
#'     name = "A testing theme",
#'     apply = TRUE, force = TRUE
#'   )
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
  # Require RStudio.
  if (!require_rstudio("convert_to_rstudio_theme")) {
    return(NULL)
  }

  # Validate inputs.
  if (missing(path)) {
    cli::cli_abort("The {.arg path} argument is required.")
  }

  ext <- tools::file_ext(path)
  valid_ext <- c("tmTheme", "json")

  if (!ext %in% valid_ext) {
    cli::cli_abort(paste0(
      "The {.arg path} argument must be a {.or {.file {valid_ext}}} file",
      ", not {.val {ext}}."
    ))
  }

  if (ext == "json") {
    tm_temp <- tempfile(fileext = ".tmTheme")
    path <- convert_vs_to_tm_theme(path, tm_temp, name = name)
  } else if (grepl("^http", path)) {
    # Download only TextMate files here because Visual Studio Code conversion
    # happens implicitly in `convert_vs_to_tm_theme()`.
    path <- local_theme_file(path, "tmTheme")
  }

  tmcols <- read_tm_theme(path)

  # Map top-level colors.
  tb_hlp_top <- dplyr::tibble(name = "caret", rstheme = ".ace_cursor")

  # Adjust ruler color based on theme specification preferences.
  # TextMate themes don't standardize ruler color, so prioritize invisibles,
  # then guide, then gutter for contrast against the background.
  ruler_map <- c("invisibles", "guide", "gutter")
  bg_col <- tmcols[tmcols$section == "colors" & tmcols$name == "background", ]
  tm_sub <- tmcols[tmcols$name %in% ruler_map, ]
  tm_sub <- tm_sub[tm_sub$foreground != bg_col$foreground, ]
  ruler_map <- ensure_null(ruler_map[ruler_map %in% tm_sub$name][1])

  if (!is.null(ruler_map)) {
    tb_hlp_top <- dplyr::bind_rows(
      tb_hlp_top,
      data.frame(name = ruler_map, rstheme = ".ace_print-margin")
    )
  }

  tmcols_top <- dplyr::inner_join(tmcols, tb_hlp_top, by = "name")

  # Add the indent guide.
  if ("guide" %in% tmcols$name) {
    indent_guide <- tmcols[tmcols$name == "guide", ]
    indent_guide$rstheme <- ".ace_indent-guide"

    tmcols_top <- dplyr::bind_rows(tmcols_top, indent_guide[1, ])
  }

  keepvals <- c("rstheme", "foreground", "background", "fontStyle")
  rstheme_top <- tmcols_top[, keepvals]

  # Map `.tmTheme` scopes to ACE editor CSS rules.
  tmcols_scopes <- tmcols[
    !is.na(tmcols$scope),
    c("scope", "foreground", "background", "fontStyle")
  ]

  # Remove empty specifications.
  empty_row <- is.na(tmcols_scopes$foreground) &
    is.na(tmcols_scopes$background) &
    is.na(tmcols_scopes$fontStyle)

  tmcols_scopes <- tmcols_scopes[!empty_row, ]

  # Modify selected scopes for the ACE editor.
  # Convert link-like scopes to href.
  tmcols_scopes[
    grepl(
      "markup[\\S]*link|link[\\S]*markdown",
      tmcols_scopes$scope,
      perl = TRUE
    ),
  ]$scope <- "markup.href"

  # Add an additional markup heading.
  heading <- tmcols_scopes[
    grepl("markup.heading", tmcols_scopes$scope, fixed = TRUE),
  ]
  heading$scope <- "heading"
  tmcols_scopes <- rbind(tmcols_scopes, heading)

  # Normalize meta tag scopes.
  metan <- c("entity.name.tag.html", "meta.tag")
  tmcols_scopes[tmcols_scopes$scope %in% metan, ]$scope <- "meta.tag"

  # Add the XML pseudo-scope.
  xmlpe <- tmcols_scopes[tmcols_scopes$scope == "comment", ]
  xmlpe$scope <- "xml-pe"
  tmcols_scopes <- rbind(tmcols_scopes, xmlpe)

  tmcols_scopes_end <- create_ace_cascade(tmcols_scopes)

  # Apply final adjustments.
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

  new_css <- c("/* CSS rules from the TextMate theme */", "")

  for (cssrule in end_df$rstheme) {
    thisval <- end_df[end_df$rstheme == cssrule, ]
    if (cssrule %in% c(".ace_print-margin")) {
      thisrule <- paste0(cssrule, " {background: ", thisval$foreground, ";}")
      new_css <- c(new_css, thisrule, "")
    } else if (cssrule %in% c(".ace_indent-guide")) {
      thisrule <- paste0(
        ".ace_line .ace_indent-guide { background: linear-gradient(to left, ",
        thisval$foreground,
        " 1px, transparent 1px, transparent); }"
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
        # Skip empty rules.
        next
      }
      specs <- paste0(names(newr_clean), ": ", newr_clean, ";", collapse = " ")
      thisrule <- paste0(cssrule, " {", specs, "}")
      new_css <- c(new_css, thisrule, "")
    }
  }

  # Build ----
  # Create the initial RStudio theme compilation.
  uuid <- generate_uuid()
  tmp <- file.path(tempdir(), uuid)
  dir.create(tmp, recursive = TRUE, showWarnings = FALSE)
  theme_name <- rstudioapi_convert_theme(
    path,
    add = FALSE,
    output_location = tmp,
    force = TRUE
  )

  # Read the generated RStudio theme CSS and append new CSS rules and
  # additional Sass variables.
  tmpfile <- list.files(tmp, full.names = TRUE)
  themelines <- readLines(tmpfile)

  # Replace the theme name if requested.
  if (!is.null(name)) {
    themelines[grepl("rs-theme-name", themelines, fixed = TRUE)] <- paste(
      "/* rs-theme-name:",
      name,
      "*/"
    )

    theme_name <- name
  }

  themelines <- gsub(
    "blur(1px)",
    "brightness(75%)",
    themelines,
    fixed = TRUE
  )

  vtext <- paste0("/* Generated with the rstudiothemes R package */")

  additional <- c("")

  # Map high-level colors to Sass variable names.
  hl_sass <- dplyr::tibble(
    section = "colors",
    name = c("foreground", "background", "caret", "selection"),
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

  # Write the theme.
  sass_sass(
    themelines,
    output = outfile,
    cache = FALSE,
    options = sass_options(output_style = output_style)
  )

  # Install the theme.
  if (any(apply, force)) {
    cli::cli_alert_info("Installing RStudio theme {.val {theme_name}}.")

    capture_log <- tryCatch(
      rstudioapi_add_theme(outfile, force = force),
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
      cli::cli_alert_success("Installed theme {.val {capture_log}}.")
    }
    if (apply) {
      cli::cli_alert_info("Applying theme {.val {theme_name}}.")
      rstudioapi_apply_theme(theme_name)
    }
  }

  outfile
}

# nocov start
rstudioapi_convert_theme <- function(
  path,
  add = FALSE,
  output_location = tempdir(),
  force = TRUE
) {
  rstudioapi::convertTheme(
    path,
    add = add,
    outputLocation = output_location,
    force = force
  )
}

sass_sass <- function(input, output, cache = FALSE, options = sass_options()) {
  sass::sass(input, output = output, cache = cache, options = options)
}

sass_options <- function(output_style = "expanded") {
  sass::sass_options(output_style = output_style)
}
# nocov end

create_ace_cascade <- function(tmcols_scopes) {
  full <- tmcols_scopes
  full <- dplyr::distinct(full, .keep_all = FALSE)

  # Exclude scopes containing spaces (pseudo-CSS).
  full <- full[!grepl(" ", full$scope, fixed = TRUE), ]

  # Classify scopes by hierarchy level.
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

  # Ensure a single value for each scope at level 3.
  lev3 <- more_freq_rule(lev3)

  # Enrich level-2 scopes with color information from level 3.
  lev2_xtra <- lev3

  # Do not inherit fontStyle from level 3.
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

  # Enrich level-1 scopes with color information from level 2.
  lev1_xtra <- lev2_end

  # Do not inherit fontStyle from higher levels.
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
