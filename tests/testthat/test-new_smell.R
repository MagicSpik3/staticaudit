test_that("new_smell creates valid smell", {
  s <- new_smell("a.R", 10, "TEST", "msg", "HIGH", "STYLE")
  # Use expect_s3_class for S3 objects
  testthat::expect_s3_class(s, "staticaudit_report")
  testthat::expect_true(inherits(s, "staticaudit_report"))
})