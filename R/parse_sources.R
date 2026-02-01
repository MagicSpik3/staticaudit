#' @title parse_sources
#' @author Mark London
#' @name parse_sources
#' @param sources 
#'
#' @return parsed
#'
#' @examples
parse_sources <- function(sources) {
  # Map over the sources and parse each one
  lapply(names(sources), function(fname) {
    tryCatch({
      parse(text = sources[[fname]], keep.source = TRUE, srcfile = fname)
    }, error = function(e) {
      cli::cli_alert_danger("Failed to parse: {fname}")
      NULL
    })
  })
}