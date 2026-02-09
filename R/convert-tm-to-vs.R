#' Convert a TextMate theme into a Visual Studio Code/Positron theme
#'
#' @description
#' Read a `.tmTheme` file representing a TextMate theme and write the
#' equivalent Visual Studio Code theme (`.json`).
#'
#' @inheritParams read_tm_theme
#' @inheritParams convert_vs_to_tm_theme
#'
#' @returns
#' This function is called for its side effects. It writes a new `.json`
#' file in `outfile` and returns the path.
#'
#' @family functions for creating themes
#'
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

  # Determine dark or light theme
  semclass <- get_table_value(theme_db, "semanticClass")
  type <- ifelse(grepl("dark", semclass, fixed = TRUE), "dark", "light")

  if (is.null(name)) {
    name <- get_table_value(theme_db, "name")
  }

  if (is.null(author)) {
    orig_aut <- get_table_value(theme_db, "author")

    if (is.null(orig_aut)) {
      cli::cli_alert_warning(
        paste0(
          "tmTheme theme {.str {name}} does not have author, ",
          "use the {.arg author} argument."
        )
      )
      author <- "rstudiothemes R package"
      cli::cli_alert_info("Using {.code author = {.str {author}}}.")
    } else {
      author <- orig_aut
    }
  }

  # Identify high-contrast theme
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
    name = name,
    author = author,
    semanticHighlighting = TRUE,
    type = type
  )

  # Get initial colors
  comment <- get_table_scope(theme_db, "comment", "foreground")
  fg <- get_table_value(theme_db, "foreground", "foreground")
  bg <- get_table_value(theme_db, "background", "foreground")
  selection <- get_table_value(theme_db, "selection", "foreground")
  accent <- get_table_value(theme_db, "caret", "foreground")
  init <- additional_cols(bg, fg, comment, selection, accent)

  # Add mapping

  # Based on
  # https://github.com/microsoft/vscode-generator-code/blob/main/generators/ ...
  # /app/generate-colortheme.js

  mapping <- read.csv(system.file("csv/mapping.csv", package = "rstudiothemes"))

  high_level <- theme_db[theme_db$section == "colors", c("name", "foreground")]
  names(high_level) <- c("tm", "color")
  df <- merge(high_level, mapping, by = "tm", all = FALSE)

  # All high-level colors are now available
  high_colors <- df[, c("vscode", "color")]

  col_l <- unlist(high_colors$color)
  names(col_l) <- unlist(high_colors$vscode)
  col_l <- as.list(col_l)

  # If high-contrast, add specific rules

  if (hc) {
    col_l$contrastBorder <- fg
    col_l$editor.selectionForeground <- accent
  }

  # Blend and sort colors
  col_end <- modifyList(init, col_l)
  col_end <- col_end[sort(names(col_end))]

  # Remove nulls
  col_end <- col_end[lengths(col_end) > 0]

  # Token colors
  tokencols <- theme_db[
    theme_db$section == "tokenColors",
    c("name", "scope", "foreground", "background", "fontStyle")
  ]

  if (nrow(tokencols) > 1) {
    tokencols$index <- seq_len(nrow(tokencols))

    # Split and group items with the same variables (by section)

    # Group by name and arrange
    tokencols[is.na(tokencols)] <- "MISSING_VALUE"
    splitted <- split(
      tokencols,
      factor(tokencols$name, levels = unique(tokencols$name))
    )
    pp <- lapply(splitted, nrow) |>
      unlist() |>
      sort()
    pp
    df <- splitted[[
      "Keyword Operator Comparison, imports, returns and Keyword Operator Ruby"
    ]]
    res2 <- lapply(splitted, function(df) {
      df <- df[order(df$index), ]

      df2 <- split(
        df,
        list(df$name, df$foreground, df$background, df$fontStyle)
      )

      res <- lapply(df2, function(other_df) {
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

      end_df <- do.call("rbind", res)
      end_df[order(end_df$minr), ]
    })

    tok_g <- do.call("rbind", res2)

    tok_g[tok_g == "MISSING_VALUE"] <- NA

    # Build token list

    tok <- list()
    # Create list for tokens
    tok[[1]] <- list(
      settings = list(
        background = col_l$editor.background,
        foreground = col_l$editor.foreground
      )
    )

    ntok <- seq_len(nrow(tok_g))

    for (i in ntok) {
      thiscope <- tok_g[i, ]
      scp <- as.character(thiscope$sc)
      scp <- trimws(unlist(strsplit(scp, ",")))

      thistok <- list(
        name = thiscope$name,
        scope = scp,
        settings = list()
      )

      dictt <- list()

      fg <- unlist(thiscope$foreground)
      bg <- unlist(thiscope$background)
      fnt <- unlist(thiscope$fontStyle)
      if (!is.na(fg)) {
        dictt <- c(dictt, list(foreground = fg))
      }
      if (!is.na(bg)) {
        dictt <- c(dictt, list(background = bg))
      }
      if (!is.na(fnt)) {
        dictt <- c(dictt, list(fontStyle = fnt))
      }
      if (length(dictt) > 0) {
        thistok$settings <- dictt

        tok[[i + 1]] <- thistok
      }
    }

    vs_l <- c(thejson, list(tokenColors = tok), list(colors = col_end))
  } else {
    vs_l <- c(thejson, list(colors = col_end))
  }

  jsonlite::write_json(vs_l, path = outfile, auto_unbox = TRUE, pretty = TRUE)
  # Add a comment with package information
  lns <- readLines(outfile)
  lns <- c(
    lns[1],
    "  // Created with the R package rstudiothemes (c) dieghernan.",
    "  // https://github.com/dieghernan/rstudiothemes",
    lns[-1]
  )

  writeLines(lns, outfile)

  outfile
}

get_table_value <- function(x, field, feature = "value") {
  ensure_null(x[x$name == field, ][[feature]])
}

get_table_scope <- function(x, scope, feature) {
  has_scope <- x[!is.na(x$scope), ]

  ensure_null(has_scope[has_scope$scope == scope, ][[feature]])
}


additional_cols <- function(bg, fg, comment, selection, accent) {
  bgaccent1 <- colorspace::hex(
    colorspace::mixcolor(
      0.98,
      colorspace::hex2RGB(accent),
      colorspace::hex2RGB(bg)
    )
  )

  bgaccent2 <- colorspace::hex(
    colorspace::mixcolor(
      0.80,
      colorspace::hex2RGB(accent),
      colorspace::hex2RGB(bg)
    )
  )
  bgfg1 <- colorspace::hex(
    colorspace::mixcolor(
      0.90,
      colorspace::hex2RGB(fg),
      colorspace::hex2RGB(bg)
    )
  )

  bgfg2 <- colorspace::hex(
    colorspace::mixcolor(
      0.70,
      colorspace::hex2RGB(fg),
      colorspace::hex2RGB(bg)
    )
  )

  list(
    # Integrated Terminal Colors
    "terminal.background" = bg,
    "terminal.foreground" = fg,
    "terminal.cursor" = accent,
    "terminalCursor.background" = bg,
    "terminalCursor.foreground" = accent,
    "terminal.border" = bgaccent2,

    # Base Colors
    "focusBorder" = accent,
    "foreground" = fg,

    # Button Control
    "button.background" = accent,
    "button.foreground" = bg,
    "button.secondaryBackground" = bgaccent1,
    "button.secondaryForeground" = fg,

    # Dropdown Control
    "dropdown.background" = bgfg1,
    "dropdown.foreground" = fg,

    # Input Control
    "input.background" = bgfg1,
    "input.foreground" = fg,
    "input.placeholderForeground" = comment,

    # Badge
    "badge.background" = accent,
    "badge.foreground" = bg,

    # Progress Bar
    "progressBar.background" = accent,

    # List and Trees
    "list.activeSelectionBackground" = selection,
    "list.activeSelectionForeground" = fg,
    "list.dropBackground" = selection,
    "list.hoverBackground" = selection,
    "list.inactiveSelectionBackground" = bgfg2,
    "list.highlightForeground" = accent,
    "list.focusBackground" = selection,

    # Activity Bar

    "activityBar.activeBackground" = bgaccent2,
    "activityBar.inactiveForeground" = comment,
    "activityBar.foreground" = accent,
    "activityBar.background" = bgaccent1,
    "activityBarBadge.background" = accent,
    "activityBarBadge.foreground" = bg,

    # Side Bar
    "sideBar.background" = bgfg1,
    "sideBar.foreground" = fg,
    "sideBarSectionHeader.background" = bg,
    "sideBarTitle.foreground" = fg,
    "sideBarTitle.background" = bgaccent1,

    # Editor Group & Tabs
    "editorGroupHeader.tabsBackground" = bgaccent1,
    "tab.activeBackground" = bgaccent2,
    "tab.activeForeground" = accent,
    "tab.inactiveBackground" = bgfg1,
    "tab.inactiveForeground" = fg,

    # Editor Colors
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

    # Peek View Colors
    "peekView.border" = selection,
    "peekViewEditor.background" = bg,
    "peekViewResult.fileForeground" = fg,
    "peekViewResult.lineForeground" = fg,
    "peekViewResult.selectionBackground" = selection,
    "peekViewResult.selectionForeground" = fg,
    "peekViewTitleDescription.foreground" = comment,
    "peekViewTitleLabel.foreground" = fg,

    # Panel Colors

    "panel.background" = bgfg1,
    "panelTitle.activeForeground" = fg,
    "panelTitle.inactiveForeground" = comment,

    # Status Bar Colors
    "statusBar.background" = bgaccent2,
    "statusBar.foreground" = fg,
    "statusBar.noFolderForeground" = fg,
    "statusBar.noFolderBackground" = selection,
    "statusBarItem.remoteForeground" = bg,

    # Title Bar Colors (MacOS Only)
    "titleBar.activeForeground" = fg,
    "titleBar.activeBackground" = bgaccent1,
    "titleBar.inactiveForeground" = comment,

    # Setting Editor
    "settings.checkboxForeground" = fg,
    "settings.dropdownForeground" = fg,
    "settings.headerForeground" = fg,
    "settings.numberInputForeground" = fg,
    "settings.textInputForeground" = fg,

    # Breadcrumbs

    "breadcrumb.activeSelectionForeground" = fg,
    "breadcrumb.background" = bgfg1,
    "breadcrumb.focusForeground" = fg,
    "breadcrumb.foreground" = comment,

    # Misc
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
