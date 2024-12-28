# significantLD
This is a set of R functions to perform chi-squared tests on r<sup>2</sup> correlation coefficients between pairs of loci (Linkage Disequilibrium) and to identify potentially linked loci. Briefly, the functions provided:
1. Perform chi-squared tests on r<sup>2</sup> correlation coefficients;
2. Perform multicomaprisions corrections in each population;
3. Identify putative linked loci in each population and across populations based on corrected chi-squeared tests.

## R packages needed
- doParallel
- dplyr
- foreach
- parallel
- stringr
- tidyr (contains dplyr and stringr)

## parallelchi2
This is a function to perform chi-squared tests for r<sup>2</sup> in parallel for a single population.

### Preparing input files
`parallelchi2` takes a tab separated text file per population as input in the same format as produced by `GUSLD` function from [GUSLD R package](https://github.com/AgResearch/GUS-LD).

### Arguments
~~~
input_file
     Path to tab separated text file in the same format as produced by GUSLD.
     [default: NA]
N
     Number of loci in the input file.
     [default: NA]
num_cores
     Number of threads to run in parallel.
     [default: 2]
~~~

### Output
The output is the input tab separated text file with two extra columns, one containing the chi-squared tests (X2) and the other the associated p-values (p-value). The output file is named with the input prefix plus the sufix _chi2.txt: [input_prefix]_chi2.txt.

### Example
Running `parallelchi2` from the working dirfectory containing the input file named example.txt containing the pairwise r<sup>2</sup> correlation coefficients from 519 loci running with 4 threads.
~~~
parallelchi2(input_file = "example.txt", N = 519, num_cores = 4)
~~~

## multi_corr_LD
This is a function to perform corrections for multiple comparisons on chi-squared tests for each population (i.e., for each input file) in parallel. `multi_corr_LD` takes as input a set of files outputed by `parallelchi2` (one file per population).

### Arguments
~~~
suffix
     Input file name suffix common to all input files.
     [Default: "*_chi2.txt"]
multi_corr
     The multi-comparison correction method to be used. The options are any method implemented on p.adjust {stats} R function.
     [Default: "bonferroni"]
alpha = 0.05
     Significance value considered after multicomparison correction.
     [Default: 0.05]
num_cores
     Number of threads to run in parallel.
     [default: 2]
~~~

### Output
The function `multi_corr_LD` produces two outputs for each input used. First, it outputs the input tab separated text file with one extra column containing the adjusted p-values (Adjusted_p) named with the same prefix and the suffix _chi2_corr.txt. The second output is a file with the subset of significant loci obtained from the first output named with the same prefix and the suffix _signLD_loci.txt. 

### Example
Running `multi_corr_LD` from the working dirfectory with the input files (i.e., [input_prefix]_chi2.txt; one per population) containing the chi-squared test results and associated p-values with 2 threads.
~~~
multi_corr_LD(input_dir = getwd(), num_cores = 2)
~~~

## LD_pairs
This function executes a series of functions to identify the pairs of loci that are significantly linked across several populations. It takes as input a set of files outputed by `multi_corr_LD` (one file per population).
 

### Arguments
~~~
suffix
     Input file name suffix common to all input files.
     [Default: "*_signLD_loci.txt"]
n_pops
     Number of populations to consider a locus in linkage across populations.
     [default: 2]
~~~

### Output
The function `LD_pairs` outputs a tab separated text file named significant_ld_loci.txt with all pairs of loci that LD was significant at least in the number of populations defined by n_pops argument. The file contains five columns; the first two columns are the chromosome name from each locus in the LD pair, the next two columns are the position of the corresponding SNPs, and the last column is the numer of populations where each pair was identified in LD (column names: CHROM_SNP1\tCHROM_SNP2\tPOS_SNP1\tPOS_SNP2\tn).

### Example
Running `LD_pairs` from the working dirfectory with the input files (i.e., [input_prefix]_signLD_loci.txt; one per population) containing the pairs in LD for each population. A pair is considered in LD if found in significant linkage at least in three populations.
~~~
LD_pairs(n_pops = 3)
~~~

## LD_loci

### Arguments

### Output

### Example

## Citation
Please cite the article where these functions were first published: [Caeiro-Dias G, Osborne MJ, Turner TF (2024). Time is of the essence: using archived samples in the development a GT-seq panel to preserve continuity of ongoing genetic monitoring. Authorea](https://doi.org/10.22541/au.173501104.41338406/v1). 

## Contact
Send your questions, suggestions, or comments to gcaeirodias@unm.edu
