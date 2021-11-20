STAT545B Assignment B2- Aditi Nagaraj Nallan
================
Aditi Nagaraj Nallan
11/17/2021

# Overview:

This github repository contains two components encompassing Assignments-
[B1](https://stat545.stat.ubc.ca/assignments/assignment-b1/) and
[B2](https://stat545.stat.ubc.ca/assignments/assignment-b2/) in the UBC
graduate course [STAT 545](https://stat545.stat.ubc.ca/). The first
component is a folder called `Assignment_B1` which contains a function,
its description and usage. This is included within a package called
`SummaryStat` which is the second component of this repository.

A short description of the function along with its usage and test cases
are provided in the path- `Assignment_B1/Assignment_B1.md` which was
submitted as part of Assignment B1.

For Assignment B2, the aforementioned function was wrapped in an R
package. A description of the package, installation instructions and
example usage is provided below as part of this README file.

## Package description:

**Package name:** SummaryStat

**Package creator:** Aditi Nagaraj Nallan

**Package version:** 0.1.0

`SummaryStat` is a package made by Aditi Nagaraj Nallan for the STAT545B
graduate course at The University of British Columbia. This package was
made in R using the `devtools` package and is mainly used for
calculating various summary statistics across different numerical and
categorical variables from input datasets. The main goal of this package
is to make exploratory data analysis efficient and easy for users.

Currently, this package contains only one function called
`dplyr_bundle`.

This function bundles together two dplyr functions- `group_by` and
`summarise` to calculate the summary statistics such as mean and range
for a numerical variable grouped by a categorical variable (both of
which are user choice) from an input dataset. The input dataset can
either be one of the publicly available datasets from packages such as
`gapminder`, `datateachr` and `palmerpenguins` or any user-defined input
dataset.

Further developments to the package will include addition of a function
that counts the observations across specified categorical variables and
another function that plots the various summary statistics.

Installation and example usage is shown below.

## Installation:

Since the package is currently under development, only the development
version from github is available. Once the package is submitted to
[CRAN](https://CRAN.R-project.org) a released version with updated
installation instructions will be available.

The development version from [GitHub](https://github.com/) can be
installed as follows:

``` r
# install.packages("devtools")
devtools::install_github("stat545ubc-2021/SummaryStat")
```

    ## Downloading GitHub repo stat545ubc-2021/SummaryStat@HEAD

    ## 
    ##      checking for file ‘/tmp/RtmpDxQq7n/remotes362d71283e37/stat545ubc-2021-SummaryStat-6ea5417/DESCRIPTION’ ...  ✓  checking for file ‘/tmp/RtmpDxQq7n/remotes362d71283e37/stat545ubc-2021-SummaryStat-6ea5417/DESCRIPTION’
    ##   ─  preparing ‘SummaryStat’:
    ##      checking DESCRIPTION meta-information ...  ✓  checking DESCRIPTION meta-information
    ##   ─  checking for LF line-endings in source and make files and shell scripts
    ##   ─  checking for empty or unneeded directories
    ##   ─  building ‘SummaryStat_0.1.0.tar.gz’
    ##      
    ## 

    ## Installing package into '/tmp/Rtmpa9Dsod/temp_libpath332559bdbad9'
    ## (as 'lib' is unspecified)

## Example Usage:

As specified in the package description, the `dplyr_bundle` function
from the package can be used for publicly available datasets and user
input datasets as well. The next few code chunks show instances of using
the function for both of these cases.

``` r
# Before running the function load the package.
library(SummaryStat)
```

**1. Publicly available datasets**

There are many publicly available datasets within packages such as
`gapminder`, `palmerpenguins` and `datateachr`. One of these datasets
that I will show here is the `penguins` dataset from the
`palmerpenguins` package. The following example uses the `dplyr_bundle`
function to calculate mean and range of the flipper length of different
penguin species. Here the categorical variable would be `species` and
numerical variable would be `flipper_length_mm`.

``` r
SummaryStat::dplyr_bundle(palmerpenguins::penguins, group = species, summary = flipper_length_mm)
```

    ## # A tibble: 3 × 4
    ##   species   mean_flipper_length_mm min_flipper_length_mm max_flipper_length_mm
    ##   <fct>                      <dbl>                 <int>                 <int>
    ## 1 Adelie                      190.                   172                   210
    ## 2 Chinstrap                   196.                   178                   212
    ## 3 Gentoo                      217.                   203                   231

**2. User input datasets**

These datasets can be anything that the user is currently analyzing or
will analyze in the future. An example dataset to test the function is
provided along with this package and is located in the `data-raw`
folder. The file is called `Abundance.csv`

``` r
data = read.csv("https://raw.githubusercontent.com/stat545ubc-2021/SummaryStat/main/data-raw/Abundance.csv", header = TRUE, sep = ",")
SummaryStat::dplyr_bundle(data, lineage, TPM)
```

    ## # A tibble: 4 × 4
    ##   lineage             mean_TPM min_TPM max_TPM
    ##   <fct>                  <dbl>   <dbl>   <dbl>
    ## 1 Bacteria                6.26    1.02    19.2
    ## 2 Bacteroidetes          72.4    41.1    133. 
    ## 3 Clostridiales          32.5     2.47   140. 
    ## 4 Deltaproteobacteria    14.7     1.45    53.3

To use your own dataset as shown above, read the file from the
appropriate location on your system and store it. Load the package
`SummaryStat` and then call the function `dplyr_bundle` to compute
summary statistics for the stored data.
