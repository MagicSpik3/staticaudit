#' @title analyse_project
#' @author Mark London
#' @name analyse_project
#' @param path 
#' @param rules 
#'
#' @return smells - a object of the detected code smells
#'
#' @examples
#'   analyse_project(path)
#' @export
analyse_project <- function(path, rules = default_rules()) {
  files   <- scan_project(path)
  sources <- load_sources(files)
  parsed_list  <- parse_sources(sources)
  
  # Remove NULLs (failed parses) before processing
  parsed_list <- parsed_list[!vapply(parsed_list, is.null, logical(1))]
  
  if (length(parsed_list) == 0) {
    return(validate_smells(tibble::tibble())) # Or handle as no files found
  }
  
  ctx_list <- lapply(parsed_list, build_context)
  
  # Extract all 'calls' tibbles and bind them
  all_calls <- dplyr::bind_rows(lapply(ctx_list, `[[`, "calls"))
  
  ctx <- list(calls = all_calls)
  
  smells  <- run_rules(ctx, rules)
  
  # Ensure we always return a valid (possibly empty) smells object
  if (is.null(smells) || nrow(smells) == 0) {
    # Return empty smell structure to satisfy validate_smells/tests
    return(new_smell(character(), integer(), character(), 
                     character(), "LOW", character())[0, ])
  }
  
  validate_smells(smells)
}