test_that("generate_uuid() returns distinct valid UUIDs without a hint", {
  skip_if_not_installed("uuid")

  a <- generate_uuid()
  b <- generate_uuid()

  expect_match(
    a,
    "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$",
    ignore.case = TRUE
  )
  expect_match(
    b,
    "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$",
    ignore.case = TRUE
  )

  expect_false(identical(a, b))
})

test_that("generate_uuid() returns stable valid UUIDs for the same hint", {
  skip_if_not_installed("uuid")

  hint <- "seed"
  a <- generate_uuid(hint)
  b <- generate_uuid(hint)

  expect_match(
    a,
    "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$",
    ignore.case = TRUE
  )
  expect_match(
    b,
    "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$",
    ignore.case = TRUE
  )

  expect_identical(a, b)
})
