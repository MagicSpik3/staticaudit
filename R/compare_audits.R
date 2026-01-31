#' @title Compare Two Audit Snapshots
#'
#' @description
#' Loads two previously saved audit snapshots and calculates the difference
#' in key metrics (Misplaced functions, Ghost dependencies, etc.).
#'
#' @param old_path Path to the older .rds snapshot file.
#' @param new_path Path to the newer .rds snapshot file.
#'
#' @return NULL (Prints report to console).
#'
#' @author Mark London
#' @export
compare_audits <- function(old_path, new_path) {
  # 1. Load Data
  old <- readRDS(old_path)
  new <- readRDS(new_path)

  # 2. Print Header
  cli::cli_h1("Audit Delta Report")
  cli::cli_text("Comparing {.strong {old$meta$label}} ({old$meta$date}) vs {.strong {new$meta$label}} ({new$meta$date})")

  # 3. Helper for colored output
  # (Defined internally to keep file self-contained)
  calc_delta <- function(metric_name, val_old, val_new) {
    diff <- val_new - val_old

    # Negative diff is usually GOOD for debt metrics (Green)
    # Positive diff is BAD (Red)
    color_func <- if (diff < 0) cli::col_green else if (diff > 0) cli::col_red else cli::col_grey

    cli::cli_li(paste0(
      "{metric_name}: {val_old} -> {val_new} (",
      color_func("{sprintf('%+d', diff)}"),
      ")"
    ))
  }

  # 4. Report Metrics
  cli::cli_h2("Technical Debt Metrics")
  calc_delta("Misplaced Functions", old$metrics$count_misplaced, new$metrics$count_misplaced)
  calc_delta("Ghost Dependencies", old$metrics$count_ghosts, new$metrics$count_ghosts)

  # 5. Success Check
  if (new$metrics$count_misplaced < old$metrics$count_misplaced) {
    cli::cli_alert_success("Structure has improved!")
  }
}
