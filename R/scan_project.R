#' @title scan_project
#' @author Mark London
#' @name scan_project
#' @param path 
#'
#' @return list of files
#' @export
scan_project <- function(path) {
  # Search recursively for R source files under the project path (including R/)
  list.files(path, pattern = "\\.R$", full.names = TRUE, recursive = TRUE)
}
