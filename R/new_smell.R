#' @title new_smell
#' @author Mark London
#' @name new_smell
#'
#' @param file 
#' @param line 
#' @param id 
#' @param message 
#' @param severity 
#' @param category 
#' @param confidence 
#'
#' @return out a class of smell
#' @export
new_smell <- function(file, line, id, message, severity, category, confidence = "MEDIUM") {
  
  # Validating the "Map" against allowed values
  valid_severities <- c("CRITICAL", "HIGH", "MEDIUM", "LOW")
  
  if (!severity %in% valid_severities) {
    stop(paste("Invalid severity:", severity, ". Must be one of:", 
               paste(valid_severities, collapse = ", ")))
  }
  
  out <- tibble::tibble(
    file = as.character(file),
    line = as.integer(line),
    id = as.character(id),
    message = as.character(message),
    severity = factor(severity, levels = valid_severities),
    category = as.character(category),
    confidence = confidence
  )
  
  class(out) <- c("staticaudit_report", class(out))
  out
}