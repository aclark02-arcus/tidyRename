
# Workflow for setting up the repository
install.packages("usethis")
install.packages("devtools")
install.packages("SnowballC")
install.packages("cli")
devtools::load_all()
install.packages(c("readr", "janitor", "tm", "dplyr"))

install.packages("stringr")
packageVersion("stringr")
packageVersion("purrr")
packageVersion("cli")

# create pkg skeleton structure
usethis::create_package(getwd())

# Manually modify the description ----------------------------------------------

# Add a bunch of necessities
usethis::use_readme_rmd()
usethis::use_lifecycle_badge( "Experimental" ) #Experimental, Maturing, Stable, Superseded, Archived, Dormant, Questioning
usethis::use_news_md( open = TRUE )
usethis::use_mit_license()

# Add package dependencies to import statement
usethis::use_package("readr")
usethis::use_package("janitor")
usethis::use_package("tm")
usethis::use_package("stringr")
usethis::use_package("purrr")
usethis::use_package("cli")
usethis::use_package("glue")
usethis::use_package("dplyr")
usethis::use_package("spelling", type = "Suggests")

usethis::use_package("SnowballC")


# Add data-raw folder to generate exported data objects
# usethis::use_data_raw(name = "placeholder", open = FALSE )
#
# Tests
usethis::use_testthat()
usethis::use_test("basic") # basic test, will need to populate with custom content

# Documentation
## Vignettes
usethis::use_vignette("tidyRename") # getting started

usethis::use_pkgdown() # run once
# usethis::use_github_pages() # failed. Instead run this: https://gist.github.com/ramnathv/2227408
usethis::use_github_action("pkgdown")

usethis::use_github_action_check_standard() # run once
