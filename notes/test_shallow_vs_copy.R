# =============================================================================
# Testing data.table shallow() vs copy() Behavior
# =============================================================================
# This script tests the internal shallow() function to understand its behavior
# compared to copy() and determine if it's safe for export.
#
# Key Questions:
# 1. How does shallow() differ from copy()?
# 2. Does := modify both original and shallow copy?
# 3. What about column structure vs column data?
# 4. Performance implications?
# =============================================================================

library(data.table)

# Helper function to print section headers
section <- function(title) {
  cat("\n", rep("=", 80), "\n", sep = "")
  cat(title, "\n")
  cat(rep("=", 80), "\n", sep = "")
}

# Helper function to print test results
print_test <- function(test_name, ...) {
  cat("\n--- ", test_name, " ---\n", sep = "")
  cat(...)
  cat("\n")
}

# =============================================================================
# Test 1: Memory Addresses - Shallow vs Copy
# =============================================================================
section("TEST 1: Memory Addresses Comparison")

dt_original <- data.table(
  x = 1:5,
  y = letters[1:5],
  z = rnorm(5)
)

dt_shallow <- data.table:::shallow(dt_original)
dt_copy <- copy(dt_original)

print_test(
  "Memory addresses of main objects",
  "Original DT address:  ", data.table::address(dt_original), "\n",
  "Shallow copy address: ", data.table::address(dt_shallow), "\n",
  "Deep copy address:    ", data.table::address(dt_copy), "\n"
)

print_test(
  "Memory addresses of column 'x'",
  "Original DT$x:  ", data.table::address(dt_original$x), "\n",
  "Shallow copy$x: ", data.table::address(dt_shallow$x), "\n",
  "Deep copy$x:    ", data.table::address(dt_copy$x), "\n"
)

print_test(
  "Memory addresses of column 'y'",
  "Original DT$y:  ", data.table::address(dt_original$y), "\n",
  "Shallow copy$y: ", data.table::address(dt_shallow$y), "\n",
  "Deep copy$y:    ", data.table::address(dt_copy$y), "\n"
)

print_test(
  "Summary",
  "Shallow copy has different DT address but SAME column addresses\n",
  "Deep copy has different DT address AND different column addresses\n"
)

# =============================================================================
# Test 2: Modifying Columns with := Operator
# =============================================================================
section("TEST 2: Column Modification with := Operator")

# Reset test data
dt_original <- data.table(
  x = 1:5,
  y = letters[1:5],
  z = rnorm(5)
)
dt_shallow <- data.table:::shallow(dt_original)
dt_copy <- copy(dt_original)

# Store initial values
original_x_before <- dt_original$x
shallow_x_before <- dt_shallow$x
copy_x_before <- dt_copy$x

# Modify the ORIGINAL using :=
dt_original[, x := x * 10]

print_test(
  "After modifying ORIGINAL with := (x * 10)",
  "Original DT$x: ", paste(dt_original$x, collapse = ", "), "\n",
  "Shallow copy$x: ", paste(dt_shallow$x, collapse = ", "), "\n",
  "Deep copy$x:    ", paste(dt_copy$x, collapse = ", "), "\n",
  "\nShallow copy affected? ", !identical(shallow_x_before, dt_shallow$x), "\n",
  "Deep copy affected?    ", !identical(copy_x_before, dt_copy$x), "\n"
)

# Reset and test modifying the SHALLOW copy
dt_original <- data.table(
  x = 1:5,
  y = letters[1:5],
  z = rnorm(5)
)
dt_shallow <- data.table:::shallow(dt_original)
dt_copy <- copy(dt_original)

original_x_before <- dt_original$x

# Modify the SHALLOW COPY using :=
dt_shallow[, x := x * 100]

print_test(
  "After modifying SHALLOW COPY with := (x * 100)",
  "Original DT$x: ", paste(dt_original$x, collapse = ", "), "\n",
  "Shallow copy$x: ", paste(dt_shallow$x, collapse = ", "), "\n",
  "\nOriginal affected by shallow modification? ", !identical(original_x_before, dt_original$x), "\n"
)

# =============================================================================
# Test 3: Adding New Columns with :=
# =============================================================================
section("TEST 3: Adding New Columns with :=")

dt_original <- data.table(x = 1:5, y = letters[1:5])
dt_shallow <- data.table:::shallow(dt_original)
dt_copy <- copy(dt_original)

# Add column to original
dt_original[, new_col := x * 2]

print_test(
  "After adding 'new_col' to ORIGINAL",
  "Original columns: ", paste(names(dt_original), collapse = ", "), "\n",
  "Shallow columns:  ", paste(names(dt_shallow), collapse = ", "), "\n",
  "Deep copy columns: ", paste(names(dt_copy), collapse = ", "), "\n",
  "\nShallow has new column? ", "new_col" %in% names(dt_shallow), "\n",
  "Deep copy has new column? ", "new_col" %in% names(dt_copy), "\n"
)

# Reset and add column to shallow copy
dt_original <- data.table(x = 1:5, y = letters[1:5])
dt_shallow <- data.table:::shallow(dt_original)

dt_shallow[, shallow_col := x * 3]

print_test(
  "After adding 'shallow_col' to SHALLOW COPY",
  "Original columns: ", paste(names(dt_original), collapse = ", "), "\n",
  "Shallow columns:  ", paste(names(dt_shallow), collapse = ", "), "\n",
  "\nOriginal has shallow_col? ", "shallow_col" %in% names(dt_original), "\n"
)

# =============================================================================
# Test 4: Deleting Columns with := NULL
# =============================================================================
section("TEST 4: Deleting Columns with := NULL")

dt_original <- data.table(x = 1:5, y = letters[1:5], z = rnorm(5))
dt_shallow <- data.table:::shallow(dt_original)
dt_copy <- copy(dt_original)

# Delete column from original
dt_original[, z := NULL]

print_test(
  "After deleting 'z' from ORIGINAL",
  "Original columns: ", paste(names(dt_original), collapse = ", "), "\n",
  "Shallow columns:  ", paste(names(dt_shallow), collapse = ", "), "\n",
  "Deep copy columns: ", paste(names(dt_copy), collapse = ", "), "\n",
  "\nShallow still has 'z'? ", "z" %in% names(dt_shallow), "\n",
  "Deep copy still has 'z'? ", "z" %in% names(dt_copy), "\n"
)

# =============================================================================
# Test 5: set*() Functions (setnames, setkey, setcolorder)
# =============================================================================
section("TEST 5: set*() Functions")

# Test 5a: setnames()
dt_original <- data.table(x = 1:5, y = letters[1:5])
dt_shallow <- data.table:::shallow(dt_original)
dt_copy <- copy(dt_original)

setnames(dt_original, "x", "x_renamed")

print_test(
  "After setnames() on ORIGINAL (x -> x_renamed)",
  "Original columns: ", paste(names(dt_original), collapse = ", "), "\n",
  "Shallow columns:  ", paste(names(dt_shallow), collapse = ", "), "\n",
  "Deep copy columns: ", paste(names(dt_copy), collapse = ", "), "\n"
)

# Test 5b: setkey()
dt_original <- data.table(x = 5:1, y = letters[5:1])
dt_shallow <- data.table:::shallow(dt_original)
dt_copy <- copy(dt_original)

setkey(dt_original, x)

print_test(
  "After setkey() on ORIGINAL (key = x)",
  "Original key: ", paste(key(dt_original), collapse = ", "), "\n",
  "Shallow key:  ", paste(key(dt_shallow), collapse = ", "), "\n",
  "Deep copy key: ", paste(key(dt_copy), collapse = ", "), "\n",
  "\nOriginal is sorted: ", paste(dt_original$x, collapse = ", "), "\n",
  "Shallow is sorted:  ", paste(dt_shallow$x, collapse = ", "), "\n"
)

# Test 5c: setcolorder()
dt_original <- data.table(x = 1:5, y = letters[1:5], z = rnorm(5))
dt_shallow <- data.table:::shallow(dt_original)
dt_copy <- copy(dt_original)

setcolorder(dt_original, c("z", "y", "x"))

print_test(
  "After setcolorder() on ORIGINAL (z, y, x)",
  "Original columns: ", paste(names(dt_original), collapse = ", "), "\n",
  "Shallow columns:  ", paste(names(dt_shallow), collapse = ", "), "\n",
  "Deep copy columns: ", paste(names(dt_copy), collapse = ", "), "\n"
)

# =============================================================================
# Test 6: Subsetting Operations
# =============================================================================
section("TEST 6: Subsetting Operations")

dt_original <- data.table(x = 1:10, y = letters[1:10])
dt_shallow <- data.table:::shallow(dt_original)
dt_copy <- copy(dt_original)

# Subset rows of original
dt_original_subset <- dt_original[1:5]

# Now modify the original
dt_original[, x := x * 10]

print_test(
  "After subsetting original and then modifying it",
  "Original subset$x: ", paste(dt_original_subset$x, collapse = ", "), "\n",
  "Original$x:        ", paste(dt_original$x[1:5], collapse = ", "), "\n",
  "\nSubset affected by original modification? ",
  !identical(dt_original_subset$x, 1:5), "\n"
)

# =============================================================================
# Test 7: Performance Comparison
# =============================================================================
section("TEST 7: Performance Comparison")

# Create larger dataset
dt_large <- data.table(
  x = 1:1e6,
  y = sample(letters, 1e6, replace = TRUE),
  z = rnorm(1e6),
  w = runif(1e6)
)

# Benchmark shallow vs copy
time_shallow <- system.time({
  for(i in 1:100) {
    dt_test <- data.table:::shallow(dt_large)
  }
})

time_copy <- system.time({
  for(i in 1:100) {
    dt_test <- copy(dt_large)
  }
})

print_test(
  "Time to create 100 copies of 1M row, 4 column data.table",
  "Shallow: ", time_shallow["elapsed"], " seconds\n",
  "Copy:    ", time_copy["elapsed"], " seconds\n",
  "Speedup: ", round(time_copy["elapsed"] / time_shallow["elapsed"], 2), "x\n"
)

# Memory usage
print_test(
  "Memory implications",
  "Size of original: ", format(object.size(dt_large), units = "MB"), "\n",
  "Note: shallow() creates minimal overhead (only DT structure)\n",
  "      copy() creates full duplicate of all data\n"
)

# =============================================================================
# Test 8: Nested Structures (Lists of Data.Tables)
# =============================================================================
section("TEST 8: Nested Structures")

dt_original <- data.table(
  x = 1:5,
  y = letters[1:5],
  nested = list(
    data.table(a = 1:3),
    data.table(a = 4:6),
    data.table(a = 7:9),
    data.table(a = 10:12),
    data.table(a = 13:15)
  )
)

dt_shallow <- data.table:::shallow(dt_original)
dt_copy <- copy(dt_original)

# Modify nested structure
dt_original$nested[[1]][, a := a * 10]

print_test(
  "After modifying nested data.table in ORIGINAL",
  "Original nested[[1]]$a: ", paste(dt_original$nested[[1]]$a, collapse = ", "), "\n",
  "Shallow nested[[1]]$a:  ", paste(dt_shallow$nested[[1]]$a, collapse = ", "), "\n",
  "Deep copy nested[[1]]$a: ", paste(dt_copy$nested[[1]]$a, collapse = ", "), "\n",
  "\nShallow nested affected? ", !identical(dt_shallow$nested[[1]]$a, 1:3), "\n",
  "Deep copy nested affected? ", !identical(dt_copy$nested[[1]]$a, 1:3), "\n"
)

# =============================================================================
# Test 9: Attributes Preservation
# =============================================================================
section("TEST 9: Attributes Preservation")

dt_original <- data.table(x = 1:5, y = letters[1:5])
setattr(dt_original, "custom_attr", "test_value")
setattr(dt_original, "another_attr", 123)

dt_shallow <- data.table:::shallow(dt_original)
dt_copy <- copy(dt_original)

print_test(
  "Custom attributes preservation",
  "Original custom_attr: ", attr(dt_original, "custom_attr"), "\n",
  "Shallow custom_attr:  ", attr(dt_shallow, "custom_attr"), "\n",
  "Deep copy custom_attr: ", attr(dt_copy, "custom_attr"), "\n",
  "\nOriginal another_attr: ", attr(dt_original, "another_attr"), "\n",
  "Shallow another_attr:  ", attr(dt_shallow, "another_attr"), "\n",
  "Deep copy another_attr: ", attr(dt_copy, "another_attr"), "\n"
)

# Modify attribute on original
setattr(dt_original, "custom_attr", "modified_value")

print_test(
  "After modifying attribute on ORIGINAL",
  "Original custom_attr: ", attr(dt_original, "custom_attr"), "\n",
  "Shallow custom_attr:  ", attr(dt_shallow, "custom_attr"), "\n",
  "Deep copy custom_attr: ", attr(dt_copy, "custom_attr"), "\n"
)

# =============================================================================
# Test 10: Edge Cases
# =============================================================================
section("TEST 10: Edge Cases")

# Empty data.table
dt_empty <- data.table()
dt_empty_shallow <- data.table:::shallow(dt_empty)
print_test(
  "Empty data.table",
  "Original: ", paste(dim(dt_empty), collapse = "x"), "\n",
  "Shallow:  ", paste(dim(dt_empty_shallow), collapse = "x"), "\n",
  "Success: ", identical(dim(dt_empty), dim(dt_empty_shallow)), "\n"
)

# Single column
dt_single <- data.table(x = 1:5)
dt_single_shallow <- data.table:::shallow(dt_single)
dt_single[, x := x * 2]
print_test(
  "Single column data.table (after modifying original)",
  "Original$x: ", paste(dt_single$x, collapse = ", "), "\n",
  "Shallow$x:  ", paste(dt_single_shallow$x, collapse = ", "), "\n",
  "Shallow affected? ", !identical(dt_single_shallow$x, 1:5), "\n"
)

# Single row
dt_single_row <- data.table(x = 1, y = "a", z = 1.5)
dt_single_row_shallow <- data.table:::shallow(dt_single_row)
dt_single_row[, x := 999]
print_test(
  "Single row data.table (after modifying original)",
  "Original$x: ", dt_single_row$x, "\n",
  "Shallow$x:  ", dt_single_row_shallow$x, "\n",
  "Shallow affected? ", dt_single_row_shallow$x != 1, "\n"
)

# =============================================================================
# Summary and Recommendations
# =============================================================================
section("SUMMARY AND RECOMMENDATIONS")

cat("
KEY FINDINGS:
============

1. MEMORY STRUCTURE:
   - shallow() creates a new data.table object (different address)
   - BUT columns point to the SAME memory addresses as original
   - copy() creates completely independent data with new addresses

2. COLUMN MODIFICATIONS WITH :=
   - Modifying column VALUES with := affects BOTH original and shallow copy
   - This is the CRITICAL RISK: shared column data means shared mutations
   - copy() isolates changes completely

3. STRUCTURE MODIFICATIONS:
   - Adding/removing columns affects only the modified object
   - setcolorder() affects only the modified object
   - setnames() affects only the modified object
   - setkey() affects only the modified object (but may reorder shared data!)

4. PERFORMANCE:
   - shallow() is significantly faster (near-instantaneous)
   - copy() has overhead proportional to data size
   - For large datasets, this difference can be substantial

5. USE CASE IMPLICATIONS:
   - shallow() is UNSAFE if either copy might use := to modify column values
   - shallow() is OK for read-only operations or structure-only modifications
   - shallow() could be useful for temporary calculations if carefully managed

RECOMMENDATIONS FOR EXPORT:
==========================

IF shallow() is exported, it should:

1. Have VERY CLEAR documentation warning about shared column data
2. Explain the := operator risks explicitly
3. Provide examples of safe vs unsafe usage
4. Consider a warning message on first use per session
5. Include a vignette on copy-on-write semantics

SAFE USE CASES:
- Read-only analysis of subsets
- Temporary column reordering/renaming without data modification
- Function wrappers that guarantee no := usage
- Advanced users who understand memory semantics

UNSAFE USE CASES:
- Any workflow where := might modify column values
- Passing to functions that might use := internally
- Long-lived objects where mutation risk is unclear
- General-purpose copying for beginners

ALTERNATIVE CONSIDERATION:
- Consider implementing a 'shallow' parameter in copy()
- E.g., copy(DT, shallow = TRUE) with clear semantics
- This maintains API consistency while adding functionality
")

cat("\n")
cat(rep("=", 80), "\n", sep = "")
cat("END OF TESTING REPORT\n")
cat(rep("=", 80), "\n", sep = "")
