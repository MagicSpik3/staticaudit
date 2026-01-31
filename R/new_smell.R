new_smell <- function(file, line, id, message,
                      severity, category,
                      confidence = "MEDIUM") {
  tibble::tibble(
    file = as.character(file),
    line = as.integer(line),
    id = as.character(id),
    message = as.character(message),
    severity = factor(severity,
                      levels = c("CRITICAL", "HIGH", "MEDIUM", "LOW")),
    category = as.character(category),
    confidence = confidence
  )
}
