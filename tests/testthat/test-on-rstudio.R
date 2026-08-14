test_that("on_rstudio() returns FALSE in Positron", {
  local_mocked_bindings(detect_gui = function() "Positron")

  expect_snapshot(on_rstudio())
})

test_that("on_rstudio() returns TRUE in RStudio", {
  local_mocked_bindings(detect_gui = function() "RStudio")

  expect_snapshot(on_rstudio())
})


test_that("on_rstudio() returns FALSE in RTerm", {
  local_mocked_bindings(detect_gui = function() "RTerm")

  expect_snapshot(on_rstudio())
})

test_that("on_rstudio() treats VS Code sessions as non-RStudio", {
  local_mocked_bindings(on_vscode = function() TRUE)

  expect_snapshot(on_rstudio())
})

test_that("on_vscode() detects VS Code from TERM_PROGRAM", {
  expect_identical(Sys.getenv("TERM_PROGRAM") == "vscode", on_vscode())
})
