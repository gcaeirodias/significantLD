# significantLD
This is a set of R functions to perform chi-squared tests on r2 correlation coefficients between pairs of loci (Linkage Disequilibrium) and to identify potentially linked loci.

SignificantLD takes as input one or more tables in the same format as produced by GUSLD function from [GUSLD R package](https://github.com/AgResearch/GUS-LD) to:
1. Perform chi-squared tests on r2 correlation coefficients;
2. Perform multicomaprisions corrections in each population;
3. Identify putative linked loci in each population and across populations.

##R packages needed

##Preparing input files
SignificantLD takes a tab separated text per population as input in the same format as produced by GUSLD. All files from populations to be compared must be in the same working directory and file names must have the same suffix. For example: `[custom_name]_chi2.txt'`. 

##parallelchi2
This is a function to perform chi-squared tests for r2 in parallel for a single population.

###Preparing input files
parallelchi2 takes a tab separated text file as input in the same format as produced by [GUSLD R package](https://github.com/AgResearch/GUS-LD).

###Usage
~~~
input
N
num_cores

~~~

###Usage
~~~
suffix
     Input file name suffix common to all input files.
     [Default: _ld_chi2.txt]
multi_corr
     The multi-comparison correction method to be used. The options are any method implemented on p.adjust {stats} R function.
     [Default: bonferroni]
~~~
###Arguments
