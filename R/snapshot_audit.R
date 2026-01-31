#' @title Capture and Store an Audit Snapshot
#'
#' @description
#' Runs a full static analysis (inventory + dependencies) and saves the
#' results to a history folder (.staticaudit) in the target directory.
#'
#' @param target_dir Path to the package root. Defaults to current directory.
#' @param label Optional tag (e.g., "v0.9", "pre-split").
#'
#' @return The snapshot list object (invisibly).
#'
#' @author Mark London
#' @export
snapshot_audit <- function(target_dir = ".", label = NULL) {
  # 1. Run Core Scanners
  # (Relies on other functions in this package)
  if (!file.exists(file.path(target_dir, "DESCRIPTION"))) {
    stop("Target is not a valid R package (missing DESCRIPTION)")
  }

  pkg_desc <- desc::desc(target_dir)
  inv <- audit_inventory(target_dir)
  deps <- scan_dependencies(target_dir)

  # 2. Construct Snapshot
  snapshot <- structure(
    list(
      meta = list(
        package = pkg_desc$get("Package"),
        version = pkg_desc$get("Version"),
        date = Sys.time(),
        label = label
      ),
      metrics = list(
        count_total = nrow(inv),
        count_misplaced = sum(inv$misplaced),
        count_ghosts = length(deps$undeclared_ghosts)
      ),
      data = list(
        inventory = inv,
        dependencies = deps
      )
    ),
    class = "audit_snapshot"
  )

  # 3. Save to Disk
  audit_dir <- file.path(target_dir, ".staticaudit")
  if (!dir.exists(audit_dir)) dir.create(audit_dir)

  # Filename: audit_PKG_VER_DATE_LABEL.rds
  filename <- sprintf(
    "audit_%s_v%s_%s%s.rds",
    snapshot$meta$package,
    snapshot$meta$version,
    format(Sys.time(), "%Y%m%d"),
    if (!is.null(label)) paste0("_", label) else ""
  )

  saveRDS(snapshot, file.path(audit_dir, filename))

  cli::cli_alert_success("Snapshot saved: {.file {filename}}")
  return(invisible(snapshot))
}
