#' Add empty rows to a data frame
#'
#' Insert empty rows into a data frame by a specified group.
#' @param .data  A data frame.
#' @param group The grouping after which blank rows will be added.  Entering a number will add blank rows after each numeric grouping of rows (i.e. enter 3 to insert blank rows after every third row).  Specify a quoted column name or vector of quoted column names to group the data frame and add blank rows after each grouping.  Defaults to 1.
#' @param n The number of empty rows to insert after each group.  Defaults to 1.
#' @keywords blank rows
#' @export add_empty_rows
#' @examples
#' add_empty_rows(mtcars[1:10,], 3, 2)
#'
#' add_empty_rows(mtcars[1:10,], group = c('am', 'gear'))

add_empty_rows <- function(.data, group = 1, n = 1) {
  
  # Error checks
  suppressWarnings(if(is.numeric(group) & (group < 1 | grepl('\\.', group))) {
    stop(paste0("group must be an integer greater than or equal to 1 or a valid column name"))
  })
  
  if(is.numeric(n) == F | n < 1 | grepl('\\.', n)) {
    stop(paste0("n must be an integer greater than or equal to 1"))
  }

  # Case when group is numeric (ie. add blank row(s) after every group of lines)
  if(is.numeric(group)) {

    # If nrow(.data) is not a multiple of group, need to add (then remove) rows to .data to attain even divisibility
    if(nrow(.data) %% group != 0) {

      # Number of rows to add to .data (then remove)
      m <- ceiling(nrow(.data)/group) * group - nrow(.data)

      # Row from .data to repeat
      .data.last <- .data[nrow(.data), ]

      # Duplicate this row the appropriate amount (m) to bind to .data
      .data.add <- .data.last[rep(seq_len(nrow(.data.last)), each = m),]

      .data <- dplyr::bind_rows(.data, .data.add)

      # Add ordering column
      .data$Order <- rep(1:(nrow(.data)/group), each = group)

      # Remove duplicated rows that were added
      .data <- .data[1:(nrow(.data) - m), ]

    } else {

      # Add ordering column
      .data$Order <- rep(1:(nrow(.data)/group), each = group)

    }

    # Case when incorrect column name is provided (Error message)
  } else if(is.character(class(group)) & all(group %in% colnames(.data)) == FALSE) {

    stop(paste0("All items in the specified group are not column names of your object"))

    # Case when group contains all proper column names
  } else if(all(group %in% colnames(.data)) == TRUE) {

    # Preserve original column names
    cn <- colnames(.data)

    # Remove spaces from group and colnames for dplyr transformation
    group <- gsub(' ', '', group)
    colnames(.data) <- gsub(' ', '', colnames(.data))

    # Create a sorting order with the Order field
    id <- dplyr::select_(.data, .dots = group)
    id <- dplyr::distinct(id)
    id <- dplyr::mutate(id, Order = dplyr::row_number())
    max.digits <- nchar(max(id$Order))
    id <- dplyr::mutate(id, Order = paste0(paste(rep('0', max.digits), collapse = ''), Order))
    id <- dplyr::mutate(id, Order = substr(Order, nchar(Order) - max.digits + 1, nchar(Order)))

    .data <- dplyr::left_join(.data, id, by = group)

    # Restore original column names + the newly added 'Order' column
    colnames(.data) <- c(cn, 'Order')

  }

  # Convert data frame to all character
  .data <- dplyr::mutate_all(.data, as.character)

  # Create blanks
  blanks <- dplyr::group_by(.data, Order)
  blanks <- dplyr::filter(blanks, dplyr::row_number() == 1)
  blanks <- dplyr::ungroup(blanks)

  blanks[,1:(ncol(blanks) - 1)] <- ''

  blanks <- blanks[rep(row.names(blanks), n),]

  # Create output
  out <- dplyr::bind_rows(.data, blanks)
  out <- dplyr::arrange(out, Order)
  out <- dplyr::select(out, -Order)

  out[1:(nrow(out) - n), ]

}
