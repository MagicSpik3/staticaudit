#' @title run_rules
#' @author Mark London
#' @name run_rules
#' @param rule 
#'
#' @return dataframe of rules
#'
#' @examples
#'   run_rules(ctx, rules)
run_rules <- function(ctx, rules) {
  out <- lapply(rules, function(rule) {
    rule$detect(ctx)
  })
  
  # Remove NULLs before binding
  out <- out[!vapply(out, is.null, logical(1))]
  
  if (length(out) == 0) {
    # Return an empty tibble with the correct structure
    return(new_smell(character(), integer(), character(), 
                     character(), "LOW", character())[0, ])
  }
  
  dplyr::bind_rows(out)
}