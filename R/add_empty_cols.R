#' Add empty columns to a data frame
#'
#' Insert empty columns into a data frame by a specified group.
#' @param .data  A data frame.
#' @param group The grouping after which blank columns will be added.  Entering a number will add blank columns after each numeric grouping of columns (i.e. enter 3 to insert blank columns after every third column).  Specify a quoted column name or vector of quoted column names to add blank columns after each identified column.  Defaults to 1.
#' @param n The number of empty rows to insert after each group.  Defaults to 1.
#' @keywords blank columns
#' @export add_empty_cols
#' @examples
#' add_empty_cols(mtcars[1:10, ], group = 3, n = 2)
#'
#' add_empty_cols(mtcars[1:10,], group = c('am', 'gear'))


add_empty_cols <- function(.data, group = 1, n = 1) {
  
  # Error checks
  suppressWarnings(if(is.numeric(group) & (group < 1 | grepl('\\.', group))) {
    stop(paste0("group must be an integer greater than or equal to 1 or a valid column name"))
  })
  
  if(is.numeric(n) == F | n < 1 | grepl('\\.', n)) {
    stop(paste0("n must be an integer greater than or equal to 1"))
  }
  
  # Rename data set
  df <- .data

  # Case when group is numeric (ie. add blank row(s) after every group of lines)
  if(is.numeric(group)) {

    # If length(df) is not a multiple of group, need to add (then remove) columns to df to attain even divisibility
    if(length(df) %% group != 0) {

      # Number of columns to add to df (then remove)
      m <- ceiling(length(df)/group) * group - length(df)

      # Create the appropriate amount (m) of blank columns to add to make the length divisible
      dummy.cols <- data.frame(matrix(unlist(c(rep(NA, (nrow(df) + 1) * m))),
                                      ncol = m,
                                      byrow = T),
                               stringsAsFactors = F)

      df <- toddler::df_stack(list(df))
      df <- dplyr::bind_cols(df, dummy.cols)
      colnames(df) <- lapply(1:length(df), function(i) {paste0('col', ifelse(nchar(i) == 1, paste0('0',i), i))})

      # Create the blank columns
      blanks <- data.frame(matrix(unlist(c(rep('', (nrow(df)) * length(df)/group * n))),
                                  ncol = length(df)/group * n,
                                  byrow = T),
                           stringsAsFactors = F)

      # Identify columns that blanks will follow
      targets <- which(seq(1, length(df), 1) %% group == 0)

      # Create function to generate names for the blank columns
      f <- function(i) {
        lapply(colnames(df[,targets]), function(j) {paste0(j, '.', i)})
      }

      # Build data frame with blanks
      colnames(blanks) <- unlist(lapply(1:n, f))
      df <- dplyr::bind_cols(df, blanks)
      df <- dplyr::select(df, sort(colnames(df)))[,1:(length(df) - (m + n))]


    } else {

      # Create the blank columns
      blanks <- data.frame(matrix(unlist(c(rep('', (nrow(df) + 1) * length(df)/group * n))),
                                  ncol = length(df)/group * n,
                                  byrow = T),
                           stringsAsFactors = F)

      # Identify columns that blanks will follow
      targets <- which(seq(1, length(df), 1) %% group == 0)

      # Create function to generate names for the blank columns
      f <- function(i) {
        lapply(colnames(df[,targets]), function(j) {paste0(j, '.', i)})
      }

      # Build data frame with blanks
      df <- toddler::df_stack(list(df))
      colnames(blanks) <- unlist(lapply(1:n, f))
      df <- dplyr::bind_cols(df, blanks)
      df <- dplyr::select(df, sort(colnames(df)))[,1:(length(df) - n)]

    }

    # Case when incorrect column name is provided (Error message)
  } else if(is.character(class(group)) & all(group %in% colnames(df)) == FALSE) {

    stop(paste0("All items in the specified group are not column names of your object"))

    # Case when group contains all proper column names
  } else if(all(group %in% colnames(df)) == TRUE) {

    # Identify columns that blanks will follow
    targets <- which(colnames(df) %in% group)

    df <- toddler::df_stack(list(df))

    # Create the blank columns
    blanks <- data.frame(matrix(unlist(c(rep('', (nrow(df)) * length(group) * n))),
                                ncol = length(group) * n,
                                byrow = T),
                         stringsAsFactors = F)

    # Create function to generate names for the blank columns
    f <- function(i) {
      lapply(colnames(df)[targets], function(j) {paste0(j, '.', i)})
    }

    # Build data frame with blanks
    colnames(blanks) <- unlist(lapply(1:n, f))
    df <- dplyr::bind_cols(df, blanks)
    df <- dplyr::select(df, sort(colnames(df)))[,1:(length(df))]

    if(length(.data) %in% targets) {
      df <- df[,1:(length(df) - n)]
    }

  }

  # Convert data frame to all character
  df <- dplyr::mutate_all(df, as.character)
  colnames(df) <- lapply(1:length(df), function(i) {paste0('col', ifelse(nchar(i) == 1, paste0('0',i), i))})

  df

}

