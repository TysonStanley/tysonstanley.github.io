This post is designed to help me understand how `data.table`s `copy()`
function works, along with its *modify-by-reference* behavior (as
compared to the modify-by-copy that Hadley references in Advanced R’s
[memory chapter](http://adv-r.had.co.nz/memory.html)).

First, we’ll use five packages:

    library(bench)
    library(dplyr)

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

    library(data.table)

    ## 
    ## Attaching package: 'data.table'

    ## The following objects are masked from 'package:dplyr':
    ## 
    ##     between, first, last

    library(pryr)

    ## 
    ## Attaching package: 'pryr'

    ## The following object is masked from 'package:data.table':
    ## 
    ##     address

    library(lobstr)

    ## 
    ## Attaching package: 'lobstr'

    ## The following objects are masked from 'package:pryr':
    ## 
    ##     ast, mem_used

The `pryr` and `lobstr` packages will help us see some of the internal
behavior of R.

We’ll use the following data table for this post.

    dt <- data.table(
      x = rnorm(1e7),
      y = runif(1e7)
    )

It is roughly 1.6 MB and has an address of `lobstr::obj_addr(dt)`. We
won’t be using this address later on because we’ll be making copies of
this data table, but note that an object has a size and address.

    pryr::object_size(dt)

    ## 160 MB

    lobstr::obj_addr(dt)

    ## [1] "0x7fc85f8bf000"

To better understand `data.table`’s behavior, let’s do four different
ways of adding a variable to a data frame.

1.  Use the base R way of adding a variable.
2.  Use the `dplyr::mutate()` function.
3.  Use `data.table::copy()` to make a deep copy of the data table and
    then modify by reference.
4.  Use the modify-by-reference inherent with `:=` in `data.table`.

<!-- -->

    based   <- expression({dt_based$z <- rnorm(1e7)})
    mutated <- expression({dt_mutate <- mutate(dt_mutate, z = rnorm(1e7))})
    copied  <- expression({dt_copied <- copy(dt)[, z := rnorm(1e7)]})
    modify  <- expression({dt_modify[, z := rnorm(1e7)]})

Because both `based`, `mutated`, and `modify` will change the original
`dt` data table, let’s create a copy for each to use and see their
corresponding addresses. Note that both change from the original `dt`
object since it is fully copied now.

    dt_based <- copy(dt)
    dt_mutate <- copy(dt)
    dt_modify <- copy(dt)

    lobstr::obj_addr(dt_based)

    ## [1] "0x7fc86584e000"

    lobstr::obj_addr(dt_mutate)

    ## [1] "0x7fc865852400"

    lobstr::obj_addr(dt_modify)

    ## [1] "0x7fc865952000"

Importantly, `copy()` does something very different than just assigning
to another name. `copy()` creates a whole new object while assigning to
another name just creates another name pointing to the same object
(until one or the other is modified). For example, the following lines
do different things. We can see this by looking at their addresses,
where `just_pointing_to_dt` is the same location and the same object.
The `copied_object` is an entirely different object with a different
address. (Hadley covers this in depth in Advanced R.)

    copied_object <- copy(dt)
    just_pointing_to_dt <- dt

    lobstr::obj_addr(dt)

    ## [1] "0x7fc85f8bf000"

    lobstr::obj_addr(copied_object)

    ## [1] "0x7fc8644b6400"

    lobstr::obj_addr(just_pointing_to_dt)

    ## [1] "0x7fc85f8bf000"

First, let’s look at the memory change, from before an expression is
evaluated to after.

    mem <- c(mem_change(eval(based)),
             mem_change(eval(mutated)),
             mem_change(eval(copied)),
             mem_change(eval(modify)))

    data.table(Approach = c("Base", "Mutate", "Copy", "Modify"),
               `Memory (MB)` = mem/1e6)

    ##    Approach Memory (MB)
    ## 1:     Base    80.14947
    ## 2:   Mutate    80.37846
    ## 3:     Copy   241.51272
    ## 4:   Modify    80.03466

Not surprisingly, the `:=` approach results in the smallest change. It
is only slightly more memory than simply creating an object with
`rnorm(1e7)`.

    object_size(z <- rnorm(1e7))

    ## 80 MB

Did addresses change for any of these objects? Of course the copied one
changes as we are explicitly making a deep copy of it. But the others?
Yes, all changed except for the `dt_modify`, the one that
modified-by-reference.

    lobstr::obj_addr(dt_based)

    ## [1] "0x7fc8658fa600"

    lobstr::obj_addr(dt_mutate)

    ## [1] "0x7fc86588aff8"

    lobstr::obj_addr(dt_copied)

    ## [1] "0x7fc865858000"

    lobstr::obj_addr(dt_modify)

    ## [1] "0x7fc865952000"

Note the package information for these analyses.

    sessioninfo::package_info()

    ##  package     * version date       lib source        
    ##  assertthat    0.2.1   2019-03-21 [1] CRAN (R 3.5.2)
    ##  bench       * 1.0.4   2019-09-06 [1] CRAN (R 3.5.2)
    ##  cli           1.1.0   2019-03-19 [1] CRAN (R 3.5.2)
    ##  codetools     0.2-16  2018-12-24 [1] CRAN (R 3.5.2)
    ##  crayon        1.3.4   2017-09-16 [1] CRAN (R 3.5.0)
    ##  data.table  * 1.12.2  2019-04-07 [1] CRAN (R 3.5.2)
    ##  digest        0.6.21  2019-09-20 [1] CRAN (R 3.5.2)
    ##  dplyr       * 0.8.3   2019-07-04 [1] CRAN (R 3.5.2)
    ##  evaluate      0.14    2019-05-28 [1] CRAN (R 3.5.2)
    ##  glue          1.3.1   2019-03-12 [1] CRAN (R 3.5.2)
    ##  htmltools     0.4.0   2019-10-04 [1] CRAN (R 3.5.2)
    ##  knitr         1.25    2019-09-18 [1] CRAN (R 3.5.2)
    ##  lobstr      * 1.1.1   2019-07-02 [1] CRAN (R 3.5.2)
    ##  magrittr      1.5     2014-11-22 [1] CRAN (R 3.5.0)
    ##  pillar        1.4.2   2019-06-29 [1] CRAN (R 3.5.2)
    ##  pkgconfig     2.0.3   2019-09-22 [1] CRAN (R 3.5.2)
    ##  pryr        * 0.1.4   2018-02-18 [1] CRAN (R 3.5.0)
    ##  purrr         0.3.2   2019-03-15 [1] CRAN (R 3.5.2)
    ##  R6            2.4.0   2019-02-14 [1] CRAN (R 3.5.2)
    ##  Rcpp          1.0.2   2019-07-25 [1] CRAN (R 3.5.2)
    ##  rlang         0.4.0   2019-06-25 [1] CRAN (R 3.5.2)
    ##  rmarkdown     1.16    2019-10-01 [1] CRAN (R 3.5.2)
    ##  sessioninfo   1.1.1   2018-11-05 [1] CRAN (R 3.5.0)
    ##  stringi       1.4.3   2019-03-12 [1] CRAN (R 3.5.2)
    ##  stringr       1.4.0   2019-02-10 [1] CRAN (R 3.5.2)
    ##  tibble        2.1.3   2019-06-06 [1] CRAN (R 3.5.2)
    ##  tidyselect    0.2.5   2018-10-11 [1] CRAN (R 3.5.0)
    ##  withr         2.1.2   2018-03-15 [1] CRAN (R 3.5.0)
    ##  xfun          0.10    2019-10-01 [1] CRAN (R 3.5.2)
    ##  yaml          2.2.0   2018-07-25 [1] CRAN (R 3.5.0)
    ## 
    ## [1] /Library/Frameworks/R.framework/Versions/3.5/Resources/library
