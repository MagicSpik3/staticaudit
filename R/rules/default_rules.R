#' @title default_rules
#' Title
#'
#' @returns
#'
#' @examples
default_rules <- function() {
  list(
    dynamic_execution = list(
      id = "DYNAMIC_EXECUTION",
      severity = "HIGH",
      category = "SECURITY",
      detect = rule_dynamic_execution
    )
  )
}
