# significantLD
This is a set of R functions to perform chi-squared tests for Linkage Disequilibrium and to identify potential loci linkage Disequilibrium across populations.

SignificantLD takes as input one or more matrices of XXXXXX in the same format as produced by GUSLD function from [GUSLD R package](https://github.com/AgResearch/GUS-LD) to:
1. Perform multicomaprisions corrections in each population;
2. Identify putative linked loci in each population and across population.

##R packages needed

##Preparing input files
SignificantLD takes a tab separated text per population as input in the same format as produced by GUSLD. All files from populations to be compared must be in the same working directory and file names must have the same suffix. For example: `[custom_name]_ld_chi2.txt'`. 

##Usage
~~~
suffix
     Input file name suffix common to all input files.
     [Default: _ld_chi2.txt]
multi_corr
     The multi-comparison correction method to be used. The options are any method implemented on p.adjust {stats} R function.
     [Default: bonferroni]
~~~
##Arguments
