#' @title analyse_project
#'
#' @param path 
#' @param rules 
#'
#' @returns
#'
#' @examples
#' @export
analyse_project <- function(path, rules = default_rules()) {
  files   <- scan_project(path)
  sources <- load_sources(files)
  parsed  <- parse_sources(sources)
  ctx     <- build_context(parsed)
  
  smells  <- run_rules(ctx, rules)
  smells  <- validate_smells(smells)
  
  smells
}
