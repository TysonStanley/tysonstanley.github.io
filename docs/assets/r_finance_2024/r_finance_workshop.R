# example of binary search
binary_search <- function(arr, target) {
  left <- 1
  right <- length(arr)
  
  while (left <= right) {
    mid <- floor((left + right) / 2)
    
    if (arr[mid] == target) {
      return(mid)
    } else if (arr[mid] < target) {
      left <- mid + 1
    } else {
      right <- mid - 1
    }
  }
  
  return(-1)
}

# Example usage
sorted_vector <- c(1, 3, 5, 7, 9, 11, 13)
target <- 3
result <- binary_search(sorted_vector, target)
print(result)  # Should print the index of the target in the sorted vector

# example of vector scane
vector_scan_search <- function(arr, target) {
  for (i in seq_along(arr)) {
    if (arr[i] == target) {
      return(i)
    }
  }
  
  return(-1)
}

# Example usage
vector <- c(1, 3, 5, 7, 9, 11, 13)
target <- 3
result <- vector_scan_search(vector, target)
print(result)  # Should print the index of the target in the vector

library(data.table)
setkey(dt, var)
setkeyv(dt, "var")