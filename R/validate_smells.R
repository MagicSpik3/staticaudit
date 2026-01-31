validate_smells <- function(x) {
  stopifnot(
    is.data.frame(x),
    all(c("file","line","id","severity","category","message") %in% names(x))
  )
  x
}
