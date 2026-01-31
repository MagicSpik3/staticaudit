#' Check Test Coverage
#'
#' Cross-references an inventory of functions against test files to see if they are mentioned.
#'
#' @param inventory A dataframe returned by scan_definitions().
#' @param test_files A character vector of test file paths.
#' @return The inventory dataframe with an added 'called_in_test' logical column.
#' @author Mark London
#' @export
check_test_coverage <- function(inventory, test_files) {
  if (is.null(inventory)) return(NULL)
  
  inventory$called_in_test <- FALSE
  
  if (length(test_files) > 0) {
    all_test_code <- unlist(lapply(test_files, readLines, warn = FALSE))
    
    inventory$called_in_test <- vapply(inventory$name, function(nm) {
      clean_nm <- gsub("([.|()\\^{}+$*?]|\\[|\\])", "\\\\\\1", nm)
      pattern <- paste0("\\b", clean_nm, "\\b")
      any(grepl(pattern, all_test_code))
    }, logical(1))
  }
  
  return(inventory)
}