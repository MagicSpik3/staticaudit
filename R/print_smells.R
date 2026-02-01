#' @title print_smells
#' @author Mark London
#' @description
#' A short description...
#' 
#' Print Code Smells Report
#'
#' Formats the output of detect_code_smells() into a readable CLI report.
#' @name print_smells
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
print_smells <- function(smells) {
  if (is.null(smells) || nrow(smells) == 0) {
    cli::cli_alert_success("No code smells detected! Clean code.")
    return(invisible(NULL))
  }
  
  smells <- prepare_smells_for_print(smells)
  
  cli::cli_h1("Code Smell Audit Report")
  
  # Group by Category for cleaner reading
  categories <- unique(smells$category)
  
  for (cat in categories) {
    cli::cli_h2(paste("Category:", cat))
    cat_smells <- smells[smells$category == cat, ]
    
    for (i in seq_len(nrow(cat_smells))) {
      s <- cat_smells[i, ]
      
      # Color coding
      bullet <- switch(s$severity,
                       "CRITICAL" = cli::col_red(cli::symbol$cross),
                       "HIGH"     = cli::col_red(cli::symbol$warning),
                       "MEDIUM"   = cli::col_yellow(cli::symbol$bullet),
                       cli::col_cyan(cli::symbol$info)
      )
      
      sev_tag <- switch(s$severity,
                        "CRITICAL" = cli::bg_red(cli::col_white(paste0(" ", s$severity, " "))),
                        "HIGH"     = cli::col_red(paste0("[", s$severity, "]")),
                        "MEDIUM"   = cli::col_yellow(paste0("[", s$severity, "]")),
                        cli::col_grey(paste0("[", s$severity, "]"))
      )
      
      cli::cli_text(paste0(
        bullet, " ", sev_tag, " ",
        cli::col_blue(basename(s$file)), ":", cli::col_grey(s$line), " ",
        cli::style_bold(s$id)
      ))
      cli::cli_text(paste0("   ", cli::symbol$arrow_right, " ", s$message))
    }
  }
}
