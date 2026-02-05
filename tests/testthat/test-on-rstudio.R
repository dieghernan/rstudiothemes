test_that("Positron", {
  local_mocked_bindings(detect_gui = function() "Positron")

  expect_snapshot(on_rstudio())
})

test_that("RStudio", {
  local_mocked_bindings(detect_gui = function() "RStudio")

  expect_snapshot(on_rstudio())
})


test_that("RTerm", {
  local_mocked_bindings(detect_gui = function() "RTerm")

  expect_snapshot(on_rstudio())
})

test_that("VS Code", {
  local_mocked_bindings(on_vscode = function() TRUE)

  expect_snapshot(on_rstudio())
})

test_that("VS Code logic", {
  expect_identical(Sys.getenv("TERM_PROGRAM") == "vscode", on_vscode())
})
