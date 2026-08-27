test_that("random UUIDs are distinct and conform to RFC 9562 version 4", {
  a <- generate_uuid()
  b <- generate_uuid()

  expect_match(
    a,
    paste0(
      "^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-",
      "[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
    ),
    ignore.case = TRUE
  )
  expect_match(
    b,
    paste0(
      "^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-",
      "[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
    ),
    ignore.case = TRUE
  )

  expect_length(unique(c(a, b)), 2L)
})

test_that("hinted UUIDs are stable, distinct and conform to version 4", {
  hint <- "seed"
  a <- generate_uuid(hint)
  b <- generate_uuid(hint)
  other <- generate_uuid("other seed")

  expect_match(
    a,
    paste0(
      "^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-",
      "[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
    ),
    ignore.case = TRUE
  )

  expect_identical(a, b)
  expect_length(unique(c(a, other)), 2L)
})
