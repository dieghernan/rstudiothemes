#' Generate random UUIDs
#'
#' @description
#' Generate version 4 pseudo-random Universally Unique Identifiers (UUIDs).
#'
#' @details
#' This helper generates a [UUID][uuid::UUIDvalidate()] for identifying
#' generated theme versions.
#'
#' @param hint Optional character string or object coercible with
#'   [as.character()]. Used as a random seed.
#'
#' @return
#' A character string representing a valid UUID that can be validated with
#' [uuid::UUIDvalidate()].
#'
#' @family helpers
#'
#' @source Heavily based on an unreleased version of `ids::uuid()`.
#' @references
#' Davis KR, Peabody B and Leach P (2024). "Universally Unique Identifiers
#' (UUIDs)." RFC 9562. \doi{10.17487/RFC9562},
#' <https://www.rfc-editor.org/info/rfc9562>.
#'
#' @encoding UTF-8
#' @export
#'
#' @examples
#' # Random UUID.
#' generate_uuid()
#'
#' generate_uuid()
#'
#' # Persistent UUID with `hint`.
#' hint <- "something as seed"
#'
#' generate_uuid(hint)
#'
#' generate_uuid(hint)
generate_uuid <- function(hint = NULL) {
  if (!is.null(hint)) {
    hint_n <- paste(rep(as.character(hint), 16), collapse = " ")
    raw_n <- charToRaw(hint_n)[seq_len(16)]
  } else {
    raw_n <- as.raw(sample.int(256L, 16, replace = TRUE) - 1L)
  }

  # Adapted from ids::uuid() (development version).
  bytes <- matrix(raw_n, 16, 1)

  ## Set the high nibble of the 7th byte to 4.
  bytes[7, ] <- as.raw(0x40) | (bytes[7, ] & as.raw(0xf))
  ## Set the two most significant bits of the 9th byte to 10'B, so the high
  ## nibble is one of {8, 9, a, b}.
  bytes[9, ] <- as.raw(0x80) | (bytes[9, ] & as.raw(0x3f))

  a <- apply(bytes[1:4, , drop = FALSE], 2, paste, collapse = "")
  b <- apply(bytes[5:6, , drop = FALSE], 2, paste, collapse = "")
  c <- apply(bytes[7:8, , drop = FALSE], 2, paste, collapse = "")
  d <- apply(bytes[9:10, , drop = FALSE], 2, paste, collapse = "")
  e <- apply(bytes[11:16, , drop = FALSE], 2, paste, collapse = "")

  # Return the UUID.
  paste(a, b, c, d, e, sep = "-")
}
