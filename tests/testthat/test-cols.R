library(testthat)
library(toddler)
library(dplyr)

test_that('col check on one data frame', {
  expect_equal(length(add_empty_cols(mtcars, 2, 1)), 16)
  expect_equal(length(add_empty_cols(mtcars, c('carb'))), 11)
  expect_equal(length(add_empty_cols(mtcars, c('gear', 'carb'), 4)), 15)
  expect_equal(sum(add_empty_cols(mtcars)[1,] == ''), length(mtcars) - 1)
})


test_that('col check on add_empty_rows and add_empty_columns', {
  expect_equal(length(add_empty_cols(mtcars, c('hp')) %>% add_empty_rows('col10')), 12)
  expect_equal(length(add_empty_cols(mtcars, c('hp', 'gear')) %>% add_empty_rows(c('col02', 'col04'), 2)), 13)
})

test_that('col check on df_stack', {
  expect_equal(length(df_stack(list(mtcars, iris))), max(length(mtcars), length(iris)))
  expect_equal(
    length(
      df_stack(list(
        add_empty_cols(mtcars, c('hp'), 2),
        add_empty_cols(iris, c('Sepal.Width', 'Petal.Width'), 3)
        ), 
        3)
      ), 
    13)
})
