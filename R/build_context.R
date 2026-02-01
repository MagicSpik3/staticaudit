#' @title build_context
#' @author Mark London
#' @name build_context
#' @description Extracts all function calls and symbols from parsed R code to build a searchable context.
#' @param parsed The output of parse()
#' @return A list containing a 'calls' tibble.
#' @examples
#'   build_context(parsed)
#' @export
build_context <- function(parsed) {
  pd <- utils::getParseData(parsed)
  
  # Extract the filename from the source file attribute
  src_info <- attr(parsed, "srcfile")
  fname <- if (!is.null(src_info)) src_info$filename else "unknown"
  
  # Initialize an empty structure with the expected columns
  empty_calls <- tibble::tibble(
    name = character(), 
    line = integer(), 
    file = character()
  )
  
  if (is.null(pd) || nrow(pd) == 0) {
    return(list(calls = empty_calls))
  }
  
  # Extract potential calls (standard calls and symbols)
  calls_pd <- pd[pd$token %in% c("SYMBOL_FUNCTION_CALL", "SYMBOL"), ]
  
  if (nrow(calls_pd) == 0) {
    return(list(calls = empty_calls))
  }
  
  calls <- tibble::tibble(
    name = as.character(calls_pd$text),
    line = as.integer(calls_pd$line1),
    file = as.character(fname)
  )
  
  list(calls = calls)
}