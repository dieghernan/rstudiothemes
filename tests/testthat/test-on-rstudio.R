test_that("Positron sessions are not treated as RStudio", {
  local_mocked_bindings(detect_gui = function() "Positron")

  expect_snapshot(on_rstudio())
})

test_that("RStudio sessions are detected", {
  local_mocked_bindings(detect_gui = function() "RStudio")

  expect_snapshot(on_rstudio())
})


test_that("RTerm sessions are not treated as RStudio", {
  local_mocked_bindings(detect_gui = function() "RTerm")

  expect_snapshot(on_rstudio())
})

test_that("Visual Studio Code sessions are not treated as RStudio", {
  local_mocked_bindings(on_vscode = function() TRUE)

  expect_snapshot(on_rstudio())
})

test_that("TERM_PROGRAM identifies Visual Studio Code", {
  withr::local_envvar(TERM_PROGRAM = "vscode")

  expect_true(on_vscode())
})

test_that("other TERM_PROGRAM values are not Visual Studio Code", {
  withr::local_envvar(TERM_PROGRAM = "RStudio")

  expect_false(on_vscode())
})
