#' @title load_sources
#' @author Mark London
#' @name load_sources
#' @param files 
#'
#' @return sources
load_sources <- function(files) {
  # Read files into a named list of strings
  sapply(files, readLines, warn = FALSE, simplify = FALSE)
}