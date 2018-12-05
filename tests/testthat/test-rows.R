library(testthat)
library(toddler)
library(dplyr)

test_that('row check on one data frame', {
  expect_equal(nrow(add_empty_rows(mtcars, 2, 1)), 47)
  expect_equal(nrow(add_empty_rows(mtcars, c('carb'))), 37)
  expect_equal(nrow(add_empty_rows(mtcars, c('gear', 'carb'))), 42)
  expect_equal(sum(add_empty_rows(mtcars, c('carb'), 3)$carb == ''), (length(unique(mtcars$carb)) - 1) * 3)
})


test_that('row check on add_empty_rows and add_empty_columns', {
  expect_equal(nrow(add_empty_rows(mtcars, c('carb')) %>% add_empty_cols('hp')), 38)
  expect_equal(nrow(add_empty_rows(mtcars, c('gear', 'carb')) %>% add_empty_cols(c('cyl', 'hp'), 2)), 43)
})

test_that('row check on df_stack', {
  expect_equal(nrow(df_stack(list(mtcars, iris))), nrow(mtcars) + nrow(iris) + 3)
  expect_equal(
    nrow(
      df_stack(list(
        add_empty_rows(mtcars, c('carb')),
        add_empty_rows(mtcars, c('gear', 'carb'))
        ))), 
    82)
})
