#' Random UUIDs generation
#'
#' Generate Universally Unique Identifiers (UUID) version 4 (pseudo-random
#' numbers).
#'
#' @family helpers
#'
#' @param hint Optional. Character (or object coercible with [as.character()])
#'   that may be used as random seed.
#'
#' @return
#' A [character()] representing valid UUID that can be validated with
#' `uuid::UUIDvalidate()`.
#'
#' @details
#' This is a helper function that assign
#' [UUID](https://www.rfc-editor.org/rfc/rfc9562.html) for identifying versions
#' of the generated themes.
#'
#' @source Heavily based on unreleased version of `ids::uuid()`.
#'
#' @references
#' Davis KR, Peabody B, Leach P (2024). "Universally Unique
#' IDentifiers (UUIDs)." RFC 9562. \doi{10.17487/RFC9562},
#' <https://www.rfc-editor.org/info/rfc9562>.
#'
#' @examples
#' # Random
#' generate_uuid()
#'
#' generate_uuid()
#'
#' # Persistent with hint param
#'
#' hint <- "something as seed"
#'
#' generate_uuid(hint)
#'
#' generate_uuid(hint)
#'
#' @export
generate_uuid <- function(hint = NULL) {
  if (!is.null(hint)) {
    hint_n <- paste(rep(as.character(hint), 16), collapse = " ")
    raw_n <- charToRaw(hint_n)[seq_len(16)]
  } else {
    raw_n <- as.raw(sample.int(256L, 16, replace = TRUE) - 1L)
  }

  #  From ids::uuid() (dev version)
  bytes <- matrix(raw_n, 16, 1)

  ## (a) set the high nibble of the 7th byte equal to 4 and
  bytes[7, ] <- as.raw(0x40) | (bytes[7, ] & as.raw(0xf))
  ## (b) set the two most significant bits of the 9th byte to 10'B,
  ##     so the high nibble will be one of {8,9,a,b}.
  bytes[9, ] <- as.raw(0x80) | (bytes[9, ] & as.raw(0x3f))

  a <- apply(bytes[1:4, , drop = FALSE], 2, paste, collapse = "")
  b <- apply(bytes[5:6, , drop = FALSE], 2, paste, collapse = "")
  c <- apply(bytes[7:8, , drop = FALSE], 2, paste, collapse = "")
  d <- apply(bytes[9:10, , drop = FALSE], 2, paste, collapse = "")
  e <- apply(bytes[11:16, , drop = FALSE], 2, paste, collapse = "")

  #  Result
  paste(a, b, c, d, e, sep = "-")
}
