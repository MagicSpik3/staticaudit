#' @title prepare_smells_for_print
#'
#' @param smells 
#'
#' @returns
#'
#' @examples
prepare_smells_for_print <- function(smells) {
  
  # Sort by Severity (Critical first)
  # Map severity to numeric for sorting
  sev_levels <- c("CRITICAL" = 1, "HIGH" = 2, "MEDIUM" = 3, "LOW" = 4)
  smells$sev_score <- sev_levels[smells$severity]
  # Handle unknown severities
  smells$sev_score[is.na(smells$sev_score)] <- 5
  
  smells <- smells[order(smells$sev_score, smells$file, smells$line), ]
  
  smells
}
