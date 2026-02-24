test_that("detects hard-coded column symbols in selection contexts", {
  path <- testthat::test_path("..", "fixtures", "bad")
  res <- analyse_project(path)
  expect_true(nrow(res) > 0)
  expect_true("HARDCODED_COLUMN" %in% res$id)
})
