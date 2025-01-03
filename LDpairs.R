library(dplyr)

# Function to load all files with significant LD loci from all populations (from multi_corr_LD.R).
load_ld_files <- function(suffix = "*_signLD_loci.txt") {
  ld_files <- list.files(pattern = suffix, recursive = FALSE)
  if (length(ld_files) == 0) {
    stop("No files found with the suffix:", suffix)
  }
  ld_data <- lapply(ld_files, function(file) {
    tryCatch(
      read.delim(file),
      error = function(e) {
        cat("Error reading file:", file, "\n", e, "\n")
        return(NULL)
      }
    )
  })
  ld_data <- ld_data[!sapply(ld_data, is.null)]
  return(ld_data)
}

# Function to identify and sort by the first four columns (CHROM_SNP1, CHROM_SNP2,	POS_SNP1,	POS_SNP2)
# the significant LD loci found at least in one population.
combine_ld_loci <- function(ld_data) {
  ld_pairs <- data.frame(
    CHROM_SNP1 = character(),
    CHROM_SNP2 = character(),
    POS_SNP1 = character(),
    POS_SNP2 = character(),
    stringsAsFactors = FALSE
  )
  for (ld in ld_data) {
    to_rbind <- ld[, 2:5]
    ld_pairs <- rbind(ld_pairs, to_rbind)
  }
  ld_pairs_sorted <- ld_pairs[order(ld_pairs[, 1], ld_pairs[, 2], ld_pairs[, 3], ld_pairs[, 4]), ]
  return(ld_pairs_sorted)
}

# Function to count occurrences of each unique LD pair.
count_ld_pairs <- function(ld_pairs_sorted) {
  ld_pairs_counts <- ld_pairs_sorted %>%
    count(CHROM_SNP1, CHROM_SNP2, POS_SNP1, POS_SNP2, sort = TRUE)
  return(ld_pairs_counts)
}

# Function to filter pairs that are found in at least 'n_pops' populations.
filter_ld_pairs_by_pop <- function(ld_pairs_counts, n_pops) {
  ld_pairs_across_pops <- subset(ld_pairs_counts, rowSums(ld_pairs_counts[5] == n_pops) > 0)
  return(ld_pairs_across_pops)
}

# Function to save results.
save_ld_files <- function(ld_pairs_across_pops_sorted) {
  write.table(ld_pairs_across_pops_sorted, file = "significant_ld_loci.txt", quote = FALSE, sep = "\t", col.names = TRUE, row.names = FALSE)
}

# Function to run all previous functions sequentially.
LDpairs <- function(suffix = "*_signLD_loci.txt", n_pops = 2) {
  
  # Step 1: Load files with with significant LD loci.
  ld_data <- load_ld_files(suffix)
  # Step 2: Combine significant LD loci from all populations.
  ld_pairs_sorted <- combine_ld_loci(ld_data)
  # Step 3: Count occurrences of each unique LD pair.
  ld_pairs_counts <- count_ld_pairs(ld_pairs_sorted)
  # Step 4: Filter pairs that are found in at least 'n_pops' populations.
  ld_pairs_across_pops <- filter_ld_pairs_by_pop(ld_pairs_counts, n_pops)
  # Step 5: Sort the filtered LD pairs for final output.
  ld_pairs_across_pops_sorted <- ld_pairs_across_pops[order(ld_pairs_across_pops$CHROM_SNP1, ld_pairs_across_pops$CHROM_SNP2, ld_pairs_across_pops$POS_SNP1, ld_pairs_across_pops$POS_SNP2), ]
  # Step 6: Save the results.
  save_ld_files(ld_pairs_across_pops_sorted)
  
  # Return the results in case further analysis is needed.
  return(list(
    ld_pairs_counts = ld_pairs_counts,
    ld_pairs_across_pops = ld_pairs_across_pops,
    ld_pairs_across_pops_sorted = ld_pairs_across_pops_sorted
  ))
}
