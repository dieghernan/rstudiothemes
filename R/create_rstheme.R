create_rstheme <- function(input_theme,
                           out_rs = tempfile(fileext = ".rstheme"),
                           use_italics = TRUE,
                           themed_ide = TRUE,
                           output_style = "expanded",
                           force = FALSE, apply = FALSE) {
  tmcols <- read_tmtheme(input_theme)
  # Top level cols
  tb_hlp_top <- dplyr::tibble(
    name = c("caret", "invisibles"),
    rstheme = c(".ace_cursor", ".ace_print-margin")
  )

  tmcols_top <- dplyr::inner_join(tmcols, tb_hlp_top, by = "name")
  keepvals <- c("rstheme", "foreground", "background", "fontStyle")
  rstheme_top <- tmcols_top[, keepvals]


  # Map tmTheme scopes to ace_editor (css) rules
  tmcols_scopes <- tmcols[
    !is.na(tmcols$scope),
    c("scope", "foreground", "background", "fontStyle")
  ]

  # Clear empty specs
  empty_row <- is.na(tmcols_scopes$foreground) &
    is.na(tmcols_scopes$background) &
    is.na(tmcols_scopes$fontStyle)

  tmcols_scopes <- tmcols_scopes[!empty_row, ]

  # Modify some scopes for adapting to ace_editor
  ## *.link to href

  tmcols_scopes[
    grepl("markup[\\S]*link|link[\\S]*markdown",
      tmcols_scopes$scope,
      perl = TRUE
    ),
  ]$scope <- "markup.href"

  ## Additonal markup heading
  heading <- tmcols_scopes[
    grepl("markup.heading",
      tmcols_scopes$scope,
      fixed = TRUE
    ),
  ]
  heading$scope <- "heading"
  tmcols_scopes <- rbind(tmcols_scopes, heading)

  ## Meta tags
  metan <- c("entity.name.tag.html", "meta.tag")
  tmcols_scopes[tmcols_scopes$scope %in% metan, ]$scope <- "meta.tag"

  # Additional by xml
  xmlpe <- tmcols_scopes[tmcols_scopes$scope == "comment", ]
  xmlpe$scope <- "xml-pe"
  tmcols_scopes <- rbind(tmcols_scopes, xmlpe)

  tmcols_scopes_end <- create_ace_cascade(tmcols_scopes)

  # Final touch
  end_df <- dplyr::bind_rows(rstheme_top, tmcols_scopes_end)


  end_df$fontweight <- ifelse(
    grepl("bold", end_df$fontStyle, ignore.case = TRUE), "bold", NA
  )

  if (use_italics) {
    end_df$fontstyle <- ifelse(
      grepl("italic", end_df$fontStyle,
        ignore.case = TRUE
      ),
      "italic", NA
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
        thisval$foreground, ";}"
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
      if (length(newr_clean) == 0) next # Empty model
      specs <- paste0(names(newr_clean), ": ", newr_clean, ";", collapse = " ")
      thisrule <- paste0(cssrule, " {", specs, "}")
      new_css <- c(new_css, thisrule, "")
    }
  }

  ## Build ----

  # Create a first compilation
  uuid <- generate_uuid()
  tmp <- file.path(tempdir(), uuid)
  dir.create(tmp)
  rstudioapi::convertTheme(input_theme,
    add = FALSE, outputLocation = tmp,
    force = TRUE
  )


  # Read the lines of the auto-generated rstheme (is a css)
  # and add new css rules and extra cols
  tmpfile <- list.files(tmp, full.names = TRUE)
  themelines <- readLines(tmpfile)
  themelines <- gsub("blur(1px)", "brightness(75%)", themelines)

  vtext <- paste0(
    "/* Generated with rstudiothemes package (",
    packageVersion("rstudiothemes"), ") */"
  )

  additional <- c("")
  if (themed_ide) {
    hl_sass <- dplyr::tibble(
      section = "colors",
      name = c(
        "foreground", "background",
        "caret", "selection"
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
      readLines(system.file("scss/_themed_ide.scss",
        package = "rstudiothemes"
      ))
    )
  }

  themelines <- c(themelines, vtext, "", new_css, additional)


  # Write
  sass::sass(themelines,
    output = out_rs,
    cache = FALSE,
    options = sass::sass_options(output_style = output_style)
  )

  # Install
  rstudioapi::addTheme(out_rs, apply = apply, force = force)
  unlink(tmp)
  return(invisible(out_rs))
}

create_ace_cascade <- function(tmcols_scopes) {
  full <- tmcols_scopes
  full <- dplyr::distinct(full, .keep_all = FALSE)

  # Don't want scopes with spaces - pseudo css
  full <- full[!grepl(" ", full$scope), ]


  # Workout levels

  level <- vapply(full$scope, function(x) {
    ll <- gregexpr(".", x, fixed = TRUE)
    if (-1 %in% ll) {
      return(1)
    }

    length(unlist(ll)) + 1
  }, FUN.VALUE = numeric(1))

  level <- unname(level)


  lev3 <- full[level == 3, ]
  lev2 <- full[level == 2, ]
  lev1 <- full[level == 1, ]

  # Ensure single value for scope
  lev3 <- more_freq_rule(lev3)


  # Enrich lev2 with this info

  lev2_xtra <- lev3

  # Limit fontStyle inheritance
  lev2_xtra$fontStyle <- NA

  lev2_xtra$scope <- vapply(lev3$scope, function(x) {
    l <- unlist(strsplit(x, split = ".", fixed = TRUE))

    paste0(l[seq_len(2)], collapse = ".")
  }, FUN.VALUE = character(1))

  lev2_xtra <- more_freq_rule(lev2_xtra)


  lev2_end <- dplyr::bind_rows(
    lev2,
    lev2_xtra[!lev2_xtra$scope %in% lev2$scope, ]
  )

  lev2_end <- more_freq_rule(lev2_end)
  # Enrich lev1 with this info


  lev1_xtra <- lev2_end

  # Limit fontStyle inheritance
  lev1_xtra$fontStyle <- NA

  lev1_xtra$scope <- vapply(lev2_end$scope, function(x) {
    l <- unlist(strsplit(x, split = ".", fixed = TRUE))

    l[1]
  }, FUN.VALUE = character(1))
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
  final_ace$rstheme <- paste0(".ace_", gsub(".", ".ace_",
    final_ace$scope,
    fixed = TRUE
  ))
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
