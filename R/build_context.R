#' @title build_context
#' @author Mark London
#' @name build_context
#'
#' @param parsed 
#'
#' @return list
#'
#' @examples
#'   build_context(parsed)
build_context <- function(parsed) {
  pd <- utils::getParseData(parsed)
  
  # Initialize an empty structure with the expected columns
  empty_calls <- tibble::tibble(
    name = character(), 
    line = integer(), 
    file = character()
  )
  
  if (is.null(pd) || nrow(pd) == 0) {
    return(list(calls = empty_calls))
  }
  
  # Filter for function calls
  calls_pd <- pd[pd$token == "SYMBOL_FUNCTION_CALL", ]
  
  if (nrow(calls_pd) == 0) {
    return(list(calls = empty_calls))
  }
  
  # Extract filename from the srcfile attribute assigned during parse_sources
  fname <- attr(attr(parsed, "srcfile"), "filename")
  if (is.null(fname)) fname <- "unknown"
  
  calls <- tibble::tibble(
    name = calls_pd$text,
    line = calls_pd$line1,
    file = fname
  )
  
  list(calls = calls)
}