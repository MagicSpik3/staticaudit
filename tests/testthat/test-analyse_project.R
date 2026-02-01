test_that("analyse_project returns smells", {
  res <- analyse_project("tests/fixtures/simple")
  expect_true(nrow(res) > 0)
})
test_that("detects dynamic execution", {
  res <- analyse_project("tests/fixtures/bad")
  expect_true("DYNAMIC_EXECUTION" %in% res$id)
})
test_that("smells have required columns", {
  res <- analyse_project("tests/fixtures/bad")
  expect_true(all(
    c("file","line","id","severity","category","message") %in% names(res)
  ))
})
