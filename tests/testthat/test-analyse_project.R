test_that("analyse_project returns smells", {
  res <- analyse_project("tests/fixtures/simple")
  expect_true(nrow(res) > 0)
})
