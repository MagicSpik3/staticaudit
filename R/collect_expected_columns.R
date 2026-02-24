#' @title collect_expected_columns
#' @description Parse project sources to collect unquoted symbol names used inside `c()` calls
#'   that appear nested within common tidy-selection or mutate/select contexts (e.g. `across`, `select`, `mutate`).
#' @param path Path to R project root (as used by `scan_project`).
#' @return A tibble with columns `file` and `column` listing expected column names found in code.
#' @export
collect_expected_columns <- function(path) {
  files <- scan_project(path)
  sources <- load_sources(files)

  out <- list()

  targets <- c("across", "select", "mutate", "filter", "subset", "rename", "group_by", "summarize", "summarise")

  for (fname in names(sources)) {
    # Join lines to keep original parse behavior
    txt <- sources[[fname]]
    src <- tryCatch(srcfilecopy(fname, txt), error = function(e) NULL)
    parsed <- tryCatch(parse(text = txt, keep.source = TRUE, srcfile = src), error = function(e) NULL)
    if (is.null(parsed)) next

    pd <- utils::getParseData(parsed)
    if (is.null(pd) || nrow(pd) == 0) next

    # More generic approach: find all SYMBOL tokens whose ancestor chain
    # includes a call to one of the `targets` functions (e.g., across, select)
    symbol_rows <- pd[pd$token == "SYMBOL", , drop = FALSE]
    if (nrow(symbol_rows) == 0) next

    has_target_ancestor <- function(pd, node_id, targets) {
      current <- node_id
      while (!is.null(current) && length(current) == 1 && current != 0) {
        # children of this ancestor
        children <- pd[pd$parent == current, , drop = FALSE]
        if (nrow(children) > 0 && any(children$token == "SYMBOL_FUNCTION_CALL" & children$text %in% targets)) return(TRUE)
        # move up
        parent_row <- pd[pd$id == current, , drop = FALSE]
        if (nrow(parent_row) == 0) break
        current <- parent_row$parent
      }
      FALSE
    }

    cols <- character()
    lines <- integer()

    # Strategy A: Find SYMBOLs whose ancestor chain contains a target call
    for (i in seq_len(nrow(symbol_rows))) {
      sym <- symbol_rows[i, ]
      if (sym$text %in% targets) next
      parent_id <- sym$parent
      if (is.na(parent_id) || parent_id == 0) next
      if (has_target_ancestor(pd, parent_id, targets)) {
        cols <- c(cols, as.character(sym$text))
        lines <- c(lines, as.integer(sym$line1))
      }
    }

    # Strategy B: For each actual target function call, use its parent block bounds
    # to find SYMBOL tokens that occur within that call's syntactic extent.
    target_calls <- pd[pd$token == "SYMBOL_FUNCTION_CALL" & pd$text %in% targets, , drop = FALSE]
    if (nrow(target_calls) > 0) {
      for (i in seq_len(nrow(target_calls))) {
        call_parent <- target_calls$parent[i]
        if (is.na(call_parent) || call_parent == 0) next
        block <- pd[pd$id == call_parent | pd$parent == call_parent, , drop = FALSE]
        if (nrow(block) == 0) next
        start_line <- min(block$line1, na.rm = TRUE)
        end_line <- max(block$line2, na.rm = TRUE)

        # collect SYMBOL tokens within these line bounds
        in_block <- pd[pd$token == "SYMBOL" & pd$line1 >= start_line & pd$line2 <= end_line, , drop = FALSE]
        if (nrow(in_block) > 0) {
          # exclude the function names themselves
          in_block <- in_block[!in_block$text %in% targets, , drop = FALSE]
          if (nrow(in_block) > 0) {
            cols <- c(cols, as.character(in_block$text))
            lines <- c(lines, as.integer(in_block$line1))
          }
        }
      }
    }

    if (length(cols) > 0) {
      # Lowercase and keep associated lines
      out[[fname]] <- unique(data.frame(column = tolower(cols), line = lines, stringsAsFactors = FALSE))
    }
    
    # Fallback: simple regex-based scan for patterns like across(... c(a, b) ...)
    if (length(cols) == 0) {
      txt_full <- paste(txt, collapse = "\n")
      pattern <- paste0("(\\b", paste(targets, collapse = "|"), "\\b)\\s*\\([^)]*c\\s*\\(([^)]+)\\)")
      m <- gregexpr(pattern, txt_full, perl = TRUE)
      if (m[[1]][1] != -1) {
        matches <- regmatches(txt_full, m)
        for (mm in matches[[1]]) {
          # extract inner group (contents of c(...))
          inner <- sub(pattern, "\\1", mm, perl = TRUE)
          # actually use a second capture to get inner group properly
          inner_match <- regexec(pattern, mm, perl = TRUE)
          caps <- regmatches(mm, inner_match)[[1]]
          if (length(caps) >= 3) {
            inner_content <- caps[3]
            parts <- unlist(strsplit(inner_content, ","))
            parts <- trimws(parts)
            # keep only bare-name-like tokens (no quotes)
            parts <- parts[grepl("^[A-Za-z0-9_.]+$", parts)]
            if (length(parts) > 0) {
              cols <- c(cols, parts)
              # approximate line number from position
              pos <- regexpr(inner_content, txt_full, fixed = TRUE)
              if (pos[1] > 0) {
                line_no <- sum(substr(txt_full, 1, pos[1]) == '\n') + 1
              } else {
                line_no <- NA_integer_
              }
              lines <- c(lines, rep(line_no, length(parts)))
            }
          }
        }
        if (length(cols) > 0) {
          out[[fname]] <- unique(data.frame(column = tolower(cols), line = lines, stringsAsFactors = FALSE))
        }
      }
    }
  }

  if (length(out) == 0) return(tibble::tibble(file = character(), column = character(), line = integer()))

  rows <- do.call(rbind, lapply(names(out), function(f) {
    df <- out[[f]]
    tibble::tibble(file = f, column = df$column, line = as.integer(df$line)
    )
  }))
  tibble::as_tibble(rows)
}
