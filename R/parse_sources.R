#' @title parse_sources
#' @author Mark London
#' @name parse_sources
#' @param sources 
#'
#' @return parsed
parse_sources <- function(sources) {
  # Map over the sources and parse each one
  lapply(names(sources), function(fname) {
    tryCatch({
      # Creating a srcfile object allows getParseData to find the filename
      src <- srcfilecopy(fname, sources[[fname]])
      parse(text = sources[[fname]], keep.source = TRUE, srcfile = src)
    }, error = function(e) {
      cli::cli_alert_danger("Failed to parse: {fname}")
      NULL
    })
  })
}