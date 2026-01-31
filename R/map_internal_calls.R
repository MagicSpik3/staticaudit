#' Map Internal Function Calls
#'
#' Scans the body of each function in the inventory to find calls to other project functions.
#'
#' @param inventory The dataframe from audit_inventory()
#' @return A dataframe of edges (from, to)
#' @author Mark London
#' @noRd
map_internal_calls <- function(inventory) {
  funcs <- inventory[inventory$type == "function", ]
  edges <- data.frame(from = character(), to = character(), stringsAsFactors = FALSE)
  
  if (nrow(funcs) == 0) return(edges)
  
  for (i in seq_len(nrow(funcs))) {
    caller_name <- funcs$name[i]
    f_path <- funcs$file[i]
    
    if (!fs::file_exists(f_path)) next
    
    pdata <- utils::getParseData(parse(f_path, keep.source = TRUE))
    loc <- find_func_lines(pdata, caller_name)
    if (is.null(loc)) next
    
    body_data <- pdata[pdata$line1 >= loc$start & pdata$line2 <= loc$end, ]
    candidates <- unique(body_data$text[body_data$token == "SYMBOL_FUNCTION_CALL"])
    
    called_funcs <- intersect(candidates, funcs$name)
    called_funcs <- setdiff(called_funcs, caller_name)
    
    if (length(called_funcs) > 0) {
      new_edges <- data.frame(
        from = caller_name,
        to = called_funcs,
        stringsAsFactors = FALSE
      )
      edges <- rbind(edges, new_edges)
    }
  }
  
  return(edges)
}