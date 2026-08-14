#' Convert a Visual Studio Code or Positron theme file to TextMate
#'
#' @description
#' Convert a `.json` file representing a Visual Studio Code or Positron theme
#' and write the equivalent TextMate theme file (`.tmTheme`).
#'
#' @inheritParams read_vs_theme
#' @param outfile Path where the resulting file will be written. Defaults to
#'   a temporary file created with [tempfile()].
#' @param name Theme name. If `NULL`, the name from the input file is used.
#' @param author Theme author. If `NULL`, it attempts to extract the author
#'   from the input file, otherwise it defaults to "rstudiothemes R package".
#'
#' @returns
#' This function is called for its side effects. It writes a `.tmTheme` file to
#' `outfile` and returns the file path.
#'
#' @family converters
#' @encoding UTF-8
#' @rdname convert_vs_to_tm_theme
#' @export
#'
#' @examples
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
      cli::cli_abort("Theme name not found. Use the {.arg name} argument.")
    }
  }

  if (is.null(author)) {
    orig_aut <- unlist(for_top_df[for_top_df$name == "author", ]$value)

    if (length(orig_aut) < 1) {
      cli::cli_alert_warning(paste0(
        "The Visual Studio Code theme {.val {name}} does not list an ",
        "author. Use the {.arg author} argument."
      ))
      author <- "rstudiothemes R package"
      cli::cli_alert_info("Using default {.code author = {.str {author}}}.")
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

  # Write the final theme.
  the_theme <- build_tmtheme_document(toplevel_df, settings_df, scopes_df)
  attr(the_theme$plist, "version") <- "1.0"

  the_theme <- xml2::as_xml_document(the_theme)
  xml2::write_xml(the_theme, outfile)

  outfile
}

#' @description
#' `convert_positron_to_tm_theme()` is an alias of `convert_vs_to_tm_theme()`.
#'
#' @rdname convert_vs_to_tm_theme
#' @export
convert_positron_to_tm_theme <- convert_vs_to_tm_theme

tmtheme_settings_df <- function(vs_df) {
  # Map Visual Studio Code colors to TextMate settings.
  maps <- theme_mapping()

  end <- dplyr::inner_join(
    maps,
    vs_df[vs_df$section == "colors", ],
    by = c("vscode" = "name")
  )

  end <- end[, c("tm", "foreground")]
  colnames(end) <- c("tm", "color")
  end <- dplyr::distinct(end)
  end <- end[!is.na(end$color), ]

  # Keep the first mapped value for each TextMate color.
  end$rank <- seq_len(nrow(end))
  end <- dplyr::grouped_df(end, "tm")
  end <- dplyr::slice_head(end, n = 1)
  end <- dplyr::ungroup(end)
  end <- dplyr::arrange(end, dplyr::pick(dplyr::all_of("rank")))[c(
    "tm",
    "color"
  )]

  # Require the settings needed to derive the remaining defaults.
  check_vals <- c("background", "foreground", "selection") %in% end$tm

  if (!all(check_vals)) {
    miss <- c("background", "foreground", "selection")[!check_vals] # nolint
    cli::cli_abort(c(
      "Cannot convert theme because required colors are missing.",
      "x" = "Missing {length(miss)} setting{?s}: {.val {miss}}.",
      "i" = paste0(
        "Ensure the input theme provides the required colors ",
        "or pass overrides."
      )
    ))
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

  # Collapse equivalent scopes into one line per style group.
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

build_tmtheme_document <- function(toplevel_df, settings_df, scopes_df) {
  top_list <- plist_entries(toplevel_df, "tm", "value")
  settings_list <- plist_entries(settings_df, "tm", "color")
  array_list <- list(dict = list(key = list("settings"), dict = settings_list))

  scope_items <- lapply(seq_len(nrow(scopes_df)), function(i) {
    tmtheme_scope_item(scopes_df[i, ])
  })
  scope_items <- Filter(Negate(is.null), scope_items)
  scope_items <- unlist(scope_items, recursive = FALSE)

  list(
    plist = list(
      dict = c(
        top_list,
        list(key = list("settings"), array = c(array_list, scope_items))
      )
    )
  )
}

plist_entries <- function(df, key_col, value_col) {
  entries <- lapply(seq_len(nrow(df)), function(i) {
    plist_key_string(df[[key_col]][i], df[[value_col]][i])
  })

  unlist(entries, recursive = FALSE)
}

plist_key_string <- function(key, value) {
  list(
    key = list(as.character(key)),
    string = list(as.character(value))
  )
}

tmtheme_scope_item <- function(scope_row) {
  scope_settings <- tmtheme_scope_settings(scope_row)

  if (is.null(scope_settings)) {
    return(NULL)
  }

  name <- as.character(scope_row$name)
  if (length(name) == 0 || is.na(name)) {
    name <- ""
  }

  list(
    dict = c(
      plist_key_string("name", name),
      plist_key_string("scope", scope_row$scope),
      list(key = list("settings"), dict = scope_settings)
    )
  )
}

tmtheme_scope_settings <- function(scope_row) {
  settings <- unlist(
    scope_row[c("foreground", "background", "fontStyle")],
    use.names = TRUE
  )
  settings <- settings[!is.na(settings)]

  if (length(settings) == 0) {
    return(NULL)
  }

  entries <- mapply(
    plist_key_string,
    names(settings),
    unname(settings),
    SIMPLIFY = FALSE,
    USE.NAMES = FALSE
  )

  unlist(entries, recursive = FALSE)
}
