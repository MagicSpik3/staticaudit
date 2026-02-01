test_that("analyse_project returns zero smells for clean code", {
  path <- testthat::test_path("..", "fixtures", "simple")
  res <- analyse_project(path)
  # Clean code should have 0 rows
  expect_equal(nrow(res), 0)
})

test_that("detects dynamic execution in bad code", {
  path <- testthat::test_path("..", "fixtures", "bad")
  res <- analyse_project(path)
  # Bad code should have hits
  expect_true(nrow(res) > 0)
  expect_true("DYNAMIC_EXECUTION" %in% res$id)
})

test_that("smells have required columns", {
  path <- testthat::test_path("..", "fixtures", "bad")
  res <- analyse_project(path)
  expect_true(all(
    c("file","line","id","severity","category","message") %in% names(res)
  ))
})