#' @title default_rules
#' @author Mark London
#' 
#' @name default_rules
#' @return Invisibly returns NULL
#'
#' @examples
#'   default_rules()
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
