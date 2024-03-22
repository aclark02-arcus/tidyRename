#' Rename terms for submission compliance from vector
#'
#' The function takes a single character vector as input and converts each
#' string to be submission compliant. This means the variable must be a maximum
#' of 8 characters, ASCII only, and should contain only uppercase letters,
#' numbers and must start with a letter. No other symbols or special characters
#' should be included in these names. However, legacy studies started on or
#' before December 17, 2016 may use the underscore character "_". This function
#' is slightly more flexible than the submission criteria would allow, so use
#' the arguments wisely. \code{\link{tidy_varnames}} performs the same logic,
#' but directly renames the columns of a data.frame plus enforces more strict
#' adherence to the regulatory guidelines mentioned above.
#'
#' @param original_varname a character vector needing renaming
#' @param char_len integer, the max number of characters allowed in the renamed
#'   strings
#' @param relo_2_end logical, if TRUE: numerical prefix bundles will be
#'   relocated to the end of the string. A prefix bundle is determined as a
#'   number or "grouping of numbers separated by special characters and other
#'   punctuation". See details section for more info on prefix bundles.
#' @param letter_for_num_prefix character. Will be ignored if `relo_2_end =
#'   TRUE`. Per CDISC & regulatory body requirements, variable names cannot
#'   start with a number, so if you want to leave the number of the left-hand
#'   side, use this argument to insert a starting letter before the numeric
#'   prefix.
#' @param sep string of only one character long, intended to separate words from
#'   one another. In general, only an empty string ("") and underscore ("_") are
#'   possible, but the user can insert a letter if desired. Note that "_" is
#'   discouraged because it is only permissible for legacy studies started on or
#'   before Dec 17, 2016.
#' @param replace_vec A named character vector where the name is replaced by the
#'   value. This is helpful for finding and replacing smaller sub-strings
#'   embedded in variable names and automatically converting them to a preferred
#'   phrase. For example: '%' -> "_pct_".
#' @param dict_dat a data frame containing two variables: the `original_varname`
#'   and the `dict_varname` used to find and replace entire variable names with
#'   new ones. For example, "Subject ID" -> "SUBJID".
#' @param letter_case character, with choices c("upper", "lower", "asis")
#'   allowing user to make the final renamed terms uppercase (the default),
#'   lowercase, or leave them as-is, respectively. Note, lowercase is discourage
#'   as it is not submission compliant.
#' @param case character, see \code{\link[snakecase]{to_any_case}} for more info
#'   on alternate cases but some popular choices are "snake", "lower_camel", or
#'   "parsed" (the default). From the documentation, the "parsed" case parses
#'   out substrings and surrounds them with an underscore. Underscores at the
#'   start and end are trimmed. No lower or upper case pattern from the input
#'   string are changed. If `sep = ""`, then underscores will be trimmed later.
#' @param return_df logical, defaults to TRUE where entire dataset is returned
#'   from suggestion process, else just the suggestion column itself
#' @param verbose logical
#'
#' @details Abbreviating variable names in the `xportr` pkg uses a step-by-step
#'   process detailed below. Each original variable name will be renamed based
#'   on the method performing the least amount of work to achieve the min
#'   character length requirement (8 chars), thus maintaining maximum
#'   originality. Therefore, the function only moves on to the next method on an
#'   as-needed basis; namely, when the term is still greater than 8 characters,
#'   even after lite modification.
#'
#'   \enumerate{ \item \strong{Blanks}: Any columns that are missing a variable
#'   name (i.e., the header was blank in the source file) will be renamed to 'V'
#'   plus the column position. So if the 2nd column is blank, it will receive a
#'   'V2' rename.
#'
#'   \item \strong{Use dictionary of controlled terminology}: For example:
#'   'Subject ID' may better be suited as 'SUBJID' within your organization.
#'   Note, that dictionary terms are expected to be submission compliant and
#'   will not be further abbreviated. They will, however, undergo a check for
#'   non-compliance.
#'
#'   \item \strong{Do nothing!} Or at the very least, mimic what SAS does
#'   automatically when cleaning up variable names during a PROC IMPORT. Namely,
#'   replace any special characters & capitalize everything, etc. If the
#'   'SASified' name is <= 8 chars, then the function will use that rename.
#'   However, if its still too long, the function will try removing any extra
#'   special characters or spaces to help reduce to 8 chars.
#'
#'   \item \strong{Find the STEM or ROOT word} of each original variable name.
#'   For example, if the original contains the word 'resting', the 'ing' will be
#'   dropped and only the root word 'rest' will be considered. If less than 8
#'   chars, the algorithm suggests that result. If its still too long, the
#'   function will, again, remove any special characters or spaces from the
#'   stemmed word(s).
#'
#'   \item \strong{Apply an abbreviation algorithm} who's primary goal is
#'   readability, such that the results remain unique. The methods described
#'   below are a bit more 'involved', but the results are very robust. First,
#'   you should know that characters are always stripped from the end of the
#'   strings first (i.e. from right to left). If an element of the variable name
#'   contains more than one word (words are separated by spaces) then at least
#'   one letter from each word will be retained.
#'
#'   \strong{Method}: First spaces at the ends of the string are stripped. Then
#'   (if necessary) any other spaces are stripped. Next, lower case vowels are
#'   removed followed by lower case consonants. Finally if the abbreviation is
#'   still longer than 8 chars, upper case letters and symbols are stripped.
#'
#'   When identifying 'words', the app performs some pre-processing steps in the
#'   following order:
#'
#'   * Certain symbols are replaced. Like the '%' symbol is replaced with 'PCT'.
#'   Ex: 'I_Ate_%' becomes 'I_Ate_PCT'
#'
#'   * Replace any symbols with a blank space. Ex: 'I_Ate' becomes 'I Ate'
#'
#'   * Find when there are two capital letters next to each other, followed by a
#'   lower case letter then adds a space between the two capital letters to
#'   separate the assumed 'words'. Ex: 'IAte' becomes 'I Ate'
#'
#'   * Insert a space between a number followed by a character. Ex: iAte1meal'
#'   becomes 'iAte1 meal'
#'
#'   * Insert a space between a character followed by a number. Ex: 'iAte1meal'
#'   becomes 'iAte 1meal'
#'
#'   What do we abbreviate when? If a stemmed word exists, the app will apply
#'   the abbreviation algorithm described above on the stemmed version of the
#'   variable name, else the original variable name.
#'
#'   Since submission guidelines indicate variables may not start with a number,
#'   when found, the algorithm will either add and maintain a '_' "prefix
#'   bundle" through any transformations detailed above, or it will relocate the
#'   "prefix bundle" to the end of the term (the default behavior). What if a
#'   term starts with non-standard numerical prefix? Currently, the function
#'   accounts for the following types of prefix bundles, where 3 is used as an
#'   example starting digit:
#'
#'   * x = "3a. hey" will return "3a"
#'
#'   * x = "3_17a_hey" will return "3_17a"
#'
#'   * x = "3_17_hey" will return "3_17"
#'
#'   * x = "3_17hey" will return "3_17"
#'
#'   * x = "3hey" will return "3" }
#'
#' @family var_name functions
#' @export
#' @examples
#' vars <- c("", "studyid", "STUDYID", "subject id", "1c. ENT", "1b. Eyes",
#'          "1d. Lungs", "1e. Heart", "year number", "1a. Skin_Desc")
#'
#' # Default behavior
#' tidy_rename(vars)
#' tidy_rename(vars, letter_case = "asis")
#'
#' # Leave numerical prefix on left-hand side, but add a starting letter
#' tidy_rename(vars, relo_2_end = FALSE, letter_for_num_prefix = "x")
#'
#' # Add a dictionary and remove underscores
#' tidy_rename(vars, sep = "",
#'  dict_dat = data.frame(original_varname = "subject id", dict_varname = "subjid"))
#'
tidy_rename <- function(
    original_varname,
    char_len = 8,
    relo_2_end = TRUE,
    letter_for_num_prefix = "x",
    sep = '',
    replace_vec = c("'"="",
                    "\""="",
                    "%"="_pct_",
                    "#"="_nmbr_"),
    dict_dat = data.frame(original_varname = character(),
                          dict_varname = character()),
    letter_case = "upper",
    case = "parsed",
    return_df = FALSE,
    verbose = getOption('xportr.type_verbose', 'none')
){
  # Check to make sure letter_for_num_prefix is actually a letter
  st_letter <- substr(letter_for_num_prefix, 1, 1)
  if(relo_2_end == FALSE & !stringr::str_detect(st_letter, '[A-Za-z]')) {
    stop(paste0("Argument 'letter_for_num_prefix' must start with a letter, not '",
                st_letter, "'", ifelse(st_letter == '', " (an empty string)", "")))
  }
  # The larger the letter_for_num_prefix gets, the less space there is for the
  # rest of the term, so we'll put a hard stop with a max of 3 characters
  if(relo_2_end == FALSE & nchar(letter_for_num_prefix) > 3) {
    stop(paste0("Argument 'letter_for_num_prefix' cannot be longer than 3 characters. '",
                letter_for_num_prefix, "' has ", nchar(letter_for_num_prefix),
                " chars; please adjust."))
  }

  # Check the strings for compliance before performing any renaming
  init_checks <- xpt_validate_var_names(original_varname, list_vars_first = FALSE)
  if (length(init_checks) > 0) {
    message(c("\nThe following variable name validation checks failed:\n",
              paste("*", init_checks, collapse = "\n")))
  } else {
    message("\nVariable Name Validation passed! No renaming necessary.\n")
  }


  # initialize data.frame to track all moving parts when suggesting new var names
  d <- data.frame(original_varname = original_varname,
                  col_pos = seq.int(length(original_varname)),
                  stringsAsFactors = F)

  # parse prefix bundle information (if applicable)
  pb <- gather_n_move_prefix_num_bundle(original_varname,
                                        relo_2_end = relo_2_end,
                                        sep = sep)

  # Borrowed from janitor, but adjusted to handle non-case sensitive duplicated
  # names since they can introduce dups because we don't adjust letter case
  # until after the algorithm has been executed... so here we are proactively
  # searching for potential dups that may exist after we change case to upper
  # (for ex) by making the strings unique in the same letter case before feeding
  # to the "renaming engine". Example edge case: a variable called "studyid" and
  # 2nd one called "STUDYID" would result in a dups without the following code:
  viable <- pb$viable
  case_viable <- viable %>% chg_letter_case(letter_case)
  if(tolower(letter_case) %in% c("upper","lower") &
     any(duplicated(case_viable)) ) {
    dupe_count <-
      vapply(
        seq_along(case_viable), function(i) {
          sum(case_viable[i] == case_viable[1:i])
        },
        1L)

    viable[dupe_count > 1] <-
      paste(
        viable[dupe_count > 1],
        dupe_count[dupe_count > 1],
        sep = "_"
      )
  }

  # Generate all the rename methods needed to perform the least intrusive rename
  # method for each term
  my_vars01 <-
    d %>%
    dplyr::mutate(lower_original_varname = tolower(original_varname)) %>% # for join w/ dict. Don't want join to be case sensitive
    dplyr::left_join(
      dict_dat %>%
        dplyr::mutate(lower_original_varname = tolower(original_varname)) %>%
        dplyr::select(lower_original_varname, dict_varname) %>%
        dplyr::distinct(lower_original_varname, .keep_all = T)
      , by = "lower_original_varname"
    ) %>%
    dplyr::select(-lower_original_varname) %>%
    dplyr::mutate(
      num_st_ind = starts_with_number(original_varname)
      , prefix_bundle = pb$bundle
      , use_bundle = dplyr::case_when(relo_2_end ~ "",
                               relo_2_end == FALSE & prefix_bundle != "" ~ letter_for_num_prefix,
                               TRUE ~ "")
      , viable_start = viable
      , my_minlength = ifelse(relo_2_end == F & num_st_ind == 1,
                              char_len - nchar(letter_for_num_prefix),
                              char_len)
      # apply small adjustments before transformation: trim white space, replace
      # %'s, use janitor (does a ton of work, like removing non-ASCII), etc
      , adj_orig =
        viable_start %>%
        trimws(which = "both") %>%
        janitor::make_clean_names(case = case,
                                  use_make_names = FALSE, # get rid of x prefix
                                  replace = replace_vec,
                                  sep_out = sep
        )
      # If we want to pivot away from using janitor but still want to
      # replace stuff and translate to ASCII, use this code:
      # stringr::str_replace_all(pattern = replace_vec) %>%
      # stringi::stri_trans_general(id="Any-Latin;Greek-Latin;Latin-ASCII")

      # 1st, convert special chars to spaces, then parse any uppercase words
      # from lowercase words, then parse proper words, then parse numerals from
      # alpha chars
      , adj_parsed = adj_orig %>% read_words_nums_no_sym() %>% trimws(which = "both")

      , abbr_parsed = abbreviate_v(adj_parsed, minlength = my_minlength)

      # Before stemming, ditch special characters for spaces and is set to
      # lowercase per the tm pkg
      , stem = adj_parsed %>% tm::stemDocument()
      , abbr_stem = abbreviate_v(stem, minlength = my_minlength)

    ) %>%
    dplyr::mutate(
      renamed_var =
        least_pushy_rename_method(
          char_len = char_len,
          original_varname = original_varname,
          dict_varname = dict_varname,
          use_bundle = use_bundle,
          adj_orig = adj_orig,
          stem = stem,
          abbr_stem = abbr_stem,
          abbr_parsed = abbr_parsed
        ) %>%
        chg_letter_case(letter_case) # upper, lower, or asis

    )

  # add a new var, keeping track of dups
  my_vars <-
    my_vars01 %>%
    dplyr::left_join(
      my_vars01 %>%
        dplyr::group_by(renamed_var) %>%
        dplyr::summarize(renamed_n = dplyr::n()) %>%
        dplyr::ungroup()
      , by = "renamed_var")


  # These are just a few other "nice to know" checks/msgs regarding the var renaming
  # See messages.R for details
  var_names_log(my_vars, verbose)

  # Perform official xpt checks now that strings have been renamed
  final_checks <- xpt_validate_var_names(my_vars$renamed_var, list_vars_first = FALSE)
  if (length(final_checks) > 0) {
    message(c("\nThe following variable name validation checks still failed:\n",
              paste0(paste(final_checks, collapse = "\n"), "\n")))
  } else if(length(init_checks) > 0) {
    message("\nAll renamed variables passed validation.\n\n")
  }


  if(return_df == T){
    return(my_vars)
  } else {
    my_vars$renamed_var
  }
}
