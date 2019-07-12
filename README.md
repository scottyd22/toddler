
# toddler <img src="images/toddler_hex.png" align="right" width="125px"/>

**toddler** provides simple functions to format data frames prior to
sharing. Users can add empty rows, add empty columns, stack data frames,
and format column names.

## Installation

You can install this package from
[GitHub](https://github.com/scottyd22/) with:

``` r
devtools::install_github('scottyd22/toddler')
```

## Using toddler

Below are some examples on how to use the **toddler** functions.

Add rows to a data frame using the `add_empty_rows` function.

``` r
library(dplyr)
library(toddler)

df <- mtcars[1:10,] %>% 
  arrange(gear, carb)

add_empty_rows(df, group = c('gear', 'carb'))
```

    ##     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
    ## 1  21.4   6   258 110 3.08 3.215 19.44  1  0    3    1
    ## 2  18.1   6   225 105 2.76  3.46 20.22  1  0    3    1
    ## 3                                                     
    ## 4  18.7   8   360 175 3.15  3.44 17.02  0  0    3    2
    ## 5                                                     
    ## 6  14.3   8   360 245 3.21  3.57 15.84  0  0    3    4
    ## 7                                                     
    ## 8  22.8   4   108  93 3.85  2.32 18.61  1  1    4    1
    ## 9                                                     
    ## 10 24.4   4 146.7  62 3.69  3.19    20  1  0    4    2
    ## 11 22.8   4 140.8  95 3.92  3.15  22.9  1  0    4    2
    ## 12                                                    
    ## 13   21   6   160 110  3.9  2.62 16.46  0  1    4    4
    ## 14   21   6   160 110  3.9 2.875 17.02  0  1    4    4
    ## 15 19.2   6 167.6 123 3.92  3.44  18.3  1  0    4    4

Add empty columns to a data frame using the `add_empty_cols` function.

``` r
df <- mtcars[1:5, 1:6]
add_empty_cols(df, group = 2, n = 2)
```

    ##   col01 col02 col03 col04 col05 col06 col07 col08 col09 col10
    ## 1   mpg   cyl              disp    hp              drat    wt
    ## 2    21     6               160   110               3.9  2.62
    ## 3    21     6               160   110               3.9 2.875
    ## 4  22.8     4               108    93              3.85  2.32
    ## 5  21.4     6               258   110              3.08 3.215
    ## 6  18.7     8               360   175              3.15  3.44

Stack data frames into a single “tall” data frame using the `df_stack`
function.

``` r
df1 <- mtcars[1:5, 1:6]
df2 <- iris[1:8,]
df_stack(list(df1, df2), n = 2)
```

    ##           col01       col02        col03       col04   col05 col06
    ## 1           mpg         cyl         disp          hp    drat    wt
    ## 2            21           6          160         110     3.9  2.62
    ## 3            21           6          160         110     3.9 2.875
    ## 4          22.8           4          108          93    3.85  2.32
    ## 5          21.4           6          258         110    3.08 3.215
    ## 6          18.7           8          360         175    3.15  3.44
    ## 7                                                                 
    ## 8                                                                 
    ## 9  Sepal.Length Sepal.Width Petal.Length Petal.Width Species      
    ## 10          5.1         3.5          1.4         0.2  setosa      
    ## 11          4.9           3          1.4         0.2  setosa      
    ## 12          4.7         3.2          1.3         0.2  setosa      
    ## 13          4.6         3.1          1.5         0.2  setosa      
    ## 14            5         3.6          1.4         0.2  setosa      
    ## 15          5.4         3.9          1.7         0.4  setosa      
    ## 16          4.6         3.4          1.4         0.3  setosa      
    ## 17            5         3.4          1.5         0.2  setosa

Format column names of a data frame using the `prep_names` function.

``` r
library(stringr)
a <- starwars
b <- prep_names(starwars, format = 'title', all_upper = c('height', 'Species'))

data.frame(starwars_columns = colnames(a),
           prep_names_columns = colnames(b))
```

    ##    starwars_columns prep_names_columns
    ## 1              name               Name
    ## 2            height             HEIGHT
    ## 3              mass               Mass
    ## 4        hair_color         Hair Color
    ## 5        skin_color         Skin Color
    ## 6         eye_color          Eye Color
    ## 7        birth_year         Birth Year
    ## 8            gender             Gender
    ## 9         homeworld          Homeworld
    ## 10          species            SPECIES
    ## 11            films              Films
    ## 12         vehicles           Vehicles
    ## 13        starships          Starships
