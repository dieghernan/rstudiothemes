#' Convert a TextMate theme file to Visual Studio Code or Positron
#'
#' @description
#' Convert a `.tmTheme` file representing a TextMate theme and write the
#' equivalent Visual Studio Code theme file (`.json`).
#'
#' @inheritParams read_tm_theme
#' @inheritParams convert_vs_to_tm_theme
#'
#' @returns
#' This function is called for its side effects. It writes a `.json` theme file
#' to `outfile` and returns the path.
#'
#' @family converters
#' @encoding UTF-8
#' @rdname convert_tm_to_vs_theme
#' @export
#'
#' @examples
#' tmtheme <- system.file("ext/test.tmTheme",
#'   package = "rstudiothemes"
#' )
#' path <- convert_tm_to_vs_theme(tmtheme)
#'
#' readLines(path) |>
#'   head(50) |>
#'   cat(sep = "\n")
#'
convert_tm_to_vs_theme <- function(
  path,
  outfile = tempfile(fileext = ".json"),
  name = NULL,
  author = NULL
) {
  theme_db <- read_tm_theme(path)

  # Determine whether the theme is dark or light.
  semclass <- get_table_value(theme_db, "semanticClass")
  type <- ifelse(grepl("dark", semclass, fixed = TRUE), "dark", "light")

  if (is.null(name)) {
    name <- get_table_value(theme_db, "name")
  }

  if (is.null(author)) {
    orig_aut <- get_table_value(theme_db, "author")

    if (is.null(orig_aut)) {
      cli::cli_alert_warning(paste0(
        "The TextMate theme {.val {name}} does not list an author. ",
        "Use the {.arg author} argument."
      ))
      author <- "rstudiothemes R package"
      cli::cli_alert_info("Using default {.code author = {.str {author}}}.")
    } else {
      author <- orig_aut
    }
  }

  # Identify high-contrast themes.
  hc <- any(
    grepl("_hc_", semclass, fixed = TRUE),
    grepl("contrast", name, ignore.case = TRUE)
  )
  if (hc && type == "dark") {
    type <- "hc-black"
  } else if (hc) {
    type <- "hc-light"
  }

  thejson <- list(
    "$schema" = "vscode://schemas/color-theme",
    name = name,
    author = author,
    semanticHighlighting = TRUE,
    type = type
  )

  # Get initial and mapped colors.
  init <- tmtheme_default_vs_colors(theme_db)
  col_l <- tmtheme_mapped_vs_colors(theme_db)

  # Add specific rules for high-contrast themes.
  if (hc) {
    col_l$contrastBorder <- get_table_value(
      theme_db,
      "foreground",
      "foreground"
    )
    col_l$editor.selectionForeground <- get_table_value(
      theme_db,
      "caret",
      "foreground"
    )
  }

  # Blend and sort colors.
  col_end <- tmtheme_vs_colors(init, col_l)
  tok <- tmtheme_vs_token_colors(theme_db, col_l$editor.foreground)

  if (!is.null(tok)) {
    vs_l <- c(thejson, list(tokenColors = tok), list(colors = col_end))
  } else {
    vs_l <- c(thejson, list(colors = col_end))
  }

  jsonlite::write_json(vs_l, path = outfile, auto_unbox = TRUE, pretty = TRUE)
  # Add package attribution comments.
  lns <- readLines(outfile)
  lns <- c(
    lns[1],
    "  // Created with the rstudiothemes R package (c) dieghernan.",
    "  // https://github.com/dieghernan/rstudiothemes",
    lns[-1]
  )

  writeLines(lns, outfile)

  outfile
}

#' @description
#' `convert_tm_to_positron_theme()` is an alias for
#' `convert_tm_to_vs_theme()`.
#'
#' @rdname convert_tm_to_vs_theme
#' @export
convert_tm_to_positron_theme <- convert_tm_to_vs_theme

get_table_value <- function(x, field, feature = "value") {
  ensure_null(x[x$name == field, ][[feature]])
}

get_table_scope <- function(x, scope, feature) {
  has_scope <- x[!is.na(x$scope), ]

  ensure_null(has_scope[has_scope$scope == scope, ][[feature]])
}

tmtheme_default_vs_colors <- function(theme_db) {
  comment <- get_table_scope(theme_db, "comment", "foreground")
  fg <- get_table_value(theme_db, "foreground", "foreground")
  bg <- get_table_value(theme_db, "background", "foreground")
  selection <- get_table_value(theme_db, "selection", "foreground")
  accent <- get_table_value(theme_db, "caret", "foreground")

  additional_cols(bg, fg, comment, selection, accent)
}

tmtheme_mapped_vs_colors <- function(theme_db) {
  mapping <- theme_mapping()

  # Use `editorIndentGuide.background1` instead of the deprecated setting.
  mapping <- mapping[mapping$vscode != "editorIndentGuide.background", ]

  high_level <- theme_db[theme_db$section == "colors", c("name", "foreground")]
  names(high_level) <- c("tm", "color")
  df <- merge(high_level, mapping, by = "tm", all = FALSE)
  high_colors <- df[, c("vscode", "color")]

  col_l <- unlist(high_colors$color)
  names(col_l) <- unlist(high_colors$vscode)
  as.list(col_l)
}

tmtheme_vs_colors <- function(default_colors, mapped_colors) {
  colors <- modifyList(default_colors, mapped_colors)
  colors <- colors[sort(names(colors))]

  colors[lengths(colors) > 0]
}

tmtheme_vs_token_colors <- function(theme_db, foreground) {
  tokencols <- theme_db[
    theme_db$section == "tokenColors",
    c("name", "scope", "foreground", "background", "fontStyle")
  ]

  if (nrow(tokencols) <= 1) {
    return(NULL)
  }

  tokencols$index <- seq_len(nrow(tokencols))
  tok_g <- group_tmtheme_token_colors(tokencols)

  tok <- list()
  tok[[1]] <- list(settings = list(foreground = foreground))

  for (i in seq_len(nrow(tok_g))) {
    token <- tmtheme_vs_token(tok_g[i, ])

    if (!is.null(token)) {
      tok[[i + 1]] <- token
    }
  }

  tok
}

group_tmtheme_token_colors <- function(tokencols) {
  tokencols[is.na(tokencols)] <- "MISSING_VALUE"
  splitted <- split(
    tokencols,
    factor(tokencols$name, levels = unique(tokencols$name))
  )

  grouped <- lapply(splitted, function(df) {
    df <- df[order(df$index), ]
    df2 <- split(df, list(df$name, df$foreground, df$background, df$fontStyle))

    by_style <- lapply(df2, function(other_df) {
      df_end <- unique(other_df[, c(
        "name",
        "foreground",
        "background",
        "fontStyle"
      )])
      df_end$sc <- paste0(other_df$scope, collapse = ", ")
      df_end$minr <- paste0(other_df$index, collapse = ", ")
      df_end
    })

    end_df <- do.call("rbind", by_style)
    end_df[order(end_df$minr), ]
  })

  tok_g <- do.call("rbind", grouped)
  tok_g[tok_g == "MISSING_VALUE"] <- NA
  tok_g
}

tmtheme_vs_token <- function(token_row) {
  settings <- list()

  fg <- unlist(token_row$foreground)
  bg <- unlist(token_row$background)
  fnt <- unlist(token_row$fontStyle)
  if (!is.na(fg)) {
    settings <- c(settings, list(foreground = fg))
  }
  if (!is.na(bg)) {
    settings <- c(settings, list(background = bg))
  }
  if (!is.na(fnt)) {
    settings <- c(settings, list(fontStyle = fnt))
  }
  if (length(settings) == 0) {
    return(NULL)
  }

  scp <- as.character(token_row$sc)
  scp <- trimws(unlist(strsplit(scp, ",")))

  list(name = token_row$name, scope = scp, settings = settings)
}

additional_cols <- function(bg, fg, comment, selection, accent) {
  bgaccent1 <- colorspace::hex(colorspace::mixcolor(
    0.98,
    colorspace::hex2RGB(accent),
    colorspace::hex2RGB(bg)
  ))

  bgaccent2 <- colorspace::hex(colorspace::mixcolor(
    0.80,
    colorspace::hex2RGB(accent),
    colorspace::hex2RGB(bg)
  ))
  bgfg1 <- colorspace::hex(colorspace::mixcolor(
    0.90,
    colorspace::hex2RGB(fg),
    colorspace::hex2RGB(bg)
  ))

  bgfg2 <- colorspace::hex(colorspace::mixcolor(
    0.70,
    colorspace::hex2RGB(fg),
    colorspace::hex2RGB(bg)
  ))

  list(
    # Integrated terminal colors.
    "terminal.background" = bg,
    "terminal.foreground" = fg,
    "terminalCursor.background" = bg,
    "terminalCursor.foreground" = accent,
    "terminal.border" = bgaccent2,

    # Base colors.
    "focusBorder" = accent,
    "foreground" = fg,

    # Button control.
    "button.background" = accent,
    "button.foreground" = bg,
    "button.secondaryBackground" = bgaccent1,
    "button.secondaryForeground" = fg,

    # Dropdown control.
    "dropdown.background" = bgfg1,
    "dropdown.foreground" = fg,

    # Input control.
    "input.background" = bgfg1,
    "input.foreground" = fg,
    "input.placeholderForeground" = comment,

    # Badge.
    "badge.background" = accent,
    "badge.foreground" = bg,

    # Progress bar.
    "progressBar.background" = accent,

    # Lists and trees.
    "list.activeSelectionBackground" = selection,
    "list.activeSelectionForeground" = fg,
    "list.dropBackground" = selection,
    "list.hoverBackground" = selection,
    "list.inactiveSelectionBackground" = bgfg2,
    "list.highlightForeground" = accent,
    "list.focusBackground" = selection,

    # Activity bar.
    "activityBar.activeBackground" = bgaccent2,
    "activityBar.inactiveForeground" = comment,
    "activityBar.foreground" = accent,
    "activityBar.background" = bgaccent1,
    "activityBarBadge.background" = accent,
    "activityBarBadge.foreground" = bg,

    # Side bar.
    "sideBar.background" = bgfg1,
    "sideBar.foreground" = fg,
    "sideBarSectionHeader.background" = bg,
    "sideBarTitle.foreground" = fg,
    "sideBarTitle.background" = bgaccent1,

    # Editor group and tabs.
    "editorGroupHeader.tabsBackground" = bgaccent1,
    "tab.activeBackground" = bgaccent2,
    "tab.activeForeground" = accent,
    "tab.inactiveBackground" = bgfg1,
    "tab.inactiveForeground" = fg,

    # Editor colors.
    "editor.background" = bg,
    "editor.foreground" = fg,
    "editor.lineHighlightBorder" = selection,
    "editor.selectionBackground" = selection,
    "editor.snippetFinalTabstopHighlightBackground" = bg,
    "editor.snippetTabstopHighlightBackground" = bg,
    "editor.snippetTabstopHighlightBorder" = comment,
    "editorBracketHighlight.foreground1" = fg,
    "editorCodeLens.foreground" = comment,
    "editorHoverWidget.background" = bgaccent1,
    "editorHoverWidget.border" = comment,
    "editorLineNumber.foreground" = comment,
    "editorSuggestWidget.foreground" = fg,
    "editorSuggestWidget.background" = bgaccent1,
    "editorSuggestWidget.focusHighlightForeground" = accent,
    "editorSuggestWidget.highlightForeground" = accent,
    "editorSuggestWidget.selectedBackground" = bgaccent1,
    "editorSuggestWidget.selectedIconForeground" = accent,
    "editorWidget.background" = bgaccent1,

    # Peek view colors.
    "peekView.border" = selection,
    "peekViewEditor.background" = bg,
    "peekViewResult.fileForeground" = fg,
    "peekViewResult.lineForeground" = fg,
    "peekViewResult.selectionBackground" = selection,
    "peekViewResult.selectionForeground" = fg,
    "peekViewTitleDescription.foreground" = comment,
    "peekViewTitleLabel.foreground" = fg,

    # Panel colors.
    "panel.background" = bgfg1,
    "panelTitle.activeForeground" = fg,
    "panelTitle.inactiveForeground" = comment,

    # Status bar colors.
    "statusBar.background" = bgaccent2,
    "statusBar.foreground" = fg,
    "statusBar.noFolderForeground" = fg,
    "statusBar.noFolderBackground" = selection,
    "statusBarItem.remoteForeground" = bg,

    # Title bar colors (macOS only).
    "titleBar.activeForeground" = fg,
    "titleBar.activeBackground" = bgaccent1,
    "titleBar.inactiveForeground" = comment,

    # Settings editor.
    "settings.checkboxForeground" = fg,
    "settings.dropdownForeground" = fg,
    "settings.headerForeground" = fg,
    "settings.numberInputForeground" = fg,
    "settings.textInputForeground" = fg,

    # Breadcrumbs.
    "breadcrumb.activeSelectionForeground" = fg,
    "breadcrumb.background" = bgfg1,
    "breadcrumb.focusForeground" = fg,
    "breadcrumb.foreground" = comment,

    # Miscellaneous.
    "gitDecoration.ignoredResourceForeground" = comment,
    "scrollbarSlider.background" = bgaccent2,
    "scrollbarSlider.activeBackground" = bgfg2,
    "icon.foreground" = accent,
    "menu.background" = bgaccent1,
    "menu.foreground" = fg,
    "menu.separatorBackground" = bgaccent2,
    "menubar.selectionBackground" = selection,
    "menu.selectionBackground" = selection,
    "notifications.background" = bgaccent1,
    "notificationLink.foreground" = accent,
    "editorLink.activeForeground" = accent,
    "keybindingLabel.foreground" = fg,
    "keybindingLabel.background" = bg,
    "pickerGroup.foreground" = accent,
    "pickerGroup.border" = bgaccent1,
    "textLink.foreground" = accent
  )
}
