#' @title rule_dynamic_execution
#'
#' @param ctx 
#'
#' @returns
#'
#' @examples
rule_dynamic_execution <- function(ctx) {
  hits <- ctx$calls[ctx$calls$name %in% c("get", "assign"), ]
  
  if (nrow(hits) == 0) return(NULL)
  
  new_smell(
    file = hits$file,
    line = hits$line,
    id = "DYNAMIC_EXECUTION",
    message = "Use of dynamic execution",
    severity = "HIGH",
    category = "SECURITY"
  )
}
