library(foreach)
library(doParallel)
library(stringr)

## Function to perform chi-squared tests for LD in parallel.
parallelchi2 <- function(input_file, N, num_cores = 2) {
  # Import table in the same format as produced by GUSLD function from GUSLD R package.
  LDres <- read.table(input_file, header = TRUE)
  
  # Add two empty columns for chi-squared values (X2) and associated p-values.
  LDres <- cbind(LDres, "X2" = NA, "p-value" = NA)
  
  # Register parallel backend.
  registerDoParallel(cores = num_cores)
  
  # Estimate X2 and associated p-values in parallel.
  results <- foreach(f = 1:nrow(LDres), .combine = rbind) %dopar% {
    r2 <- as.numeric(LDres[f, 1])
    X2 <- r2 * N
    p <- pchisq(X2, df = 1, lower.tail = FALSE)
    c(X2, p)
  }
  # Assign the computed values to the respective columns and save the results.
  LDres$X2 <- results[, 1]
  LDres$`p-value` <- results[, 2]
  output_file <- str_replace(input_file, "\\.txt$", "_chi2.txt")
  write.table(LDres, file = output_file, quote = FALSE, sep = "\t", col.names = TRUE, row.names = FALSE)
  
  # Stop the parallel backend.
  stopImplicitCluster()
  # Return the output file name for reference.
  return(output_file)
}
