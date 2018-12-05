#' Stack data frames
#'
#' Stack data frames on top of each other to form one tall data frame.
#' @param .data A collection of data frames wrapped in a list. Use list(df1, df2, etc.).
#' @param n The number of rows to put between stacked data frames.  Defaults to 1.
#' @keywords stack
#' @export df_stack
#' @examples
#' df1 <- head(mtcars, 10)
#' df2 <- head(iris, 8)
#' df_stack(list(df1, df2), n = 2)

df_stack <- function(.data, n = 1) {

  # Error messages
  suppressWarnings(if(grepl('list\\(', .data) == F) {stop(paste0('Your data frames need to be wrapped in list()'))})
  if(is.numeric(n) == F | n < 1 | grepl('\\.', n)) {stop(paste0('n must be an integer greater than or equal to 1'))}

  # Determine number of data frames
  n.df <- length(.data)

  # Function for generically naming columns
  colname.fx <- function(x) {paste0('col', ifelse(nchar(x) == 1, paste0('0', x), x))}

  # Table generating function
  generate.tables <- function(i) {

    # Data frame
    df <- dplyr::mutate_all(.data[[i]], as.character)

    # Preserve column names of data frame
    df.header <- data.frame(title = colnames(df))
    df.header <- dplyr::mutate(df.header,
                               title = factor(title, levels = title, ordered = T))
    df.header <- tidyr::spread(df.header, key = title, value = 1)
    df.header <- dplyr::mutate_all(df.header, as.character)
    colnames(df.header)[1] <- 'col01'

    # Rename first columns of data frame for binding
    colnames(df)[1] <- 'col01'

    # Assemble final table
    out <- dplyr::bind_rows(df.header, df)

    # Rename columns
    colnames(out) <- lapply(1:length(out), colname.fx)

    # Add empty row at the bottom
    if(i != n.df) {
      empty <- data.frame(col01 = rep('', n), stringsAsFactors = F)
      out <- dplyr::bind_rows(out, empty)
    }
    out
    } # close generate.tables

  # Generate list of tables
  tables <- lapply(1:n.df, generate.tables)

  # Stack Output and blank out NA's
  output <- dplyr::bind_rows(tables)
  output <- dplyr::filter(output, col01 != 'col01' | is.na(col01))
  output[is.na(output)] <- ''
  output
  
}
