#' Audit Function Exports
#'
#' Checks if functions are exported via Roxygen tags and if they appear in the NAMESPACE.
#'
#' @param inventory Dataframe. The output of audit_inventory().
#' @param dir_path String. Project root.
#' @return The inventory dataframe with new columns: 'has_export_tag', 'in_namespace', 'status'.
#' @author Mark London
#' @export
audit_exports <- function(inventory, dir_path = ".") {
  # 1. Parse NAMESPACE file
  ns_path <- file.path(dir_path, "NAMESPACE")
  ns_exports <- character(0)
  
  if (fs::file_exists(ns_path)) {
    ns_text <- readLines(ns_path, warn = FALSE)
    matches <- regmatches(ns_text, regexec("export\\(([^)]+)\\)", ns_text))
    
    for (m in matches) {
      if (length(m) > 1) {
        funcs <- strsplit(m[[2]], ",")[[1]]
        ns_exports <- c(ns_exports, trimws(funcs))
      }
    }
  }
  
  # 2. Check Source Code for Roxygen Tags
  inventory$has_export_tag <- FALSE
  inventory$detached_tag <- FALSE
  inventory$in_namespace <- inventory$name %in% ns_exports
  
  funcs <- inventory[inventory$type == "function", ]
  
  if (nrow(funcs) == 0) return(inventory)
  
  for (i in seq_len(nrow(funcs))) {
    row_idx <- which(inventory$name == funcs$name[i] & inventory$file == funcs$file[i])
    f_path <- file.path(dir_path, funcs$file[i])
    
    if (!fs::file_exists(f_path)) next
    
    pdata <- utils::getParseData(parse(f_path, keep.source = TRUE))
    loc <- find_func_lines(pdata, funcs$name[i])
    
    if (!is.null(loc)) {
      lines <- readLines(f_path, warn = FALSE)
      curr <- loc$start - 1
      found_tag <- FALSE
      found_gap <- FALSE
      
      while (curr > 0) {
        line <- lines[curr]
        if (grepl("^\\s*#'", line)) {
          if (grepl("@export", line)) found_tag <- TRUE
          curr <- curr - 1
        } else if (trimws(line) == "") {
          if (!found_tag) {
            # Check for detached tag
            if (curr > 1 && grepl("@export", lines[curr - 1])) {
              found_gap <- TRUE
              found_tag <- TRUE
            }
          }
          break
        } else {
          break
        }
      }
      
      inventory$has_export_tag[row_idx] <- found_tag
      inventory$detached_tag[row_idx] <- found_gap
    }
  }
  
  # 3. Determine Status
  inventory$export_status <- ifelse(
    inventory$detached_tag, "DETACHED_TAG",
    ifelse(
      inventory$has_export_tag & !inventory$in_namespace, "MISSING_IN_NS",
      ifelse(
        !inventory$has_export_tag & inventory$in_namespace, "EXTRA_IN_NS",
        ifelse(inventory$has_export_tag, "EXPORTED", "INTERNAL")
      )
    )
  )
  
  return(inventory)
}