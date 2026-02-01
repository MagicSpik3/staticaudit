#' @title scan_project
#' @author Mark London
#' @name scan_project
#' @param path 
#'
#' @return list of files
#' @export
#'
#' @examples
scan_project <- function(path) {
  list.files(path, pattern = "\\.R$", full.names = TRUE)
}
