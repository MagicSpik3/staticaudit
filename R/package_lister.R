make_package_lister <- function(pkg, out_file = paste0(pkg, "_package_list.txt")) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    stop("Package '", pkg, "' is not installed.")
  }

  pkg_path <- find.package(pkg)

  write_lines <- function(...) {
    txt <- paste(..., collapse = "")
    write(txt, file = out_file, append = TRUE)
  }

  # Start file
  write_lines("========== PACKAGE LISTER ==========")
  write_lines("Package: ", pkg)
  write_lines("Path: ", pkg_path)
  write_lines("Generated: ", as.character(Sys.time()))
  write_lines("")

  # ---- DESCRIPTION ----
  write_lines("----- DESCRIPTION -----")
  write_lines(readLines(file.path(pkg_path, "DESCRIPTION")))
  write_lines("")

  # ---- NAMESPACE ----
  write_lines("----- NAMESPACE -----")
  ns_file <- file.path(pkg_path, "NAMESPACE")
  write_lines(if (file.exists(ns_file)) readLines(ns_file) else "<No NAMESPACE>")
  write_lines("")

  # ---- DIRECTORY TREE ----
  write_lines("----- DIRECTORY TREE -----")

  if (Sys.which("tree") != "") {
    tree_cmd <- if (.Platform$OS.type == "windows") "tree /F" else "tree -a"
    tree_out <- tryCatch(
      system(paste(tree_cmd, shQuote(pkg_path)), intern = TRUE),
      error = function(e) paste("<tree failed:", e$message, ">")
    )
    write_lines(tree_out)
  } else {
    write_lines("<tree not available, using base R listing>")
    write_lines(capture.output(list.files(pkg_path, recursive = TRUE)))
  }
  write_lines("")

  # ---- R files ----
  write_lines("----- R FILES -----")
  r_files <- list.files(file.path(pkg_path, "R"), pattern = "\\.R$", full.names = TRUE)

  for (f in r_files) {
    write_lines("")
    write_lines("### FILE:", basename(f))
    write_lines("Realpath:", normalizePath(f, winslash = "/"))
    write_lines("----- CONTENTS -----")
    write_lines(readLines(f))
  }

  # ---- ls() ----
  write_lines("")
  write_lines("----- ls(\"package:", pkg, "\") -----")
  write_lines(paste(ls(paste0("package:", pkg)), collapse = ", "))

  write_lines("========== END ==========")

  message("Written: ", normalizePath(out_file))
  invisible(out_file)
}
