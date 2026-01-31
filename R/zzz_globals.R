#' Internal Global State
#'
#' Stores package-level globals, primarily the AST cache to prevent O(N^2) parsing.
#'
#' @author Mark London
#' @noRd
.staticaudit_globals <- new.env(parent = emptyenv())

# Initialize the cache
.staticaudit_globals$ast_cache <- new.env(parent = emptyenv())