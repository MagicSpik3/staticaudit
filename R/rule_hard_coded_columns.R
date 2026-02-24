#' @title rule_hard_coded_columns
#' @description Detect usage of unquoted, hard-coded column names inside `c()` when
#'  nested in selection/mutation contexts (e.g. `select`, `across`, `mutate`).
#' @param ctx The analysis context (not used directly; function parses sources itself).
#' @return A tibble of smells (or NULL)
#' @export
rule_hard_coded_columns <- function(ctx) {
  project_path <- if (!is.null(ctx$path)) ctx$path else "."
  # Collect expected columns across project files
  cols_tbl <- collect_expected_columns(project_path)
  if (nrow(cols_tbl) == 0) return(NULL)

  # Build smells for each occurrence
  smells <- lapply(seq_len(nrow(cols_tbl)), function(i) {
    new_smell(
      file = cols_tbl$file[i],
      line = as.integer(cols_tbl$line[i]),
      id = "HARDCODED_COLUMN",
      message = paste0("Hard-coded column name used: ", cols_tbl$column[i]),
      severity = "MEDIUM",
      category = "MAINTAINABILITY"
    )
  })

  dplyr::bind_rows(smells)
}
