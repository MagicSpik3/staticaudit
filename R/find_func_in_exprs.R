#' Helper to extract function body from expressions
#' @param exprs List of expressions.
#' @param target_name Name of function to find.
#' @return The function body expression, or NULL.
#' @author Mark London
#' @noRd
find_func_in_exprs <- function(exprs, target_name) {
  for (e in exprs) {
    if (is.call(e) && is.symbol(e[[1]]) && as.character(e[[1]]) %in% c("<-", "=")) {
      if (is.symbol(e[[2]]) && as.character(e[[2]]) == target_name) {
        return(e[[3]])
      }
    }
  }
  return(NULL)
}