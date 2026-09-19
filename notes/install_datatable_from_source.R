# =============================================================================
# Install data.table from Source and Fix OpenMP Library Path
# =============================================================================
# This script handles the macOS-specific issue where data.table compiles
# against Homebrew's OpenMP with a hardcoded library path that needs to be
# changed to use @rpath for proper loading.
# =============================================================================

install_and_fix_datatable <- function(repo = "Rdatatable/data.table",
                                      ref = "master") {

  cat("\n=== Installing data.table from source ===\n")

  # Install from GitHub
  if (!requireNamespace("remotes", quietly = TRUE)) {
    install.packages("remotes")
  }

  # Install data.table
  cat("Installing from", repo, "branch/ref:", ref, "\n")
  remotes::install_github(repo, ref = ref, force = TRUE)

  # Find the data.table library path
  dt_path <- system.file(package = "data.table")
  so_path <- file.path(dt_path, "libs", "data_table.so")

  if (!file.exists(so_path)) {
    stop("Could not find data_table.so at: ", so_path)
  }

  cat("\n=== Fixing OpenMP library reference ===\n")
  cat("Library location:", so_path, "\n")

  # Check current library dependencies
  cmd_check <- sprintf("otool -L '%s'", so_path)
  cat("\nBefore fix:\n")
  system(cmd_check)

  # Fix the library path to use @rpath
  cmd_fix <- sprintf(
    "install_name_tool -change /opt/homebrew/opt/libomp/lib/libomp.dylib @rpath/libomp.dylib '%s'",
    so_path
  )

  result <- system(cmd_fix)

  if (result != 0) {
    warning("install_name_tool command failed. You may need to run it manually with sudo.")
    cat("\nManual fix command:\n")
    cat("sudo", cmd_fix, "\n")
    return(invisible(FALSE))
  }

  # Verify the fix
  cat("\nAfter fix:\n")
  system(cmd_check)

  # Test loading
  cat("\n=== Testing data.table load ===\n")

  # Unload if already loaded
  if ("data.table" %in% loadedNamespaces()) {
    try(unloadNamespace("data.table"), silent = TRUE)
  }

  # Try to load
  tryCatch({
    library(data.table)
    cat("\nSUCCESS! data.table version",
        as.character(packageVersion("data.table")),
        "loaded successfully.\n")
    return(invisible(TRUE))
  }, error = function(e) {
    cat("\nERROR loading data.table:\n")
    cat(conditionMessage(e), "\n")
    return(invisible(FALSE))
  })
}

# Convenience function to just fix an already-installed data.table
fix_datatable_openmp <- function() {

  dt_path <- system.file(package = "data.table")

  if (dt_path == "") {
    stop("data.table is not installed. Install it first with install.packages() or remotes::install_github()")
  }

  so_path <- file.path(dt_path, "libs", "data_table.so")

  if (!file.exists(so_path)) {
    stop("Could not find data_table.so at: ", so_path)
  }

  cat("Fixing OpenMP library reference in:", so_path, "\n")

  cmd_fix <- sprintf(
    "install_name_tool -change /opt/homebrew/opt/libomp/lib/libomp.dylib @rpath/libomp.dylib '%s'",
    so_path
  )

  result <- system(cmd_fix)

  if (result != 0) {
    warning("install_name_tool command failed. You may need to run it manually with sudo.")
    cat("\nManual fix command:\n")
    cat("sudo", cmd_fix, "\n")
    return(invisible(FALSE))
  }

  cat("Fix applied successfully!\n")
  cat("Try loading with: library(data.table)\n")
  return(invisible(TRUE))
}

# =============================================================================
# Usage Examples
# =============================================================================

# Example 1: Install development version from GitHub and auto-fix
# install_and_fix_datatable()

# Example 2: Install specific version
# install_and_fix_datatable(repo = "Rdatatable/data.table", ref = "v1.15.0")

# Example 3: Just fix an already-installed data.table
# fix_datatable_openmp()

# Example 4: Manual fix if you need sudo
# Run in terminal:
# sudo install_name_tool -change /opt/homebrew/opt/libomp/lib/libomp.dylib @rpath/libomp.dylib \
#   /Library/Frameworks/R.framework/Versions/4.5-arm64/Resources/library/data.table/libs/data_table.so

cat("\n=============================================================================\n")
cat("Functions loaded:\n")
cat("  install_and_fix_datatable() - Install from GitHub and auto-fix\n")
cat("  fix_datatable_openmp()      - Fix already-installed data.table\n")
cat("=============================================================================\n\n")
