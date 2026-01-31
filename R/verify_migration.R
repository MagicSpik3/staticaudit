#' @title Verify Migration Progress Between Repos
#'
#' @description
#' Compares the function inventory of a Legacy repository against a Target
#' repository to track migration status. It classifies every function as:
#' \itemize{
#'   \item \strong{Migrated:} Exists in Target (Success).
#'   \item \strong{Pending:} Exists only in Legacy (Work remaining).
#'   \item \strong{Duplicated:} Exists in BOTH (Danger - potential divergence).
#' }
#'
#' @param legacy_dir Character. Path to the legacy project root.
#' @param target_dir Character. Path to the new 'clean' package root.
#'
#' @return A data frame summarizing the status of all functions found.
#'
#' @author Mark London
#' @export
verify_migration <- function(legacy_dir, target_dir) {
  # 1. Get Inventories (Using internal package functions)
  # We assume audit_inventory is available in this package
  inv_legacy <- audit_inventory(legacy_dir)
  inv_target <- audit_inventory(target_dir)

  # 2. Extract Function Names
  funcs_legacy <- inv_legacy$name
  funcs_target <- inv_target$name

  # 3. Calculate Sets
  all_funcs <- unique(c(funcs_legacy, funcs_target))

  # 4. Determine Status for each function
  status_list <- vapply(all_funcs, function(fn) {
    in_legacy <- fn %in% funcs_legacy
    in_target <- fn %in% funcs_target

    if (in_legacy && in_target) {
      return("DUPLICATED (Exists in both)")
    } else if (in_target) {
      return("MIGRATED (Safe in target)")
    } else {
      return("PENDING (Still in legacy)")
    }
  }, character(1))

  # 5. Create Result Dataframe
  results <- data.frame(
    function_name = all_funcs,
    status = status_list,
    row.names = NULL,
    stringsAsFactors = FALSE
  )

  # 6. Console Reporting (using cli for pretty output)
  n_migrated <- sum(results$status == "MIGRATED (Safe in target)")
  n_pending <- sum(results$status == "PENDING (Still in legacy)")
  n_dupes <- sum(results$status == "DUPLICATED (Exists in both)")

  cli::cli_h1("Migration Status Report")
  cli::cli_alert_success("Migrated: {n_migrated}")
  cli::cli_alert_warning("Pending:  {n_pending}")
  if (n_dupes > 0) {
    cli::cli_alert_danger("Duplicated: {n_dupes} (Delete from Legacy!)")
  }

  return(results)
}
