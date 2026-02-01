#' Analyse a single code string
#' @export
analyse_code <- function(code, rules = default_rules()) {
  parsed <- parse(text = code, keep.source = TRUE)
  ctx <- build_context(parsed)
  run_rules(ctx, rules)
}
