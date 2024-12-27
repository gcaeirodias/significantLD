# significantLD
This is a set of R functions to perform chi-squared tests on r<sup>2</sup> correlation coefficients between pairs of loci (Linkage Disequilibrium) and to identify potentially linked loci. Briefly, the functions provided:
1. Perform chi-squared tests on r<sup>2</sup> correlation coefficients;
2. Perform multicomaprisions corrections in each population;
3. Identify putative linked loci in each population and across populations based on corrected chi-squeared tests.

## R packages needed
- foreach
- doParallel
- stringr

## parallelchi2
This is a function to perform chi-squared tests for r<sup>2</sup> in parallel for a single population.

### Preparing input files
`parallelchi2` takes a tab separated text file per population as input in the same format as produced by [GUSLD function from GUSLD R package](https://github.com/AgResearch/GUS-LD).

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
This function executes a series of functions to identify the pairs of loci that are significant across populations. It takes as input the 

### Arguments
~~~

~~~
