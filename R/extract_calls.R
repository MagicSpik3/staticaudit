#' Recursive walker to find function names being called
#' @param expr Expression to scan.
#' @return Character vector of function names.
#' @author Mark London
#' @noRd
extract_calls <- function(expr) {
  calls <- character()
  
  if (is.call(expr)) {
    fn <- expr[[1]]
    
    if (is.symbol(fn)) {
      calls <- c(calls, as.character(fn))
    } else if (is.call(fn) && as.character(fn[[1]]) %in% c("::", ":::")) {
      pkg <- as.character(fn[[2]])
      func <- as.character(fn[[3]])
      calls <- c(calls, paste0(pkg, "::", func))
    }
    
    for (i in 2:length(expr)) {
      calls <- c(calls, extract_calls(expr[[i]]))
    }
  } else if (is.recursive(expr)) {
    for (i in seq_along(expr)) {
      calls <- c(calls, extract_calls(expr[[i]]))
    }
  }
  
  return(calls)
}