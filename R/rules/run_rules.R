#' @title run_rules
#'
#' @param rule 
#'
#' @returns
#'
#' @examples
run_rules <- function(ctx, rules) {
  out <- lapply(rules, function(rule) {
    rule$detect(ctx)
  })
  dplyr::bind_rows(out)
}
