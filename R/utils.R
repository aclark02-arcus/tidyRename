#' Vectorized Abbreviation
#'
#' Makes the `abbreviate` function from base R vectorized to
#' accommodate a vector of differing minLength values. Cannot use
#' `Vectorize` here, as it will lead to dupes. This method
#' generates the abbreviations with the largest minLengths first and leaves
#' those intact as it continues onto the terms with the next highest minLength
#' values. This continues iteratively until the lowest minlength is reached.
#'
#' @param names.arg a character vector of names to be abbreviated, or an object
#'   to be coerced to a character vector by as.character.
#' @param minlength the minimum length of the abbreviations, as a numeric
#'   vector. Must be same lenth as names.arg argument's vector.
#'
#' @export
#' @noRd
#'
#' @examples
#' abbreviate_v(c("Fruit Flies", "Tubular Dude"),c(4,6))
#'
abbreviate_v <- function(names.arg, minlength){
  if(!is.numeric(minlength)) stop("minlength arg must be numeric")
  if(length(minlength) != length(names.arg)) stop("names.arg & minlength arg must be same length")

  # grab each unique minlength value
  abbr_lengths <- unique(minlength) %>% sort(T)

  # Initiate first iteration, where entire vector is a abbreviated to same length
  abbr <- abbreviate(
    names.arg,
    minlength = abbr_lengths[1],
    method = "both.sides"
  )

  # For any other abbreviation lengths, continue to abbreviate the abbreviations
  for(ab_len in abbr_lengths[-1]){
    abbr[minlength <= ab_len] <- abbreviate(
      abbr[minlength <= ab_len],
      minlength = ab_len,
      method = "both.sides"
    )
  }
  return(abbr)
}


#' Find and replace \%'s with "Pct"
#'
#' @param x a character vector where matches are sought, or an object which can
#'   be coerced by as.character to a character vector. Long vectors are
#'   supported.
#'
#' @noRd
#' @export
#' @examples
#' words_grapes("Johnny owes me 90% of his sandwich")
words_grapes <- function(x) {
  gsub("\\%","Pct", x)
}


#' Find and replace _'s (underscores) with a blank space " "
#'
#' @param x a character vector where matches are sought, or an object which can
#'   be coerced by as.character to a character vector. Long vectors are
#'   supported.
#'
#' @noRd
#' @export
#' @examples
#' words_("I_Ate")
words_ <- function(x) {
  gsub("\\_"," ",x)
}


#' Find when there are two capital letters next to each other, followed by a
#' lower case letter, then add a space between the two capital letters to
#' separate the assumed 'words'
#'
#' @param x a character vector where matches are sought, or an object which can
#'   be coerced by as.character to a character vector. Long vectors are
#'   supported.
#'
#' @noRd
#' @export
#' @examples
#' words_ABb("IAte")
words_ABb <- function(x) {
  gsub("([[:upper:]])([[:upper:]][[:lower:]])","\\1 \\2",x)
}


#' Insert a space between a lowercase character and an uppercase to
#' separate a character string into assumed 'words'
#'
#' @param x a character vector where matches are sought, or an object which can
#'   be coerced by as.character to a character vector. Long vectors are
#'   supported.
#'
#' @noRd
#' @export
#' @examples
#' words_aB("iAte")
words_aB <- function(x) {
  gsub("([[:lower:]])([[:upper:]])","\\1 \\2",x)
}


#' Insert a space between a number followed by a character to create the assumed
#' "words" in the character vector
#'
#' @param x a character vector where matches are sought, or an object which can
#'   be coerced by as.character to a character vector. Long vectors are
#'   supported.
#'
#' @noRd
#' @export
#' @examples
#' words_1a(x = "iAte1grape")
words_1a <- function(x) {
  gsub("([0-9])([[:alpha:]])","\\1 \\2",x)
}


#' Insert a space between a character followed by a number to create the assumed
#' "words" in the character vector
#'
#' @param x a character vector where matches are sought, or an object which can
#'   be coerced by as.character to a character vector. Long vectors are
#'   supported.
#'
#' @noRd
#' @export
#' @examples
#' words_a1("iAte1grape")
words_a1 <- function(x) {
  gsub("([[:alpha:]])([0-9])","\\1 \\2",x)
}


#' Find and replace special characters or symbols
#'
#' @param x a character vector where matches are sought, or an object which can
#'   be coerced by as.character to a character vector. Long vectors are
#'   supported.
#' @param replace character to replace the special characters or symbols with;
#'   Defaults to blank space.
#'
#' @noRd
#' @export
#' @examples
#' replace_sym("i.Ate-1grape?")
replace_sym <- function(x, replace = " ") {
  gsub("[^[:alnum:]]", replace, x)
}


#' Uses a smattering of string functions to separate words that may be smashed
#' together so that the the character element is more human readable
#'
#' @param x a character vector where matches are sought, or an object which can
#'   be coerced by as.character to a character vector. Long vectors are
#'   supported.
#'
#' @noRd
#' @export
#' @examples
#' read_words("iAteABunch_of_grapesUntil99%Full")
read_words <- function(x){
  # x %>% words_grapes() %>% words_() %>% words_ABb() %>% words_aB()
  words_aB(words_ABb(words_(words_grapes(x)))) # with no pipes
}


#' Uses a smattering of string functions to separate words and/or numbers that
#' may be smashed together so that the the character element is more human
#' readable
#'
#' @param x a character vector where matches are sought, or an object which can
#'   be coerced by as.character to a character vector. Long vectors are
#'   supported.
#'
#' @noRd
#' @export
#' @examples
#' read_words_and_nums("iAteABunch_of_grapesUntil99%Full")
read_words_and_nums <- function(x){
  # x %>% read_words() %>% words_1a() %>% words_a1()
  words_a1(words_1a(read_words(x))) # with no pipes
}


#' Uses a smattering of string functions to separate words and/or numbers that
#' may be smashed together so that the the character element is more human
#' readable
#'
#' @param x a character vector where matches are sought, or an object which can
#'   be coerced by as.character to a character vector. Long vectors are
#'   supported.
#'
#' @noRd
#' @export
#' @examples
#' read_words_nums_no_sym(x = "iAteABunch_of_grapesUntil99%Full")
read_words_nums_no_sym <- function(x){
  # x %>% replace_sym() %>% read_words_and_nums()
  read_words_and_nums(replace_sym(x)) # with no pipes
}


#' Indicate 1 if a string starts with a number, 0 otherwise
#'
#' @param x a character vector where matches are sought, or an object which can
#'   be coerced by as.character to a character vector. Long vectors are
#'   supported.
#'
#' @noRd
#' @export
#' @examples
#' starts_with_number("iAteABunch_of_grapesUntil99%Full")
#' starts_with_number("1a.How Was Brunch?")
starts_with_number <- function(x){
  suppressWarnings(ifelse((!is.na(as.numeric(substr(x,1,1)))),1,0))
}


#' Extract Starting Prefix number
#'
#' Return "[NUM]" if a string starts with a number, "" otherwise
#'
#' @param x a character vector where matches are sought, or an object which can
#'   be coerced by as.character to a character vector. Long vectors are
#'   supported.
#'
#' @noRd
#' @export
#' @examples
#' prefix_num(x = "iAteABunch_of_grapesUntil99%Full")
#' prefix_num(x = "1a.How Was Brunch? Still $2.99?")
prefix_num <- function(x){
  suppressWarnings(ifelse(starts_with_number(x) == 1, readr::parse_number(x), ""))
}


#' Prefix Bundle Extraction Vessel
#'
#' A helper function used to simplify the extraction of certain prefix bundles, used in
#' \code\link{gather_n_move_prefix_num_bundle}}.
#'
#' @param x a character vector where matches are sought, or an object which can
#'   be coerced by as.character to a character vector. Long vectors are
#'   supported.
#' @param num a number, as numeric or character, that matches the first
#'   occurrence of a number in the prefix bundle. Determined automatically in
#'   `gather_n_move_prefix_num_bundle()`
#' @param srch_patt The regular expression search pattern, expressed as a string
#'
#' @noRd
#' @export
#' @examples
#' extrct_vssl(x = "1a. How Was Brunch?", 1, "[^[:alnum:]]([0-9]){1,3}")
extrct_vssl <- function(x, num, srch_patt){
  x %>%
    read_words() %>%
    stringr::str_extract(paste0("(",num, srch_patt, ")"))
}


#' Extract 'prefix bundle'
#'
#' A 'prefix bundle' is a string that starts with a numeric digit and is
#' followed by 1 or 2 alpha characters. The string is passed to internal
#' \code{\link{read_words}} function to parse out 'bundle' alphas from
#' 'non-bundle' alphas found in the term. Returns the "bundle prefix" with no
#' underscore prefix.
#'
#' @param x a character vector where matches are sought, or an object which can
#'   be coerced by as.character to a character vector. Long vectors are
#'   supported.
#' @param relo_2_end logical, if `TRUE` then the prefix bundle, if it exists
#'   will be scooted to the end of the string x, else it will receive the
#'   necessary "_" prefix
#' @param sep string of only one character long, intended to separate words from
#'   one another, not a starting character if original term has a numeric prefix!
#'
#' @details Currently, this function accounts for the following types of prefix
#'   bundles, where 3 is used as an example starting digit:
#'   * x = "3a. hey" will return "3a"
#'   * x = "3_17a_hey" will return "3_17a"
#'   * x = "3_17_hey" will return "3_17"
#'   * x = "3_17hey" will return "3_17"
#'   * x = "3hey" will return "3"
#'
#' @noRd
#' @export
#' @examples
#' gather_n_move_prefix_num_bundle(x = "iAteABunch_of_grapesUntil99%Full")
#' gather_n_move_prefix_num_bundle(x = "1a. How Was Brunch?")
#' gather_n_move_prefix_num_bundle(x = "2aa How Was Brunch2day?")
#' gather_n_move_prefix_num_bundle(x = "30abHow Was Brunch2day?")
#' gather_n_move_prefix_num_bundle(x = c("30ab.How Was Brunch2day?", "40AHow Was Brunch2day?"))
#' gather_n_move_prefix_num_bundle(x = c("iAteABunch_of_grapesUntil99%Full","30ab.How Was Brunch2day?", "40AHow Was Brunch2day?"))
gather_n_move_prefix_num_bundle <- function(x, relo_2_end = T, sep = "_"){

  full_bundle <- purrr::map_chr(x, function(x){
    pfix_st_num <- prefix_num(x) # grab prefix num
    if(pfix_st_num != ""){ # if it exists...
      fb <- dplyr::case_when(
        # Example x = "3a. hey"
        !(extrct_vssl(x, pfix_st_num, "[[:alpha:]]{1,2}[^[:alnum:]]") %>% is.na()) ~
          extrct_vssl(x, pfix_st_num, "[[:alpha:]]{1,2}[^[:alnum:]]"),

        # Example x = "3_17a_hey"
        !(extrct_vssl(x, pfix_st_num, "[^[:alnum:]]([0-9]){1,3}[[:alpha:]][^[:alnum:]]") %>% is.na()) ~
          extrct_vssl(x, pfix_st_num, "[^[:alnum:]]([0-9]){1,3}[[:alpha:]][^[:alnum:]]"),

        # Example x = "3_17_hey"
        !(extrct_vssl(x, pfix_st_num, "[^[:alnum:]]([0-9]){1,3}[^[:alnum:]]") %>% is.na()) ~
          extrct_vssl(x, pfix_st_num, "[^[:alnum:]]([0-9]){1,3}[^[:alnum:]]"),

        # Example x = "3_17hey"
        !(extrct_vssl(x, pfix_st_num, "[^[:alnum:]]([0-9]){1,3}") %>% is.na()) ~
          extrct_vssl(x, pfix_st_num, "[^[:alnum:]]([0-9]){1,3}"),

        # Example x = "3hey"
        TRUE ~ extrct_vssl(x, pfix_st_num, "")
      )
    } else { # if prefix num doesn't exist...
      fb <- ""
    }
    return(fb)
  })

  pfix_st_num_v <- prefix_num(x)

  fb_clean <- full_bundle %>%
    trimws(which = "both") %>%
    stringr::str_replace_all(" ", "_")

  bundle <- ifelse(is.na(fb_clean), as.character(pfix_st_num_v), # no bundle, just digit
                   stringr::str_replace(fb_clean, "([^[:alnum:]])", "")) # remove spcl chars

  # if relocating bundle to end, then move it, else do nothing
  fixed <-  purrr::map2_chr(x, fb_clean, function(x, fb){
    if(relo_2_end){
      trimws(ifelse(fb == "", x, paste0(stringr::str_replace(x, fb, ""), sep,
                                        stringr::str_replace(fb, "([^[:alnum:]])",""))),
             which = "both")
    } else { x }
  })
  return(list(viable = fixed, bundle = bundle, full_bundle = fb_clean))
}



#' Change letter case - upper, lower, or leave as-is
#'
#' Supply a character string or vector, returns the same vector with changed
#' case. Notice, this function just uses `toupper()` or `tolower()` but the
#' string, `x`, may have been altered by the janitor package's use of
#' \code{\link[snakecase]{to_any_case}} later on, when suggesting a rename
#'
#' @param x a character vector, or an object which can be coerced by
#'   as.character to a character vector. Long vectors are supported.
#' @param letter_case character string, either "lower", "upper", or "asis"
#'
#' @noRd
#' @export
#' @examples
#' chg_letter_case(c("hello darkness","My Old FRIEND"), "lower" )
#' chg_letter_case(c("hello darkness","My Old FRIEND"), "upper" )
#' chg_letter_case(c("hello darkness","My Old FRIEND"), "asis" )
chg_letter_case <- function(x, letter_case = "asis"){
  if(tolower(letter_case) == "upper")  {toupper(x)}
  else if(tolower(letter_case) == "lower") {tolower(x)}
  else {x} # leave 'else {x}', so  janitor can edit the case (via snakecase::to_any_case)
}


## Functions to output user messages, usually relating to differences
## found between .df and the metacore object

var_names_log <- function(tidy_names_df, verbose){


  only_renames <- tidy_names_df %>%
    dplyr::filter(original_varname != renamed_var) %>%
    dplyr::mutate(renamed_msg = paste0("Var ", col_pos, ":  '", original_varname,
                                "' was renamed to '", renamed_var, "'"))

  # Message regarding number of variables that were renamed/ modified
  num_renamed <- nrow(only_renames)
  tot_num_vars <- nrow(tidy_names_df)
  message("\n")
  cli::cli_h2(paste0( num_renamed, " of ", tot_num_vars, " (",
                      round(100*(num_renamed/tot_num_vars), 1), "%) variables were renamed"))

  # Message stating any renamed variables each original variable and it's new name
  if(nrow(only_renames) > 0) message(paste0(paste(only_renames$renamed_msg, collapse = "\n"), "\n"))

  # Message checking for duplicate variable names after renamed (Pretty sure
  # this is impossible) but good to have a check none-the-less.
  dups <- tidy_names_df %>% filter(renamed_n > 1)
  if(nrow(dups) != 0) {
    cli::cli_alert_danger(
      paste("Duplicate renamed term(s) were created. Consider creating dictionary terms for:",
            paste(unique(dups$renamed_var), collapse = ", ")
      ))
  }
}



#' Execute checks on variable names
#'
#'
#' @param varnames a vector of variable namess
#' @param list_vars_first a logical
#' @param err_cnd character string, either empty of containing an error message
#'
#' @noRd
xpt_validate_var_names <- function(varnames,
                                   list_vars_first = TRUE,
                                   err_cnd = character()) {

  # 1.1 Check length --
  chk_varlen <- varnames[nchar(varnames) > 8]

  if (length(chk_varlen) > 0) {
    err_cnd <- c(err_cnd, ifelse(list_vars_first,
                                 glue("{fmt_vars(chk_varlen)} must be 8 characters or less."),
                                 glue("
                      Must be 8 characters or less: {fmt_vars(chk_varlen)}.")))
  }

  # 1.2 Check first character --
  chk_first_chr <- varnames[stringr::str_detect(stringr::str_sub(varnames, 1, 1),
                                                "[^[:alpha:]]")]

  if (length(chk_first_chr) > 0) {
    err_cnd <- c(err_cnd, ifelse(list_vars_first,
                                 glue("{fmt_vars(chk_first_chr)} must start with a letter."),
                                 glue("
                      Must start with a letter: {fmt_vars(chk_first_chr)}.")))
  }

  # 1.3 Check Non-ASCII and underscore characters --
  chk_alnum <- varnames[stringr::str_detect(varnames, "[^a-zA-Z0-9]")]

  if (length(chk_alnum) > 0) {
    err_cnd <- c(err_cnd, ifelse(list_vars_first,
                                 glue("{fmt_vars(chk_alnum)} cannot contain any non-ASCII, symbol or underscore characters."),
                                 glue("
                      Cannot contain any non-ASCII, symbol or underscore characters: {fmt_vars(chk_alnum)}.")))
  }

  # 1.4 Check for any lowercase letters - or not all uppercase
  chk_lower <- varnames[!stringr::str_detect(
    stringr::str_replace_all(varnames, "[:digit:]", ""),
    "^[[:upper:]]+$")]

  if (length(chk_lower) > 0) {
    err_cnd <- c(err_cnd, ifelse(list_vars_first,
                                 glue("{fmt_vars(chk_lower)} cannot contain any lowercase characters."),
                                 glue("
                      Cannot contain any lowercase characters {fmt_vars(chk_lower)}.")))
  }
  return(err_cnd)
}

#' Suggest a new renamed / abbreviated term
#'
#' Take multiple character vectors as inputs and return the final suggestion or the
#'   transfermation method used.
#'
#' @param char_len the maximum char length the final suggestion can be
#' @param original_varname a character vector
#' @param dict_varname a character vector to use first if a dictionary term
#'   exists
#' @param adj_orig the original name, adjusted for any percent symbols (%) or
#'   grapes
#' @param stem the stem or root word(s), char
#' @param abbr_stem the character abbreviation of the stem or root
#' @param abbr_parsed the character abbreviation of the adj_orig
#'
#' @noRd
#' @examples
#' least_pushy_rename_method(
#'   char_len = 8,
#'   original_varname = c("", "subject id", "1c. ENT", "1b. Eyes", "1d. Lungs", "1e. Heart", "year number", "1a. Skin_Desc"),
#'   dict_varname = c(NA, "SUBJID", NA, NA, NA, NA, NA, NA),
#'   use_bundle = c("","","","","","","",""),
#'   adj_orig = c("", "subject id", "1c. ENT", "1b. Eyes", "1d. Lungs", "1e. Heart", "year number", "1a. Skin_Desc"),
#'   stem = c("", "subject id", "c ent", "b eye", "d lung", "e heart", "year number", "a skin desc"),
#'   abbrev = c("", "subjctid", "_1c. ENT", "_1b.Eyes", "_1d lung", "_1eheart", "yearnmbr", "_1asknds")
#'   abbr_transf = c("","","","","","","")
#'   )
least_pushy_rename_method <- function(char_len,
                                      relo_2_end = TRUE,
                                      sep = '_',
                                      original_varname,
                                      dict_varname,
                                      use_bundle,
                                      adj_orig,
                                      stem,
                                      abbr_stem,
                                      abbr_parsed
){

  col_pos <- seq.int(length(original_varname))
  dplyr::case_when(

    # Name blank cols
    original_varname == "" | is.na(original_varname) ~ paste0("V",col_pos),

    # Dictionary
    !(is.na(dict_varname)) ~ dict_varname,

    # Minor cleaning
    nchar(paste0(use_bundle, replace_sym(adj_orig, sep))) <= char_len ~
      paste0(use_bundle, replace_sym(adj_orig, sep)),

    nchar(paste0(use_bundle, replace_sym(adj_orig, ""))) <= char_len ~
      paste0(use_bundle, replace_sym(adj_orig, "")),

    # Stemming
    nchar(paste0(use_bundle, replace_sym(stem, sep))) <= char_len ~
      paste0(use_bundle, replace_sym(stem, sep)),

    nchar(paste0(use_bundle, replace_sym(stem, ""))) <= char_len ~
      paste0(use_bundle, replace_sym(stem, "")),

    # Abbreviation
    TRUE ~
      dplyr::case_when(
        nchar(paste0(use_bundle, abbr_parsed)) <= char_len &
          nchar(abbr_parsed) >= nchar(abbr_stem) ~ paste0(use_bundle, abbr_parsed)

        , nchar(paste0(use_bundle, abbr_stem)) <= char_len ~ paste0(use_bundle, abbr_stem)

        , TRUE ~ "NoAbbrev"
      )
  )
}
