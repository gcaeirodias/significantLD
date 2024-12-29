library(dplyr)
library(tidyr)

# Define function to identify linked loci with more other loci to remove.
select_LDloci <- function(input_file = "significant_ld_loci.txt", output_file = "linked_loci_to_remove.txt") {
  # Read input and format for downstream analysis.
  data <- read.table(input_file, header = TRUE, stringsAsFactors = FALSE)
  data <- data %>%
    mutate(
      SNP1 = paste(CHROM_SNP1, POS_SNP1, sep = ":"),
      SNP2 = paste(CHROM_SNP2, POS_SNP2, sep = ":")
    ) %>%
    select(SNP1, SNP2)
  unique_values <- unique(c(data$SNP1, data$SNP2))
  
  # Sub-function to find the locus linked to the maximum number of other loci.
  find_max_linked_SNPs <- function(data) {
    non_na_rows <- complete.cases(data)
    linked_count <- table(c(data$SNP1[non_na_rows], data$SNP2[non_na_rows]))
    max_linked_SNPs <- names(linked_count)[which.max(linked_count)]
    return(max_linked_SNPs)
  }
  
  # Iteratively remove locus linked to the most other loci.
  while (nrow(data) > 0) {
    tryCatch({
      max_linked_SNPs <- find_max_linked_SNPs(data)
      # Check if a valid value for max_linked_SNPs is found.
      if (is.null(max_linked_SNPs) || max_linked_SNPs == 0) {
        break
        }
      # Remove the specific value from both columns.
      data <- data %>%
        mutate(
          SNP1 = ifelse(SNP1 == max_linked_SNPs, NA, SNP1),
          SNP2 = ifelse(SNP2 == max_linked_SNPs, NA, SNP2)
        ) %>%
        filter(!(is.na(SNP1) & is.na(SNP2)))
    }, error = function(e) {
      message("Error while processing max_linked_value: ", e$message)
      break
    })
    # Exit loop if no rows remain.
    if (nrow(data) == 0) break
    }
  
  # Select the loci to remove and format to export.
  loci_to_keep <- unique(na.omit(c(data$SNP1, data$SNP2)))
  loci_to_remove <- as.data.frame(setdiff(unique_values, loci_to_keep), stringsAsFactors = FALSE)
  colnames(loci_to_remove) <- "SNP"
  loci_to_remove <- loci_to_remove %>%
    separate(SNP, into = c("CHROM", "SNP"), sep = ":", remove = FALSE)
  
  # Write the result to a tab separated text file.
  write.table(
    loci_to_remove,
    output_file,
    sep = "\t",
    row.names = FALSE,
    col.names = FALSE,
    quote = FALSE
  )
  
  # Return the loci to remove as a data frame for further analysis if needed.
  return(loci_to_remove)
}
