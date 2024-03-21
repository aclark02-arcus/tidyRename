
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidyRename

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

Project built off of this [pull
request](https://github.com/atorus-research/xportr/pull/11/files).

## Installation

You can install the development version of tidyRename from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("aclark02-arcus/tidyRename")
```

## Purpose

# What are the checks?

<br>

- Variable names must start with a letter (not an underscore), be
  comprised of only uppercase letters (A-Z), numerals (0-9) and be free
  of non-ASCII characters, symbols, and underscores.
- Allotted length for each column containing character (text) data
  should be set to the maximum length of the variable used across all
  data sets (≤ 200)
- Coerces variables to only numeric or character types
- Display format support for numeric float and date/time values
- Variables names are ≤ 8 characters.
- Variable labels are ≤ 200 characters.
- Data set labels are ≤ 40 characters.
- Presence of non-ASCII characters in Variable Names, Labels or data set
  labels.

## Example

This is a basic example which shows you how to solve a common problem:

``` r
# library(tidyRename)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
