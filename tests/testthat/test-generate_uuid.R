test_that("Random seed", {
  skip_if_not_installed("uuid")

  a <- generate_uuid()
  b <- generate_uuid()

  expect_true(uuid::UUIDvalidate(a))
  expect_true(uuid::UUIDvalidate(b))

  expect_false(identical(a, b))
})


test_that("Fixed seed", {
  skip_if_not_installed("uuid")

  hint <- "seed"
  a <- generate_uuid(hint)
  b <- generate_uuid(hint)

  expect_true(uuid::UUIDvalidate(a))
  expect_true(uuid::UUIDvalidate(b))

  expect_identical(a, b)
})
