#' Recursive AST Walker for Packages
#' @param expr An R expression or list of expressions.
#' @return Character vector of package names found.
#' @author Mark London
#' @noRd
walk_ast_for_pkgs <- function(expr) {
  pkgs <- character()
  
  if (is.list(expr) || is.expression(expr)) {
    safe_list <- as.list(expr)
    for (e in safe_list) {
      if (missing(e)) next
      pkgs <- c(pkgs, walk_ast_for_pkgs(e))
    }
    return(pkgs)
  }
  
  if (is.call(expr)) {
    if (is.symbol(expr[[1]]) && as.character(expr[[1]]) %in% c("::", ":::")) {
      pkgs <- c(pkgs, as.character(expr[[2]]))
    }
    if (is.symbol(expr[[1]]) && as.character(expr[[1]]) %in% c("library", "require", "p_load")) {
      if (length(expr) >= 2) {
        arg <- expr[[2]]
        if (is.character(arg) || is.symbol(arg)) {
          pkgs <- c(pkgs, as.character(arg))
        }
      }
    }
    safe_children <- as.list(expr)
    for (child in safe_children) {
      if (missing(child)) next
      pkgs <- c(pkgs, walk_ast_for_pkgs(child))
    }
  }
  return(pkgs)
}