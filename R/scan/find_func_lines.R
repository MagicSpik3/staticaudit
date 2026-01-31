#' Find function definition lines in parse data
#' Uses strict geometry (Line/Col) to identify LHS vs RHS.
#' @param pdata Dataframe from getParseData().
#' @param func_name Name of function to find.
#' @return List with start and end line numbers, or NULL.
#' @author Mark London
#' @noRd
find_func_lines <- function(pdata, func_name) {
  assign_ops <- pdata[pdata$token %in% c("LEFT_ASSIGN", "EQ_ASSIGN"), ]
  if (nrow(assign_ops) == 0) return(NULL)
  
  for (i in seq_len(nrow(assign_ops))) {
    op_row <- assign_ops[i, ]
    parent_id <- op_row$parent
    siblings <- pdata[pdata$parent == parent_id, ]
    
    is_lhs <- (siblings$line2 < op_row$line1) | (siblings$line2 == op_row$line1 & siblings$col2 < op_row$col1)
    is_rhs <- (siblings$line1 > op_row$line2) | (siblings$line1 == op_row$line2 & siblings$col1 > op_row$col2)
    
    lhs_tokens <- siblings[is_lhs, ]
    rhs_tokens <- siblings[is_rhs, ]
    
    if (nrow(lhs_tokens) == 0 || nrow(rhs_tokens) == 0) next
    
    found_lhs <- any(pdata$token == "SYMBOL" & pdata$text == func_name & 
                       pdata$line1 >= min(lhs_tokens$line1) & pdata$line2 <= max(lhs_tokens$line2))
    if (!found_lhs) next
    
    found_rhs <- any(pdata$token == "FUNCTION" & 
                       pdata$line1 >= min(rhs_tokens$line1) & pdata$line2 <= max(rhs_tokens$line2))
    
    if (found_rhs) {
      block <- pdata[pdata$id == parent_id | pdata$parent == parent_id, ]
      return(list(start = min(block$line1), end = max(block$line2)))
    }
  }
  return(NULL)
}