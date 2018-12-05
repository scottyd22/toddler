library(testthat)
library(toddler)
library(dplyr)

test_that('error check on add_empty_rows', {
  expect_error(add_empty_rows(mtcars, group = 0.5), 'group must be an integer greater than or equal to 1 or a valid column name')
  expect_error(add_empty_rows(mtcars, group = 3.7), 'group must be an integer greater than or equal to 1 or a valid column name')
  expect_error(add_empty_rows(mtcars, n = 'yes'), 'n must be an integer greater than or equal to 1')
  expect_error(add_empty_rows(mtcars, n = 0.33), 'n must be an integer greater than or equal to 1')
  expect_error(add_empty_rows(mtcars, n = 2.25), 'n must be an integer greater than or equal to 1')
  expect_error(add_empty_rows(mtcars, group = 'Column'), 'All items in the specified group are not column names of your object')
  expect_error(add_empty_rows(mtcars, group = c('hp', 'Column')), 'All items in the specified group are not column names of your object')
})

test_that('error check on add_empty_cols', {
  expect_error(add_empty_cols(mtcars, group = 0.5), 'group must be an integer greater than or equal to 1 or a valid column name')
  expect_error(add_empty_cols(mtcars, group = 3.7), 'group must be an integer greater than or equal to 1 or a valid column name')
  expect_error(add_empty_cols(mtcars, n = 'yes'), 'n must be an integer greater than or equal to 1')
  expect_error(add_empty_cols(mtcars, n = 0.33), 'n must be an integer greater than or equal to 1')
  expect_error(add_empty_cols(mtcars, n = 2.25), 'n must be an integer greater than or equal to 1')
  expect_error(add_empty_cols(mtcars, group = 'Column'), 'All items in the specified group are not column names of your object')
  expect_error(add_empty_cols(mtcars, group = c('hp', 'Column')), 'All items in the specified group are not column names of your object')
})

test_that('error check on df_stack', {
  expect_error(df_stack(mtcars), 'Your data frames need to be wrapped in list()')
  expect_error(df_stack(mtcars, iris), 'Your data frames need to be wrapped in list()')
  expect_error(df_stack(list(mtcars, iris), n = 'Yes'), 'n must be an integer greater than or equal to 1')
  expect_error(df_stack(list(mtcars, iris), n = 0.7), 'n must be an integer greater than or equal to 1')
  expect_error(df_stack(list(mtcars, iris), n = 2.2), 'n must be an integer greater than or equal to 1')
})
