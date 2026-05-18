#' Convert a Visual Studio Code or Positron theme into a TextMate theme
#'
#' @description
#' Convert a `.json` file representing a Visual Studio Code or Positron theme
#' and write the equivalent TextMate theme (`.tmTheme`).
#'
#' @encoding UTF-8
#' @rdname convert_vs_to_tm_theme
#' @inheritParams read_vs_theme
#' @inheritParams convert_vs_to_tm_theme
#'
#' @param outfile Path where the resulting file will be written. By default
#'   a temporary file ([tempfile()]).
#' @param name Optional. The name of the theme. If not provided, the name of
#'   the theme in `path` will be used.
#' @param author Optional. The author of the theme. If not provided, the author
#'   from `path` will be used or a default value will be assigned.
#'
#' @return
#' This function is called for its side effects: it writes a `.tmTheme`
#' file to `outfile` and returns the path.
#'
#' @family functions for creating themes
#'
#' @export
#'
#' @examples
#'
#' vstheme <- system.file("ext/test-simple-color-theme.json",
#'   package = "rstudiothemes"
#' )
#' path <- convert_vs_to_tm_theme(vstheme)
#'
#' readLines(path) |>
#'   head(50) |>
#'   cat(sep = "\n")
#'
convert_vs_to_tm_theme <- function(
  path,
  outfile = tempfile(fileext = ".tmTheme"),
  name = NULL,
  author = NULL
) {
  # Read and parse the Visual Studio Code theme file.
  vs_df <- read_vs_theme(path)

  # Prepare the settings data frame.
  settings_df <- tmtheme_settings_df(vs_df)

  # Prepare the scopes data frame.
  scopes_df <- tmtheme_scopes_df(vs_df)

  # Extract top-level metadata.
  for_top <- vs_df$section %in% c("colors", "highlevel") & !is.na(vs_df$name)
  for_top_df <- vs_df[for_top, ]

  if (is.null(name)) {
    name <- unlist(for_top_df[for_top_df$name == "name", ]$value)
    if (length(name) < 1) {
      cli::cli_abort("Unnamed theme, please use {.arg name} argument.")
    }
  }

  if (is.null(author)) {
    orig_aut <- unlist(for_top_df[for_top_df$name == "author", ]$value)

    if (length(orig_aut) < 1) {
      cli::cli_alert_warning(paste0(
        "VSCode theme {.str {name}} does not have author, ",
        "use the {.arg author} argument."
      ))
      author <- "rstudiothemes R package"
      cli::cli_alert_info("Using {.code author = {.str {author}}}.")
    } else {
      author <- paste0(orig_aut, ", rstudiothemes R package")
    }
  }

  semclass <- dark_or_light(settings_df[settings_df$tm == "background", ]$color)

  semclass <- paste("theme", semclass, name, sep = ".")
  semclass <- tolower(semclass)
  semclass <- gsub(" ", "_", semclass, fixed = TRUE)

  comm <- "Generated with rstudiothemes R package"

  # Generate a UUID from the MD5 hash of the original file.
  md5 <- unname(tools::md5sum(path))
  uuid <- generate_uuid(md5)

  toplevel_df <- dplyr::tibble(
    tm = c(
      "name",
      "author",
      "colorSpaceName",
      "semanticClass",
      "comment",
      "uuid"
    ),
    value = c(name, author, "sRGB", semclass, comm, uuid)
  )

  # Start building the list to convert to tmTheme.
  the_theme <- list(plist = list(dict = list()))

  # Add top-level metadata.
  top_list <- NULL
  for (i in seq_len(nrow(toplevel_df))) {
    this <- toplevel_df[i, ]
    tm <- as.character(this$tm)
    val <- as.character(this$value)
    top_list <- c(top_list, list(key = list(tm), string = list(val)))
  }

  # Create settings.
  settings_list <- NULL

  for (i in seq_len(nrow(settings_df))) {
    this <- settings_df[i, ]
    tm <- as.character(this$tm)
    col <- as.character(this$color)
    settings_list <- c(settings_list, list(key = list(tm), string = list(col)))
  }

  # Prepare the array with these settings.
  array_list <- list(dict = list(key = list("settings"), dict = settings_list))

  # Prepare token color scopes.
  for (i in seq_len(nrow(scopes_df))) {
    this <- as.list(scopes_df[i, ])
    name <- unlist(this$name)

    if (length(name) == 0 || is.na(name)) {
      name <- ""
    }

    scope <- unlist(this$scope)

    onl <- list(
      dict = list(
        key = list("name"),
        string = list(name),
        key = list("scope"),
        string = list(scope),
        key = list("settings"),
        dict = list()
      )
    )

    # Prepare the settings dictionary for this scope.
    mat <- t(scopes_df[i, c("foreground", "background", "fontStyle")])

    set_scope_l <- NULL
    for (f in seq_len(nrow(mat))) {
      val <- mat[f, ]
      if (!is.na(val)) {
        thisset <- list(
          key = list(names(val)),
          string = list(as.character(val))
        )

        set_scope_l <- c(set_scope_l, thisset)
      }
    }

    if (!is.null(set_scope_l)) {
      onl$dict$dict <- set_scope_l
      array_list <- c(array_list, onl)
    }
  }

  end <- c(top_list, list(key = list("settings"), array = array_list))

  # Write the final theme.
  the_theme$plist$dict <- end
  attr(the_theme$plist, "version") <- "1.0"

  the_theme <- xml2::as_xml_document(the_theme)
  xml2::write_xml(the_theme, outfile)

  outfile
}

#' @rdname convert_vs_to_tm_theme
#' @export
#' @description
#' `convert_positron_to_tm_theme()` is an alias of `convert_vs_to_tm_theme()`.
convert_positron_to_tm_theme <- convert_vs_to_tm_theme

tmtheme_settings_df <- function(vs_df) {
  # Mapping.
  maps <- read.csv(
    system.file("csv/mapping.csv", package = "rstudiothemes"),
    na.strings = c("NA", "")
  )

  end <- dplyr::inner_join(
    maps,
    vs_df[vs_df$section == "colors", ],
    by = c("vscode" = "name")
  )

  end <- end[, c("tm", "foreground")]
  colnames(end) <- c("tm", "color")
  end <- dplyr::distinct(end)
  end <- end[!is.na(end$color), ]

  # Avoid duplicates.
  end$rank <- seq_len(nrow(end))
  end <- dplyr::grouped_df(end, "tm")
  end <- dplyr::slice_head(end, n = 1)
  end <- dplyr::ungroup(end)
  end <- dplyr::arrange(end, dplyr::pick(dplyr::all_of("rank")))[c(
    "tm",
    "color"
  )]

  # At minimum, require background, foreground, selection, invisibles,
  # lineHighlight and caret. If any are missing, assign defaults.

  # Check required settings.
  check_vals <- c("background", "foreground", "selection") %in% end$tm

  if (!all(check_vals)) {
    miss <- c("background", "foreground", "selection")[!check_vals] # nolint
    cli::cli_abort(
      "Can't convert theme. No color detected for setting{?/s} {.str {miss}}."
    )
  }

  fg <- as.character(end[end$tm == "foreground", 2])
  sel <- as.character(end[end$tm == "selection", 2])

  if (!"caret" %in% end$tm) {
    df <- dplyr::tibble(tm = "caret", color = fg)

    end <- dplyr::bind_rows(end, df)
  }
  if (!"invisibles" %in% end$tm) {
    df <- dplyr::tibble(tm = "invisibles", color = sel)

    end <- dplyr::bind_rows(end, df)
  }
  if (!"lineHighlight" %in% end$tm) {
    df <- dplyr::tibble(tm = "lineHighlight", color = sel)

    end <- dplyr::bind_rows(end, df)
  }
  if (!"selection" %in% end$tm) {
    df <- dplyr::tibble(tm = "selection", color = sel)

    end <- dplyr::bind_rows(end, df)
  }

  end
}

tmtheme_scopes_df <- function(vs_df) {
  tokens_df <- vs_df[grepl("tokenColor", vs_df$section, ignore.case = TRUE), ]
  if (nrow(tokens_df) == 0) {
    return(tokens_df)
  }
  tokens_df$rank <- seq_len(nrow(tokens_df))

  tokens_df <- tokens_df[!grepl("\\*", tokens_df$scope), ]

  # Prioritize `semanticTokenColors` over other scopes when present.
  if ("semanticTokenColors" %in% tokens_df$section) {
    sem <- tokens_df[tokens_df$section == "semanticTokenColors", ]
    rest <- tokens_df[!tokens_df$section == "semanticTokenColors", ]
    tokens_df <- dplyr::bind_rows(sem, rest)
  }

  tokens_df_g <- dplyr::grouped_df(tokens_df, "scope")
  filled <- tidyr::fill(
    tokens_df_g,
    dplyr::all_of(c("foreground", "background", "fontStyle")),
    .direction = "up"
  )

  # Keep one value per group.
  unique_g <- dplyr::slice_head(filled, n = 1)

  # Sort scopes.
  unique_g <- dplyr::arrange(
    unique_g,
    dplyr::pick(dplyr::all_of(c("name", "scope")))
  )

  # Use one line per scope.
  prepare <- dplyr::grouped_df(
    unique_g,
    c("name", "foreground", "background", "fontStyle")
  )

  # Work around lintr.
  scope <- ""

  # Build the final output.
  eend <- dplyr::summarise(
    prepare,
    scope = paste0(scope, collapse = ", "),
    rank = min(rank),
    .groups = "drop"
  )
  eend$scope <- gsub("\\s+", " ", trimws(eend$scope))

  eend <- dplyr::arrange(eend, dplyr::pick(dplyr::all_of("rank")))[c(
    "name",
    "scope",
    "foreground",
    "background",
    "fontStyle"
  )]

  eend
}
