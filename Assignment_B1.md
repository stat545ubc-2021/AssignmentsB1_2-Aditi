Assignment\_B1
================
Aditi Nagaraj
01/11/2021

# Functions in R

## Introduction:

Functions are a way we automate common tasks that is more efficient and
powerful than copy-and-pasting. Writing a function has several
advantages over using copy-and-paste and some of them are:

-   A function with a descriptive name makes the code easier to
    understand.
-   With functions, the code only needs to be updated in one place,
    instead of many.
-   One can eliminate the chance of making incidental mistakes that
    often accompany copy and paste (i.e. updating a variable name in one
    place, but not in another).

The goal of this document is to demonstrate how to make/write, document
and test functions in R.

**Reference:** <https://r4ds.had.co.nz/functions.html>

## Table of Contents:

| S. no | Section                            |
|-------|------------------------------------|
| 1     | Setup                              |
| 2     | Exercise 1: Make a function        |
| 3     | Exercise 2: Document your function |
| 4     | Exercise 3: Include examples       |
| 5     | Exercise 4: Test the function      |

## Setup:

The first step to writing any R code is installing the required
libraries, setting up the environment etc., which is exactly what this
sub-section displays.

``` r
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──

    ## ✓ ggplot2 3.3.5     ✓ purrr   0.3.4
    ## ✓ tibble  3.1.5     ✓ dplyr   1.0.7
    ## ✓ tidyr   1.1.3     ✓ stringr 1.4.0
    ## ✓ readr   2.0.2     ✓ forcats 0.5.1

    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
library(datateachr)
library(gapminder)
library(palmerpenguins)
library(testthat)
```

    ## 
    ## Attaching package: 'testthat'

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     matches

    ## The following object is masked from 'package:purrr':
    ## 
    ##     is_null

    ## The following objects are masked from 'package:readr':
    ## 
    ##     edition_get, local_edition

    ## The following object is masked from 'package:tidyr':
    ## 
    ##     matches

We will next dive into writing and testing our function in R.

## Exercise 1: Make a function:

Throughout this course we have worked with various datasets either in
our worksheets or in our mini data analysis projects. These datasets had
one thing in common which was a combination of categorical columns and
numerical columns. This helped us make various data manipulations and
comparisons across the data. One of the data summarisation tasks that we
accomplished was to calculate summary statistics for a numerical column
based on a categorical column. We did this using the `group_by` and
`summarise` functions from the `dplyr` package in R. The `group_by`
function allowed us to group the results by the various categories of a
particular column and the `summarise` function allowed us to calculate
summary statistics like mean, range, standard deviation etc across those
categories.

Now imagine if we had to do this across a different categorical column
or compare two different categorical columns or perform calculations on
a different numerical column. We would have to write multiple lines of
`group_by` and `summarise` functions that take different input values.
This would increase the probability of introducing errors into the code.
To make it less error-prone and easier to follow, I will write my own
dplyr function that calculates summary statistics across different
inputs of categorical columns from a given dataset.

My function will calculate the mean and range across user specified
columns.

**Reference** <https://tidyeval.tidyverse.org/dplyr.html>

``` r
grouping_summarising = function(input, group, summary){
  
  group = rlang::enquo(group)
  summary = rlang::enquo(summary)
  
  check = summarise(input,
    is_text_group = is.character({{ group }}) | is.factor({{ group }}),
    class_group = class({{ group }}),
    is_numeric_summary = is.numeric({{ summary }}),
    class_summary = class({{ summary }})
  )
  if (!check$is_text_group) {
    stop("`x` column must contain text, but is of class: ",
         check$class_group)
  }
  if (!check$is_numeric_summary) {
    stop("`y` column must contain numeric, but is of class: ",
         check$class_summary)
  }
  
  # Create default column names
  summary_nm = as_label(summary)

  # Prepend with an informative prefix
  mean = paste0("mean_", summary_nm)
  minimum = paste0("min_", summary_nm)
  maximum = paste0("max_", summary_nm)
  
  res = input %>%
        group_by({{ group }}) %>%
        summarise({{ mean }} := mean({{ summary }}, na.rm = TRUE), 
              {{ minimum }} := min({{ summary }}, na.rm = TRUE), 
              {{ maximum }} := max({{ summary }}, na.rm = TRUE))

  return(res)
}
```

## Exercise 2: Document your function:

Documentation is a key aspect of good code. Without documentation users
will find it difficult to use functions or packages. The above function
is documented using roxygen2 tags.

**Reference:** <https://roxygen2.r-lib.org/articles/roxygen2.html>

``` r
#' @title A bundle of dplyr functions- group_by and summarise
#' 
#' This function calculates the summary statistics such as mean and range grouped by a categorical variable of your choice for an input dataset.
#' It uses the dplyr functions group_by and summarise to output a tibble or data frame depending on your input data type class. 
#' 
#' @param input A dataframe or tibble input.
#' @param group A categorical column in the dataframe/tibble that should be used for grouping.
#' @param summary A numerical column for which summary statistics are to be computed.
#' @param summary_nm Default column name for the summary variable columns
#' @param mean Stores the column name for the output summary statistic mean by adding "mean_" to the summary_nm
#' @param minimum Stores the column name for the output summary statistic min  by adding "min_" to the summary_nm
#' @param maximum Stores the column name for the output summary statistic max by adding "max_" to the summary_nm
#' @return A Tibble or dataframe built from a list and containing four columns- categorical variable by which the data is grouped, mean, minimum, maximum computed for a numerical variable.
#' @examples
#' grouped_summary_stats(data = vancouver_trees, group = common_name, summary = diameter)
#' grouped_summary_stats(data = penguins, group = island, summary = flipper_length_mm)
grouping_summarising = function(input, group, summary){
  
  group = rlang::enquo(group)
  summary = rlang::enquo(summary)
  
  check = summarise(input,
    is_text_group = is.character({{ group }}) | is.factor({{ group }}),
    class_group = class({{ group }}),
    is_numeric_summary = is.numeric({{ summary }}),
    class_summary = class({{ summary }})
  )
  if (!check$is_text_group) {
    stop("`x` column must contain text, but is of class: ",
         check$class_group)
  }
  if (!check$is_numeric_summary) {
    stop("`y` column must contain numeric, but is of class: ",
         check$class_summary)
  }
  
  # Create default column names
  summary_nm = as_label(summary)

  # Prepend with an informative prefix
  mean = paste0("mean_", summary_nm)
  minimum = paste0("min_", summary_nm)
  maximum = paste0("max_", summary_nm)
  
  res = input %>%
        group_by({{ group }}) %>%
        summarise({{ mean }} := mean({{ summary }}, na.rm = TRUE), 
              {{ minimum }} := min({{ summary }}, na.rm = TRUE), 
              {{ maximum }} := max({{ summary }}, na.rm = TRUE))
  
  return(res)
}
```

## Exercise 3: Include examples:

The following few code chunks will demonstrate the use of the above made
function across different datasets included within the `datateachr`
package and other packages such as `gapminder` and `palmerpenguins`.

**NOTE:** The function is made to work across different datasets
provided they have atleast one categorical and one numeric column and it
makes sense to use these columns for carrying out this function.

From the four examples shown below two work and two don’t and this was
done intentionally. The errors are further tested in Exercise 4 for
confirmation.

``` r
#Testing the function on the dataset I worked with before as part of my mini data analysis- Vancouver_trees. 
grouping_summarising(input = vancouver_trees, group = common_name, summary = diameter)
```

    ## # A tibble: 634 × 4
    ##    common_name               mean_diameter min_diameter max_diameter
    ##    <chr>                             <dbl>        <dbl>        <dbl>
    ##  1 ACCOLADE CHERRY                   20.8           3           42  
    ##  2 AKEBONO FLOWERING CHERRY           7.76          0           66  
    ##  3 ALDER SPECIES                     16.2           0           26.5
    ##  4 ALDERLEAFED MOUNTAIN ASH           4.67          2           19.8
    ##  5 ALIA'S MAGNOLIA                    5.33          5            5.5
    ##  6 ALLEGHENY SERVICEBERRY             2.92          1.5          5  
    ##  7 ALLGOLD EUROPEAN ASH               3.81          2           11.5
    ##  8 ALMIRA NORWAY MAPLE               17.4           5           29  
    ##  9 ALPINE FIR                         4             4            4  
    ## 10 AMANOGAWA JAPANESE CHERRY          8.52          3           26  
    ## # … with 624 more rows

``` r
#Testing the function on another dataset from the same datateachr package- apt_buildings. An example that does not work!
grouping_summarising(input = apt_buildings, group = property_type, summary = facilities_available)
```

    ## Error in grouping_summarising(input = apt_buildings, group = property_type, : `y` column must contain numeric, but is of class: character

``` r
#Testing function on gapminder dataset
grouping_summarising(input = gapminder, group = continent, summary = lifeExp)
```

    ## # A tibble: 5 × 4
    ##   continent mean_lifeExp min_lifeExp max_lifeExp
    ##   <fct>            <dbl>       <dbl>       <dbl>
    ## 1 Africa            48.9        23.6        76.4
    ## 2 Americas          64.7        37.6        80.7
    ## 3 Asia              60.1        28.8        82.6
    ## 4 Europe            71.9        43.6        81.8
    ## 5 Oceania           74.3        69.1        81.2

``` r
#Testing function on penguins dataset- An example that does not work!
grouping_summarising(input = penguins, group = species, summary = island)
```

    ## Error in grouping_summarising(input = penguins, group = species, summary = island): `y` column must contain numeric, but is of class: factor

## Exercise 4: Test the function:

This final exercise helps to formally test the above built function to
see if it is performing the way we expect it to perform. Testing of the
function is carried out using the `testthat` package in R. I have
conducted a series of six tests:

**Reference:** <https://testthat.r-lib.org/reference/index.html>

-   The first is to test that if input columns are incorrect types as
    compared to what the function expects, it throws an error (as we saw
    in the two examples in the section above).

``` r
test_that("Incorrect column types throw an error.", {
  expect_error(grouping_summarising(input = apt_buildings, group = property_type, summary = facilities_available))
  expect_error(grouping_summarising(input = penguins, group = species, summary = island))
})
```

    ## Test passed 🥳

-   The second is to show how having all NA values across all categories
    throws the function off since mean and range cannot be computed on
    NA values.

``` r
test_that("A column of only NAs for numeric variable throws an error", {
input = tribble(
  ~x, ~y,  
  "a", NA,
  "a", NA,
  "b", NA,
  "b", NA,
)
expect_error(grouping_summarising(input, group = x, summary = y))
})
```

    ## Test passed 🌈

-   The third test shows that having values across the different
    categories successfully provides an output in the form of a tibble.

``` r
test_that("A column of values for numerical variable is a success and returns a tibble", {
input = tribble(
  ~x, ~y,  
  "a", 1,
  "a", 2,
  "b", 3,
  "b", 4,
)
result = grouping_summarising(input, group = x, summary = y)
expect_s3_class(result, "tbl")
})
```

    ## Test passed 🌈

-   The fourth test shows that having NA values distributed between the
    different categories still provides an output in the form of a
    tibble.

``` r
test_that("A column of values for numerical variable is a success and returns a tibble", {
input = tribble(
  ~x, ~y,  
  "a", NA,
  "a", 2,
  "b", NA,
  "b", 4,
)
result = grouping_summarising(input, group = x, summary = y)
expect_s3_class(result, "tbl")
})
```

    ## Test passed 😀

-   The fifth test shows that if NA values are confined to a particular
    category the function still runs but gives out a warning message.

``` r
test_that("A column of values for numerical variable is a success and returns a tibble", {
input = tribble(
  ~x, ~y,  
  "a", NA,
  "a", NA,
  "b", 3,
  "b", 4,
)
expect_warning(grouping_summarising(input, group = x, summary = y))
})
```

    ## Test passed 🎉

-   The sixth and final test indicates the type of the output generated.

``` r
test_that("Output type is a list", {
result = grouping_summarising(input = gapminder, group = continent, summary = lifeExp)
expect_type(result, "list")
})
```

    ## Test passed 🎉
