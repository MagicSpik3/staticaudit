test_that("detects get()", {
  code <- "x <- get('a')"
  res <- analyse_code(code)
  expect_equal(res$id, "DYNAMIC_EXECUTION")
})
