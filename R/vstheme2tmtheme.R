#' Convert a Visual Studio Code theme into a TextMate theme
#'
#' @description
#' Read a `*.json` file representing a Visual Studio Code theme and write
#' the equivalent TextMate theme (`*.tmTheme`).
#'
#'
#' @inheritParams read_vstheme
#' @param out_file Path were the resulting file would be written. By default
#'   is a temporal file ([tempfile()]).
#' @param name Optional. The name of the theme. If nor provided the name of
#'   the `vstheme` would be used.
#' @param author Optional. The author of the theme. If nor provided the name of
#'   the `vstheme` would be used.
#'
#' @returns
#' This function is called for its side effects. It would return (as
#' [invisible()]) the path of the file.
#'
#' @family converters
#'
#' @export
#'
#' @examples
#'
#' vstheme <- system.file("ext/test-simple-color-theme.json",
#'   package = "rstudiothemes"
#' )
#' path <- vstheme2tmtheme(vstheme)
#'
#' path
#'
#' readLines(path) |>
#'   head(50) |>
#'   cat(sep = "\n")
#'
vstheme2tmtheme <- function(vstheme,
                            out_file = tempfile(fileext = ".tmTheme"),
                            name = NULL, author = NULL) {
  # 1. Manipulate vstheme file
  vs_df <- read_vstheme(vstheme)

  # 2. Prepare df for settings
  settings_df <- tmtheme_settings_df(vs_df)

  # 3. Prepare df for scopes
  scopes_df <- tmtheme_scopes_df(vs_df)

  # 4. Top level
  for_top <- vs_df$section %in% c("colors", "highlevel") & !is.na(vs_df$name)
  for_top_df <- vs_df[for_top, ]

  if (is.null(name)) {
    name <- unlist(for_top_df[for_top_df$name == "name", ]$value)
  }


  if (is.null(author)) {
    orig_aut <- unlist(for_top_df[for_top_df$name == "author", ]$value)

    if (length(orig_aut) < 1) {
      message(
        "This vscode theme does not have author, ",
        "use the `author` parameter"
      )
      author <- "rstudiothemes R package"
    } else {
      author <- paste0(orig_aut, ", rstudiothemes R package")
    }
  }

  semclass <- dark_or_light(settings_df[settings_df$tm == "background", ]$color)

  semclass <- paste("theme", semclass, name, sep = ".")
  semclass <- tolower(semclass)
  semclass <- gsub(" ", "_", semclass)

  comm <- "Generated with rstudiothemes R package"

  # Generate uuid from md5 of the original file
  md5 <- unname(tools::md5sum(vstheme))
  uuid <- generate_uuid(md5)

  toplevel_df <- dplyr::tibble(
    tm = c(
      "name", "author", "colorSpaceName", "semanticClass",
      "comment", "uuid"
    ),
    value = c(name, author, "sRGB", semclass, comm, uuid)
  )

  # Start building the list that would be converted to tmTheme
  the_theme <- list(plist = list(
    dict = list()
  ))

  # Top level

  top_list <- NULL
  for (i in seq_len(nrow(toplevel_df))) {
    this <- toplevel_df[i, ]
    tm <- as.character(this$tm)
    val <- as.character(this$value)
    top_list <- c(top_list, list(key = list(tm), string = list(val)))
  }

  # Create settings
  settings_list <- NULL

  for (i in seq_len(nrow(settings_df))) {
    this <- settings_df[i, ]
    tm <- as.character(this$tm)
    col <- as.character(this$color)
    settings_list <- c(settings_list, list(key = list(tm), string = list(col)))
  }

  # Prepare the array with these setting
  array_list <- list(dict = list(key = list("settings"), dict = settings_list))

  # Prepare scopes
  for (i in seq_len(nrow(scopes_df))) {
    this <- as.list(scopes_df[i, ])
    name <- unlist(this$name)

    if (length(name) == 0 || is.na(name)) {
      name <- ""
    }

    scope <- unlist(this$scope)

    onl <- list(dict = list(
      key = list("name"), string = list(name),
      key = list("scope"), string = list(scope),
      key = list("settings"), dict = list()
    ))

    # Prepare settings dictionary
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


  end <- c(
    top_list,
    list(key = list("settings"), array = array_list)
  )


  # Finally write it
  the_theme$plist$dict <- end
  attr(the_theme$plist, "version") <- "1.0"


  the_theme <- xml2::as_xml_document(the_theme)
  xml2::write_xml(the_theme, out_file)

  invisible(out_file)
}

tmtheme_settings_df <- function(vs_df) {
  # Mapping
  maps <- mapping_db

  end <- dplyr::inner_join(maps, vs_df[vs_df$section == "colors", ],
    by = c("vscode" = "name")
  )

  end <- end[, c("tm", "foreground")]
  colnames(end) <- c("tm", "color")
  end <- dplyr::distinct(end)
  end <- end[!is.na(end$color), ]

  # Avoid duplicates
  end$rank <- seq_len(nrow(end))
  end <- dplyr::grouped_df(end, "tm")
  end <- dplyr::slice_head(end, n = 1)
  end <- dplyr::ungroup(end)
  end <- end[order(end$rank), c("tm", "color")]

  # As a bare minimum we should have:
  # background, foreground, selection, invisibles,lineHighlight, caret.
  # If not assing colors

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
  tokens_df$rank <- seq_len(nrow(tokens_df))

  tokens_df <- tokens_df[!grepl("\\*", tokens_df$scope), ]

  # If has semanticTokenColors this has priority over other scopes
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



  # unique by group
  unique_g <- dplyr::slice_head(filled, n = 1)

  # Sort scopes
  unique_g <- unique_g[order(unique_g$name, unique_g$scope), ]


  # One line for scope
  prepare <- dplyr::grouped_df(
    unique_g,
    c("name", "foreground", "background", "fontStyle")
  )

  # Trick lintr
  scope <- ""

  # And go
  eend <- dplyr::summarise(prepare,
    scope = paste0(scope, collapse = ", "),
    rank = min(rank), .groups = "drop"
  )
  eend$scope <- stringr::str_squish(eend$scope)



  eend <- eend[
    order(eend$rank),
    c("name", "scope", "foreground", "background", "fontStyle")
  ]



  eend
}
