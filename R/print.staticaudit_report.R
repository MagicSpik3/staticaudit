#' @title print.staticaudit_report
#' @author Mark London
#' @description
#' A short description...
#' 
#' Print Code Smells Report
#'
#' Formats the output of detect_code_smells() into a readable CLI report.
#' @name print.staticaudit_report
#' @param smells Dataframe. Output from detect_code_smells().
#' @return None
#' @examples
#' smells <- data.frame(
#'   id = "long_function",
#'   message = "Function exceeds 50 lines",
#'   severity = "MEDIUM",
#'   file = "R/example.R",
#'   line = 10,
#'   category = "Complexity"
#' )
#'  print_smells(smells)
#' @export
print.staticaudit_report <- function(x, ...) {
  if (nrow(x) == 0) {
    cli::cli_alert_success("No code smells detected! Clean code.")
    return(invisible(x))
  }
  
  # Ensure preparation logic handles the factor correctly
  smells <- prepare_smells_for_print(x)
  
  cli::cli_h1("Code Smell Audit Report")
  
  categories <- unique(smells$category)
  for (cat in categories) {
    cli::cli_h2(paste("Category:", cat))
    cat_smells <- smells[smells$category == cat, ]
    
    for (i in seq_len(nrow(cat_smells))) {
      s <- cat_smells[i, ]
      
      # Use as.character() to avoid factor-switch warnings
      bullet <- switch(as.character(s$severity),
                       "CRITICAL" = cli::col_red(cli::symbol$cross),
                       "HIGH"     = cli::col_red(cli::symbol$warning),
                       "MEDIUM"   = cli::col_yellow(cli::symbol$bullet),
                       cli::col_cyan(cli::symbol$info))
      
      cli::cli_text(paste0(
        bullet, " ", cli::col_blue(basename(s$file)), ":", s$line, " ",
        cli::style_bold(s$id)
      ))
      cli::cli_text(paste0("   ", cli::symbol$arrow_right, " ", s$message))
    }
  }
  invisible(x)
}