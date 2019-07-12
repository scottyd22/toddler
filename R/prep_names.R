#' Format column names of a data frame
#'
#' Format the column names of a data frame in one of four ways: title, upper, lower, or sentence.
#' @param .data  A data frame.
#' @param format The format to use for each column name.  Each option adds space between words.
#'        "title" capitalizes the first letter of each word.
#'        "upper" converts all letters to uppercase.
#'        "lower" converts all letters to lowercase.
#'        "sentence" capitalizes the first letter of the first word only.
#'        Defaults to "title".
#' @param all_upper A character vector of column names that should be all uppercase. Default NULL.
#' @param all_lower A character vector of column names that should be all lowercase. Default NULL.
#' @keywords column names
#' @export prep_names
#' @examples
#' colnames(starwars)
#' colnames(prep_names(starwars))
#'
#' starwars %>%
#'    prep_names(format = 'sentence')
#'
#' storms %>%
#'    prep_names('upper')
#'
#'    starwars %>%
#'    prep_names('sentence', all_upper = c('height', 'eye Color'), all_lower = c('Homeworld', 'fiLMS'))


prep_names <- function(.data, format = 'title', all_upper = NULL, all_lower = NULL) {

  # check to make sure the format is either 'title', 'upper', 'lower', 'sentence'; comment if not
  if(!(format %in% c('title', 'upper', 'lower', 'sentence'))) {
    stop(paste0('Your format must be one of: "title", "upper", "lower", or "sentence"'))
  }

  # transform colnames, all_upper, and all_lower into a common form
  colnames(.data) <- tolower(stringr::str_replace_all(
                                                      stringr::str_replace_all(colnames(.data), ' ', '_'),
                                                      '\\.',
                                                      '_')
                             )

  all_upper <- tolower(stringr::str_replace_all(
                                                stringr::str_replace_all(all_upper, ' ', '_'),
                                                '\\.',
                                                '_')
                       )

  all_lower <- tolower(stringr::str_replace_all(
                                                stringr::str_replace_all(all_lower, ' ', '_'),
                                                '\\.',
                                                '_')
                       )

 # identify which columns are listed as targets for upper and lower
  uppers <- which(names(.data) %in% all_upper)
  lowers <- which(names(.data) %in% all_lower)

  # change '.' and '_' to ' '; title case the entire string; trim leading and lagging spaces
  d <- dplyr::rename_all(.tbl = .data,
                         .funs = function(.tbl){
                           a <- stringr::str_replace_all(.tbl, '\\.', '_')
                           a <- stringr::str_replace_all(a, '_', ' ')
                           if(format == 'title') {
                             a <- stringr::str_to_title(a)
                           } else if(format == 'upper') {
                             a <- stringr::str_to_upper(a)
                           } else if(format == 'lower') {
                             a <- stringr::str_to_lower(a)
                           } else {
                             a <- stringr::str_to_sentence(a)
                           }
                           a <- stringr::str_trim(a)
                           a
                           })

    # for the specific columns identified in uppers
    d <- dplyr::rename_at(.tbl = d,
                          .vars = uppers,
                          .funs = stringr::str_to_upper)

    # for the specific columns identified in lowers
    d <- dplyr::rename_at(.tbl = d,
                          .vars = lowers,
                          .funs = stringr::str_to_lower)

    d
}
