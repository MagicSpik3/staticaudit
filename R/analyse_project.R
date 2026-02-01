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
  print(files)
  cli::cli_alert_info("files {files} found")

  sources <- load_sources(files)
  cli::cli_alert_info("sources {sources} found")
  
  parsed_list  <- parse_sources(sources)

  # Remove NULLs (failed parses) before processing
  parsed_list <- parsed_list[!vapply(parsed_list, is.null, logical(1))]
  cli::cli_alert_info("parsed_list {parsed_list} found")
  
  if (length(parsed_list) == 0) {
    return(
      new_smell(
        character(), integer(), character(),
        character(), "LOW", character()
      )[0, ]
    )
  }
  
  if (length(parsed_list) == 0) {
    return(validate_smells(tibble::tibble())) # Or handle as no files found
  }
  
  ctx_list <- lapply(parsed_list, build_context)
  cli::cli_alert_info("ctx_list {ctx_list} found")
  
  # Extract all 'calls' tibbles and bind them
  all_calls <- dplyr::bind_rows(lapply(ctx_list, `[[`, "calls"))
  cli::cli_alert_info("all_calls {all_calls} found")
  
  ctx <- list(calls = all_calls)
  cli::cli_alert_info("ctx {ctx} found")
  
  smells  <- run_rules(ctx, rules)
  cli::cli_alert_info("smells {smells} found")
  
  # Ensure we always return a valid (possibly empty) smells object
  if (is.null(smells) || nrow(smells) == 0) {
    # Return empty smell structure to satisfy validate_smells/tests
    return(new_smell(character(), integer(), character(), 
                     character(), "LOW", character())[0, ])
  }
  
  validate_smells(smells)
}