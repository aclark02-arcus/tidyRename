
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidyRename

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

## Purpose

`{tidyRename}` was originally designed for automating the creation of
submission compliant variable attributes for SAS v5 Transport files
(i.e. \<=8 characters for variable names, among other things). However,
the same concepts can be expanded to CSR activities i.e., SDTM variables
mapping process etc. to ensure uniformity among users and eliminates
wasted time manually creating easily-readable variable names for high
dimensional data sets. In fact, `{tidyRename}` can be useful outside of
the pharma industry as well - it’s a handy “renamer”. Just give it a
vector of strings, and it will tidy them up for you to meet your custom
needs. See example use cases below!

## Origins

Project built off of this
[contribution](https://github.com/atorus-research/xportr/pull/11/files)
to [{xportr}](https://github.com/atorus-research/xportr) from the
[{pharmaverse}](https://pharmaverse.org/)

## What are the checks?

If you interested in using `{tidyRename}` for submission compliance to
regulatory bodies, here’s what you can expect from it’s output:

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

## Installation

You can install the development version of tidyRename from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("aclark02-arcus/tidyRename")
```

## Example use cases

### Renaming strings

This is a basic example which shows you how to solve a common problem
with raw data variable names, manipulated as a character vector:

``` r
library(tidyRename)

## basic example converting 
vars <- c("", "studyid", "STUDYID", "subject id", "1c. ENT", "1b. Eyes",
          "1d. Lungs", "1e. Heart", "year number", "1a. Skin_Desc")

# Default behavior
tidy_rename(vars)
#> 
#> The following variable name validation checks failed:
#> * Must be 8 characters or less: Variables `subject id`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> * Must start with a letter: Variables `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, and `1a. Skin_Desc`.
#> * Cannot contain any non-ASCII, symbol or underscore characters: Variables `subject id`, `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> * Cannot contain any lowercase characters Variables ``, `studyid`, `subject id`, `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> 
#> 
#> ── 10 of 10 (100%) variables were renamed ──
#> 
#> Var 1:  '' was renamed to 'V1'
#> Var 2:  'studyid' was renamed to 'STUDYID'
#> Var 3:  'STUDYID' was renamed to 'STUDYID2'
#> Var 4:  'subject id' was renamed to 'SUBJECTD'
#> Var 5:  '1c. ENT' was renamed to 'ENT1C'
#> Var 6:  '1b. Eyes' was renamed to 'EYES1B'
#> Var 7:  '1d. Lungs' was renamed to 'LUNGS1D'
#> Var 8:  '1e. Heart' was renamed to 'HEART1E'
#> Var 9:  'year number' was renamed to 'YEARNUMB'
#> Var 10:  '1a. Skin_Desc' was renamed to 'SKNDSC1A'
#> 
#> All renamed variables passed validation.
#>  [1] "V1"       "STUDYID"  "STUDYID2" "SUBJECTD" "ENT1C"    "EYES1B"  
#>  [7] "LUNGS1D"  "HEART1E"  "YEARNUMB" "SKNDSC1A"
```

The user can alter the final letter case of the output by specifying
“upper”, “lower”, or “asis” to maintain the input string case:

``` r
# maintain source case
tidy_rename(vars, letter_case = "asis") 
#> 
#> The following variable name validation checks failed:
#> * Must be 8 characters or less: Variables `subject id`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> * Must start with a letter: Variables `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, and `1a. Skin_Desc`.
#> * Cannot contain any non-ASCII, symbol or underscore characters: Variables `subject id`, `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> * Cannot contain any lowercase characters Variables ``, `studyid`, `subject id`, `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> 
#> ── 8 of 10 (80%) variables were renamed ──
#> 
#> Var 1:  '' was renamed to 'V1'
#> Var 4:  'subject id' was renamed to 'subjectd'
#> Var 5:  '1c. ENT' was renamed to 'ENT1c'
#> Var 6:  '1b. Eyes' was renamed to 'Eyes1b'
#> Var 7:  '1d. Lungs' was renamed to 'Lungs1d'
#> Var 8:  '1e. Heart' was renamed to 'Heart1e'
#> Var 9:  'year number' was renamed to 'yearnumb'
#> Var 10:  '1a. Skin_Desc' was renamed to 'SknDsc1a'
#> 
#> The following variable name validation checks still failed:
#> Cannot contain any lowercase characters Variables `studyid`, `subjectd`, `ENT1c`, `Eyes1b`, `Lungs1d`, `Heart1e`, `yearnumb`, and `SknDsc1a`.
#>  [1] "V1"       "studyid"  "STUDYID"  "subjectd" "ENT1c"    "Eyes1b"  
#>  [7] "Lungs1d"  "Heart1e"  "yearnumb" "SknDsc1a"
```

By default, SAS v5 transport files require variable names to be 8 or
less characters, but `{tidyRename}` can accept custom character lengths
for the final output:

``` r
# Set Custom character length in output
tidy_rename(vars, char_len = 10)
#> 
#> The following variable name validation checks failed:
#> * Must be 8 characters or less: Variables `subject id`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> * Must start with a letter: Variables `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, and `1a. Skin_Desc`.
#> * Cannot contain any non-ASCII, symbol or underscore characters: Variables `subject id`, `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> * Cannot contain any lowercase characters Variables ``, `studyid`, `subject id`, `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> 
#> ── 10 of 10 (100%) variables were renamed ──
#> 
#> Var 1:  '' was renamed to 'V1'
#> Var 2:  'studyid' was renamed to 'STUDYID'
#> Var 3:  'STUDYID' was renamed to 'STUDYID2'
#> Var 4:  'subject id' was renamed to 'SUBJECTID'
#> Var 5:  '1c. ENT' was renamed to 'ENT1C'
#> Var 6:  '1b. Eyes' was renamed to 'EYES1B'
#> Var 7:  '1d. Lungs' was renamed to 'LUNGS1D'
#> Var 8:  '1e. Heart' was renamed to 'HEART1E'
#> Var 9:  'year number' was renamed to 'YEARNUMBER'
#> Var 10:  '1a. Skin_Desc' was renamed to 'SKINDESC1A'
#> 
#> The following variable name validation checks still failed:
#> Must be 8 characters or less: Variables `SUBJECTID`, `YEARNUMBER`, and `SKINDESC1A`.
#>  [1] "V1"         "STUDYID"    "STUDYID2"   "SUBJECTID"  "ENT1C"     
#>  [6] "EYES1B"     "LUNGS1D"    "HEART1E"    "YEARNUMBER" "SKINDESC1A"
```

Usually, you don’t want a number to be the first character of your
variable name. By default, those numbers will be relocated to the end of
the string. However, if you want to keep them up front, that’s possible!
But we recommend you add a letter prefix as seen below:

``` r
# Leave numerical prefix on left-hand side, but add a starting letter
tidy_rename(vars, relo_2_end = FALSE, letter_for_num_prefix = "q")
#> 
#> The following variable name validation checks failed:
#> * Must be 8 characters or less: Variables `subject id`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> * Must start with a letter: Variables `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, and `1a. Skin_Desc`.
#> * Cannot contain any non-ASCII, symbol or underscore characters: Variables `subject id`, `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> * Cannot contain any lowercase characters Variables ``, `studyid`, `subject id`, `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> 
#> ── 10 of 10 (100%) variables were renamed ──
#> 
#> Var 1:  '' was renamed to 'V1'
#> Var 2:  'studyid' was renamed to 'STUDYID'
#> Var 3:  'STUDYID' was renamed to 'STUDYID2'
#> Var 4:  'subject id' was renamed to 'SUBJECTD'
#> Var 5:  '1c. ENT' was renamed to 'Q1CENT'
#> Var 6:  '1b. Eyes' was renamed to 'Q1BEYES'
#> Var 7:  '1d. Lungs' was renamed to 'Q1DLUNGS'
#> Var 8:  '1e. Heart' was renamed to 'Q1EHEART'
#> Var 9:  'year number' was renamed to 'YEARNUMB'
#> Var 10:  '1a. Skin_Desc' was renamed to 'Q1SKNDSC'
#> 
#> All renamed variables passed validation.
#>  [1] "V1"       "STUDYID"  "STUDYID2" "SUBJECTD" "Q1CENT"   "Q1BEYES" 
#>  [7] "Q1DLUNGS" "Q1EHEART" "YEARNUMB" "Q1SKNDSC"
```

Sometimes you’ll have some common variable names that you’ll always want
to change to a standard name. For that use case, just specify a
“dictionary data.frame”, as seen in the below example:

``` r
# Add a dictionary and remove underscores - impacts var 4
tidy_rename(vars, sep = "",
dict_dat = data.frame(original_varname = "subject id", dict_varname = "subjid"))
#> 
#> The following variable name validation checks failed:
#> * Must be 8 characters or less: Variables `subject id`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> * Must start with a letter: Variables `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, and `1a. Skin_Desc`.
#> * Cannot contain any non-ASCII, symbol or underscore characters: Variables `subject id`, `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> * Cannot contain any lowercase characters Variables ``, `studyid`, `subject id`, `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> 
#> ── 10 of 10 (100%) variables were renamed ──
#> 
#> Var 1:  '' was renamed to 'V1'
#> Var 2:  'studyid' was renamed to 'STUDYID'
#> Var 3:  'STUDYID' was renamed to 'STUDYID2'
#> Var 4:  'subject id' was renamed to 'SUBJID'
#> Var 5:  '1c. ENT' was renamed to 'ENT1C'
#> Var 6:  '1b. Eyes' was renamed to 'EYES1B'
#> Var 7:  '1d. Lungs' was renamed to 'LUNGS1D'
#> Var 8:  '1e. Heart' was renamed to 'HEART1E'
#> Var 9:  'year number' was renamed to 'YEARNUMB'
#> Var 10:  '1a. Skin_Desc' was renamed to 'SKNDSC1A'
#> 
#> All renamed variables passed validation.
#>  [1] "V1"       "STUDYID"  "STUDYID2" "SUBJID"   "ENT1C"    "EYES1B"  
#>  [7] "LUNGS1D"  "HEART1E"  "YEARNUMB" "SKNDSC1A"
```

### Renaming data frame variable attributes directly

These basic examples shows you how to use `{tidyRename}` to manipulated
a data.frame object’s variable attributes directly, returning the input
data.frame:

``` r
vars <- c("", "STUDYID", "studyid", "subject id", "1c. ENT", "1b. Eyes",
      "1d. Lungs", "1e. Heart", "year number", "1a. Skin_Desc")
adxx <- data.frame(matrix(0, ncol = 10, nrow = 3))
colnames(adxx) <- vars


tidy_varnames(adxx) # default
#> 
#> The following variable name validation checks failed:
#> * Must be 8 characters or less: Variables `subject id`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> * Must start with a letter: Variables `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, and `1a. Skin_Desc`.
#> * Cannot contain any non-ASCII, symbol or underscore characters: Variables `subject id`, `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> * Cannot contain any lowercase characters Variables ``, `studyid`, `subject id`, `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> 
#> ── 9 of 10 (90%) variables were renamed ──
#> 
#> Var 1:  '' was renamed to 'V1'
#> Var 3:  'studyid' was renamed to 'STUDYID2'
#> Var 4:  'subject id' was renamed to 'SUBJECTD'
#> Var 5:  '1c. ENT' was renamed to 'ENT1C'
#> Var 6:  '1b. Eyes' was renamed to 'EYES1B'
#> Var 7:  '1d. Lungs' was renamed to 'LUNGS1D'
#> Var 8:  '1e. Heart' was renamed to 'HEART1E'
#> Var 9:  'year number' was renamed to 'YEARNUMB'
#> Var 10:  '1a. Skin_Desc' was renamed to 'SKNDSC1A'
#> 
#> All renamed variables passed validation.
#>   V1 STUDYID STUDYID2 SUBJECTD ENT1C EYES1B LUNGS1D HEART1E YEARNUMB SKNDSC1A
#> 1  0       0        0        0     0      0       0       0        0        0
#> 2  0       0        0        0     0      0       0       0        0        0
#> 3  0       0        0        0     0      0       0       0        0        0

tidy_varnames(adxx, relo_2_end = FALSE, letter_for_num_prefix = "q") # prefix numbers on left-hand side
#> 
#> The following variable name validation checks failed:
#> * Must be 8 characters or less: Variables `subject id`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> * Must start with a letter: Variables `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, and `1a. Skin_Desc`.
#> * Cannot contain any non-ASCII, symbol or underscore characters: Variables `subject id`, `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> * Cannot contain any lowercase characters Variables ``, `studyid`, `subject id`, `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> 
#> ── 9 of 10 (90%) variables were renamed ──
#> 
#> Var 1:  '' was renamed to 'V1'
#> Var 3:  'studyid' was renamed to 'STUDYID2'
#> Var 4:  'subject id' was renamed to 'SUBJECTD'
#> Var 5:  '1c. ENT' was renamed to 'Q1CENT'
#> Var 6:  '1b. Eyes' was renamed to 'Q1BEYES'
#> Var 7:  '1d. Lungs' was renamed to 'Q1DLUNGS'
#> Var 8:  '1e. Heart' was renamed to 'Q1EHEART'
#> Var 9:  'year number' was renamed to 'YEARNUMB'
#> Var 10:  '1a. Skin_Desc' was renamed to 'Q1SKNDSC'
#> 
#> All renamed variables passed validation.
#>   V1 STUDYID STUDYID2 SUBJECTD Q1CENT Q1BEYES Q1DLUNGS Q1EHEART YEARNUMB
#> 1  0       0        0        0      0       0        0        0        0
#> 2  0       0        0        0      0       0        0        0        0
#> 3  0       0        0        0      0       0        0        0        0
#>   Q1SKNDSC
#> 1        0
#> 2        0
#> 3        0

my_dictionary <- data.frame(original_varname = "subject id", dict_varname = "subjid")
tidy_varnames(adxx, dict_dat  = my_dictionary) # 'SUBJID' used
#> 
#> The following variable name validation checks failed:
#> * Must be 8 characters or less: Variables `subject id`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> * Must start with a letter: Variables `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, and `1a. Skin_Desc`.
#> * Cannot contain any non-ASCII, symbol or underscore characters: Variables `subject id`, `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> * Cannot contain any lowercase characters Variables ``, `studyid`, `subject id`, `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> 
#> ── 9 of 10 (90%) variables were renamed ──
#> 
#> Var 1:  '' was renamed to 'V1'
#> Var 3:  'studyid' was renamed to 'STUDYID2'
#> Var 4:  'subject id' was renamed to 'SUBJID'
#> Var 5:  '1c. ENT' was renamed to 'ENT1C'
#> Var 6:  '1b. Eyes' was renamed to 'EYES1B'
#> Var 7:  '1d. Lungs' was renamed to 'LUNGS1D'
#> Var 8:  '1e. Heart' was renamed to 'HEART1E'
#> Var 9:  'year number' was renamed to 'YEARNUMB'
#> Var 10:  '1a. Skin_Desc' was renamed to 'SKNDSC1A'
#> 
#> All renamed variables passed validation.
#>   V1 STUDYID STUDYID2 SUBJID ENT1C EYES1B LUNGS1D HEART1E YEARNUMB SKNDSC1A
#> 1  0       0        0      0     0      0       0       0        0        0
#> 2  0       0        0      0     0      0       0       0        0        0
#> 3  0       0        0      0     0      0       0       0        0        0

tidy_varnames(adxx, sep = "_") # permissible for legacy studies
#> 
#> The following variable name validation checks failed:
#> * Must be 8 characters or less: Variables `subject id`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> * Must start with a letter: Variables `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, and `1a. Skin_Desc`.
#> * Cannot contain any non-ASCII, symbol or underscore characters: Variables `subject id`, `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> * Cannot contain any lowercase characters Variables ``, `studyid`, `subject id`, `1c. ENT`, `1b. Eyes`, `1d. Lungs`, `1e. Heart`, `year number`, and `1a. Skin_Desc`.
#> 
#> ── 9 of 10 (90%) variables were renamed ──
#> 
#> Var 1:  '' was renamed to 'V1'
#> Var 3:  'studyid' was renamed to 'STUDYID2'
#> Var 4:  'subject id' was renamed to 'SUBJCTID'
#> Var 5:  '1c. ENT' was renamed to 'ENT_1C'
#> Var 6:  '1b. Eyes' was renamed to 'EYES_1B'
#> Var 7:  '1d. Lungs' was renamed to 'LUNGS_1D'
#> Var 8:  '1e. Heart' was renamed to 'HEART_1E'
#> Var 9:  'year number' was renamed to 'YEARNMBR'
#> Var 10:  '1a. Skin_Desc' was renamed to 'SKNDSC1A'
#> 
#> The following variable name validation checks still failed:
#> Cannot contain any non-ASCII, symbol or underscore characters: Variables `ENT_1C`, `EYES_1B`, `LUNGS_1D`, and `HEART_1E`.
#> Cannot contain any lowercase characters Variables `ENT_1C`, `EYES_1B`, `LUNGS_1D`, and `HEART_1E`.
#>   V1 STUDYID STUDYID2 SUBJCTID ENT_1C EYES_1B LUNGS_1D HEART_1E YEARNMBR
#> 1  0       0        0        0      0       0        0        0        0
#> 2  0       0        0        0      0       0        0        0        0
#> 3  0       0        0        0      0       0        0        0        0
#>   SKNDSC1A
#> 1        0
#> 2        0
#> 3        0
```

<br>

<br>

<br>

<br>
