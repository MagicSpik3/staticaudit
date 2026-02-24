#' @title preflight_check
#' @description Verify that all expected (unquoted) column names referenced in source code
#'   are present in a provided data frame. Uses `collect_expected_columns()` to infer names.
#' @param df A data.frame or tibble to validate.
#' @param path Path to project root containing R sources (passed to `collect_expected_columns`).
#' @param stop_on_missing If TRUE, `stop()` when any missing columns are found. Default `FALSE`.
#' @return If missing columns are found, returns a `staticaudit_report` tibble (via `new_smell()`),
#'   otherwise returns an invisible `TRUE`.
#' @export
preflight_check <- function(df, path = ".", stop_on_missing = FALSE) {
  expected_tbl <- collect_expected_columns(path)
  if (nrow(expected_tbl) == 0) return(invisible(TRUE))

  df_cols <- tolower(colnames(df))
  # unique expected columns across files
  expected_all <- unique(expected_tbl$column)

  missing <- setdiff(expected_all, df_cols)

  if (length(missing) == 0) return(invisible(TRUE))

  # Build smells for missing columns
  rows <- do.call(rbind, lapply(missing, function(col) {
    # find an example file that references the missing column
    f <- expected_tbl$file[expected_tbl$column == col][1]
    new_smell(file = f, line = 0L, id = "MISSING_COLUMN_PRECHECK",
              message = paste0("Missing expected column: ", col),
              severity = "CRITICAL", category = "MAINTAINABILITY")
  }))

  smells <- dplyr::bind_rows(rows)

  if (stop_on_missing) {
    stop(sprintf("Preflight check failed: %d missing columns. First: %s", length(missing), missing[1]))
  }

  smells
}
