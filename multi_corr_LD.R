library(parallel)
library(stringr)

# Define the function to correct chi-squared tests for multiple comparisons for each input file in parallel.
multi_corr_LD <- function(input_dir, suffix = "*_chi2.txt", multi_corr = "bonferroni", alpha = 0.05, num_cores = 2) {
  setwd(input_dir)
  # Create a list of input file names containing the X2 and p-value columns.
  files <- list.files(pattern = suffix)
  
  # Sub-function to process each input file.
  process_file <- function(file) {
    LDres <- read.table(file, header = TRUE)
    
    # Sort comparisons by p-value (lowest to the highest) and perform p-value adjustments using the specified method.
    LDres <- LDres[order(LDres$p.value), ]
    LDres$Adjusted_p <- p.adjust(LDres$p.value, method = multi_corr)
    
    # Save results.
    corrected_name <- str_replace(file, "_chi2.txt", "_chi2_corr.txt")
    write.table(LDres, file = corrected_name, quote = FALSE, sep = "\t", col.names = TRUE, row.names = FALSE)
    
    # Extract significant pairs based on the adjusted p-values.
    ld_pairs <- LDres[LDres$Adjusted_p < alpha, ]
    significant_name <- str_replace(file, "_chi2.txt", "_signLD_loci.txt")
    write.table(ld_pairs, file = significant_name, quote = FALSE, sep = "\t", col.names = TRUE, row.names = FALSE)
  }
  
  # Process files in parallel.
  mclapply(files, process_file, mc.cores = num_cores)
}
