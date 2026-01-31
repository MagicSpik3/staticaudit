test_that("new_smell creates valid smell", {
  s <- new_smell("a.R", 10, "TEST", "msg", "HIGH", "STYLE")
  expect_s3_class(s, "tbl_df")
})
