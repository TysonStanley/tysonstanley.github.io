As of late, I have used the `data.table` package to do some of my data
wrangling. It has been a fun adventure (the nerd type of fun), and was
made more meaningful with the renewed development of the `dtplyr`
package by Hadley Wickham and co. I introduce some of the different
behavior of `data.table`
[here](https://tysonstanley.github.io//jekyll/update/2019/07/12/datatable/).

This post is designed to help me understand more about how `data.table`
works in regards to memory and speed. This will assess the
*modify-by-reference* behavior as compared to the modify-by-copy that
Hadley references in Advanced R’s [memory
chapter](http://adv-r.had.co.nz/memory.html).

Packages
--------

First, we’ll use the following packages to further understand R,
`data.table`, and `dplyr`.

    library(bench)      # assess speed and memory
    library(data.table) # data.table for all of its stuff
    library(dplyr)      # compare dt to mutate()
    library(pryr)       # pry open how R works
    library(lobstr)     # assess the process of R functions

Example Data
------------

We’ll use the following data table for this post.

    dt <- data.table(
      grp = rbinom(1e6, 1, .5) %>% factor,
      x = rnorm(1e6),
      y = runif(1e6)
    )

It is roughly `pryr::object_size(dt)` and has an address of
`lobstr::obj_addr(dt)`. We won’t be using this address later on because
we’ll be making copies of this data table, but note that an object has a
size and an address on your computer.

    pryr::object_size(dt)

    ## 20 MB

    lobstr::obj_addr(dt)

    ## [1] "0x7ff040b1e000"

Memory Usage
------------

The next few sections, I will look at the behavior of `data.table`
regarding:

1.  Adding a variable
2.  Filtering rows
3.  Summarizing data

### Adding a variable

To better understand `data.table`’s behavior regarding adding a
variable, let’s do four different ways of adding a variable to a data
frame.

1.  Use the base R way of adding a variable and filtering a variable.
2.  Use the `dplyr::mutate()` or `dplyr::filter()` function.
3.  Use `data.table::copy()` to make a deep copy of the data table and
    then modify by reference.
4.  Use the modify-by-reference inherent with `:=` in `data.table` or by
    using the `i` argument to filter.

Below, I grab each way and make it an R expression to be evaluated
later.

    based   <- expression({dt_based$z = rnorm(1e6); dt_based})
    mutated <- expression({dt_mutate <- mutate(dt_mutate, z = rnorm(1e6))})
    copied  <- expression({dt_copied <- copy(dt)[, z := rnorm(1e6)]})
    modify  <- expression({dt_modify[, z := rnorm(1e6)]})

Because both `based`, `mutated`, and `modify` will change the original
`dt` data table, let’s create a copy for each to use and see their
corresponding addresses. Note that both change from the original `dt`
object since it is fully copied now.

    dt_based <- copy(dt) %>% as.data.frame()
    dt_mutate <- copy(dt) %>% as_tibble()
    dt_modify <- copy(dt)

    ##                      Address
    ## 1:   Original 0x7ff040b1e000
    ## 2:   New Base 0x7ff042f90a00
    ## 3: New Mutate 0x7ff04593f8e8
    ## 4: New Modify 0x7ff0402cb600

> Importantly, `copy()` does something very different than just
> assigning to another name. `copy()` creates a whole new object while
> assigning to another name just creates another name pointing to the
> same object (until one or the other is modified).

This idea is very important to understanding `data.table`. For example,
the following lines do different things. We can see this by looking at
their addresses, where `just_pointing_to_dt` is the same location and
the same object. The `copied_object` is an entirely different object
with a different address. (Hadley covers this in depth in Advanced R.)

    copied_object <- copy(dt)
    just_pointing_to_dt <- dt

    data.table(` ` = c("Original", "Copied Object", "New Assigned Name"),
               Address = c(obj_addr(dt), 
                           obj_addr(copied_object), 
                           obj_addr(just_pointing_to_dt)))

    ##                             Address
    ## 1:          Original 0x7ff040b1e000
    ## 2:     Copied Object 0x7ff042f5f800
    ## 3: New Assigned Name 0x7ff040b1e000

So this means, at this point, `dt` and `justing_pointing_to_dt` are both
pointing to the same object. Normally, when you then go and do something
to either one, like adding a variable, R then makes a copy, as shown
below.

    just_pointing_to_dt$new_var <- rnorm(1e6)

    data.table(` ` = c("dt", "just_pointing_to_dt"),
               Address = c(obj_addr(dt), 
                           obj_addr(just_pointing_to_dt)))

    ##                               Address
    ## 1:                  dt 0x7ff040b1e000
    ## 2: just_pointing_to_dt 0x7ff04583da00

Interestingly, this makes what I just did slower. Because not only what
I telling R to create a new variable, but it was also making a copy of
the object. However, this behavior helps us not accidentally adjust `dt`
by adjusting `just_pointing_to_dt`. So now we have two separate objects,
where we had just started with one before we made any adjustments.

So first, let’s look at the relative speed and memory use of each of the
four approaches I mentioned earlier.

    bbased <- bench::mark(eval(based), iterations = 10)
    bmutat <- bench::mark(eval(mutated), iterations = 10)
    bcopy  <- bench::mark(eval(copied), iterations = 10)
    bmodif <- bench::mark(eval(modify), iterations = 10)

Results from these suggest no real differences in terms of memory and
speed for base R, mutate, and modify-in-place. The copy uses more memory
because it is making a full copy of the data.

    ## # A tibble: 4 x 2
    ##     median mem_alloc
    ##   <bch:tm> <bch:byt>
    ## 1   58.8ms    7.63MB
    ## 2   56.9ms    7.77MB
    ## 3   65.7ms    28.2MB
    ## 4   56.3ms    7.66MB

### Filtering Rows

Next, we show the behavior of the four approaches for filtering rows.

    based_filter   <- expression({dt_based[dt_based$grp == 1, ]})
    mutated_filter <- expression({dt_mutate <- filter(dt_mutate, grp == 1)})
    copied_filter  <- expression({dt_copied <- copy(dt)[grp == 1]})
    modify_filter  <- expression({dt_modify[grp == 1]})

Again, we will create copies to make adjustments to.

    dt_based <- copy(dt) %>% as.data.frame()
    dt_mutate <- copy(dt) %>% as_tibble()
    dt_modify <- copy(dt)

So what happens when we filter rows using these three approaches? Well,
each return the same data but they don’t necessarily take up the same
memory or take up the same amount of time. Overall, `dplyr::filter()`
and `data.table` are both faster and more efficient than the base R
approach. And, as before, the copy approach takes up the most memory and
speed (not shocking).

    bbased_filter <- bench::mark(eval(based_filter), iterations = 10)
    bmutat_filter <- bench::mark(eval(mutated_filter), iterations = 10)
    bcopy_filter  <- bench::mark(eval(copied_filter), iterations = 10)
    bmodif_filter <- bench::mark(eval(modify_filter), iterations = 10)

    ## # A tibble: 4 x 2
    ##     median mem_alloc
    ##   <bch:tm> <bch:byt>
    ## 1   65.8ms    61.3MB
    ## 2   23.4ms    51.5MB
    ## 3   42.6ms    57.4MB
    ## 4   39.3ms    38.2MB

### Summarizing Data

Finally, we show the behavior of the four approaches for summarizing
data. First, we will simply take the mean of `x` by `grp` in each.

    based_mean   <- expression({tapply(dt_based$x, dt_based$grp, mean)})
    mutated_mean <- expression({summarize(group_by(dt_mutate, grp), mean(x))})
    copied_mean  <- expression({dt_copied <- copy(dt)[, mean(x), by = "grp"]})
    modify_mean  <- expression({dt_modify[, mean(x), by = "grp"]})

Again, we will create copies to make adjustments to.

    dt_based <- copy(dt) %>% as.data.frame()
    dt_mutate <- copy(dt) %>% as_tibble()
    dt_modify <- copy(dt)

Overall, `dplyr::group_by() %>% dplyr::summarize()` is very efficient
but slightly slower than `data.table`.

    bbased_mean <- bench::mark(eval(based_mean), iterations = 10)
    bmutat_mean <- bench::mark(eval(mutated_mean), iterations = 10)
    bcopy_mean  <- bench::mark(eval(copied_mean), iterations = 10)
    bmodif_mean <- bench::mark(eval(modify_mean), iterations = 10)

    ## # A tibble: 4 x 2
    ##     median mem_alloc
    ##   <bch:tm> <bch:byt>
    ## 1     17ms   19.12MB
    ## 2   23.3ms    4.03MB
    ## 3   26.1ms   43.99MB
    ## 4   19.9ms   24.85MB

What if we order the groups first?

    based_mean   <- expression({tapply(dt_based$x, dt_based$grp, mean)})
    mutated_mean <- expression({summarize(group_by(dt_mutate, grp), mean(x))})
    copied_mean  <- expression({dt_copied <- copy(dt)[, mean(x), by = "grp"]})
    modify_mean  <- expression({dt_modify[, mean(x), by = "grp"]})

Again, we will create copies to make adjustments to.

    dt_based <- copy(dt) %>% as.data.frame() %>% .[order(.$grp), ]
    dt_mutate <- copy(dt) %>% as_tibble() %>% arrange(grp)
    dt_modify <- copy(dt)[order(grp)]

The `data.table` approach speeds up a bit while the others don’t change.
Again, though, `dplyr::group_by() %>% dplyr::summarize()` is very
efficient compared to the others.

    bbased_mean <- bench::mark(eval(based_mean), iterations = 10)
    bmutat_mean <- bench::mark(eval(mutated_mean), iterations = 10)
    bcopy_mean  <- bench::mark(eval(copied_mean), iterations = 10)
    bmodif_mean <- bench::mark(eval(modify_mean), iterations = 10)

    ## # A tibble: 4 x 2
    ##     median mem_alloc
    ##   <bch:tm> <bch:byt>
    ## 1   12.9ms   19.07MB
    ## 2   23.6ms    3.81MB
    ## 3   30.6ms   43.94MB
    ## 4   14.9ms   24.85MB

Now let’s summarize a group of variables; in this case, summarizing both
`x` and `y` using loops. Since it is clear what `copy()` is doing, we
won’t make the comparison here.

    based_loop   <- expression({lapply(dt_based[, c("x", "y")], function(x) tapply(x, dt_based$grp, mean))})
    mutated_loop <- expression({summarize_all(group_by(dt_mutate, grp), mean)})
    modify_loop  <- expression({dt_modify[, lapply(.SD, mean), by = "grp"]})

Again, we will create copies to make adjustments to.

    dt_based <- copy(dt) %>% as.data.frame()
    dt_mutate <- copy(dt) %>% as_tibble()
    dt_modify <- copy(dt)

This shows the exact same pattern, with
`dplyr::group_by() %>% dplyr::summarize()` being extremely efficient
compared to the others while `data.table` is somewhat faster.

    bbased_mean <- bench::mark(eval(based_loop), iterations = 10)
    bmutat_mean <- bench::mark(eval(mutated_loop), iterations = 10)
    bmodif_mean <- bench::mark(eval(modify_loop), iterations = 10)

    ## # A tibble: 3 x 2
    ##     median mem_alloc
    ##   <bch:tm> <bch:byt>
    ## 1   32.9ms   38.16MB
    ## 2   30.1ms    3.94MB
    ## 3   23.9ms   28.66MB

#### Aside: Why is `dplyr` so efficient in summarizing?

    bmutat_mean$memory

    ## [[1]]
    ## Memory allocations:
    ##        what   bytes
    ## 1     alloc     512
    ## 2     alloc    2040
    ## 3     alloc    2040
    ## 4     alloc    1072
    ## 5     alloc     256
    ## 6     alloc     616
    ## 7     alloc    2816
    ## 8     alloc    2816
    ## 9     alloc    1072
    ## 10    alloc     240
    ## 11    alloc     432
    ## 12    alloc     224
    ## 13    alloc     240
    ## 14    alloc     336
    ## 15    alloc    1096
    ## 16    alloc    1096
    ## 17    alloc    1072
    ## 18    alloc 1999352
    ## 19    alloc 2000744
    ## 20    alloc     632
    ## 21    alloc    2560
    ## 22    alloc    2560
    ## 23    alloc    1072
    ## 24    alloc     288
    ## 25    alloc     520
    ## 26    alloc     240
    ## 27    alloc     288
    ## 28    alloc     272
    ## 29    alloc     544
    ## 30    alloc     544
    ## 31    alloc    1072
    ## 32    alloc     264
    ## 33    alloc     472
    ## 34    alloc     472
    ## 35    alloc    1072
    ## 36    alloc     320
    ## 37    alloc     888
    ## 38    alloc     888
    ## 39    alloc    1072
    ## 40    alloc     192
    ## 41    alloc    2632
    ## 42    alloc   15936
    ## 43    alloc   15928
    ## 44    alloc    1072
    ## 45    alloc     384
    ## 46    alloc     960
    ## 47    alloc    1864
    ## 48    alloc     664
    ## 49    alloc     288
    ## 50    alloc     584
    ## 51    alloc    1120
    ## 52    alloc     480
    ## 53    alloc     584
    ## 54    alloc     960
    ## 55    alloc     280
    ## 56    alloc     608
    ## 57    alloc     608
    ## 58    alloc    1072
    ## 59    alloc    3056
    ## 60    alloc   16720
    ## 61    alloc   16720
    ## 62    alloc    1072
    ## 63    alloc     656
    ## 64    alloc    2040
    ## 65    alloc    4032
    ## 66    alloc    1352
    ## 67    alloc    2040
    ## total       4128016
    ##                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    calls
    ## 1                                                                                                                                                                                                                                                            <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval()
    ## 2                                                                                                                                                                                                                                                            <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval()
    ## 3                                                                                                                                                                                                                                                            <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval()
    ## 4                                                                                                                                                                                                                                                            <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval()
    ## 5                                                                                                                                                                                                                                                            <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval()
    ## 6                                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all()
    ## 7                                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all()
    ## 8                                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all()
    ## 9                                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all()
    ## 10                                                                                                                                                                                                                                        <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all()
    ## 11                                                                                                                                                                                                                                        <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all()
    ## 12                                                                                                                                                                                                                                        <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all()
    ## 13                                                                                                                                                                                                                                        <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all()
    ## 14                                                                                                                                                                                          <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply()
    ## 15                                                                                                                                                                                          <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply()
    ## 16                                                                                                                                                                                          <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply()
    ## 17                                                                                                                                                                                          <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply()
    ## 18    <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply() -> tbl_nongroup_vars() -> setdiff() -> tbl_vars() -> new_sel_vars() -> structure() -> tbl_vars_dispatch() -> group_by() -> group_by.data.frame() -> grouped_df() -> grouped_df_impl()
    ## 19    <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply() -> tbl_nongroup_vars() -> setdiff() -> tbl_vars() -> new_sel_vars() -> structure() -> tbl_vars_dispatch() -> group_by() -> group_by.data.frame() -> grouped_df() -> grouped_df_impl()
    ## 20                                                                                       <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply() -> tbl_nongroup_vars() -> setdiff() -> tbl_vars() -> new_sel_vars() -> structure() -> group_vars()
    ## 21                                                                                       <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply() -> tbl_nongroup_vars() -> setdiff() -> tbl_vars() -> new_sel_vars() -> structure() -> group_vars()
    ## 22                                                                                       <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply() -> tbl_nongroup_vars() -> setdiff() -> tbl_vars() -> new_sel_vars() -> structure() -> group_vars()
    ## 23                                                                                       <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply() -> tbl_nongroup_vars() -> setdiff() -> tbl_vars() -> new_sel_vars() -> structure() -> group_vars()
    ## 24                                                                                       <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply() -> tbl_nongroup_vars() -> setdiff() -> tbl_vars() -> new_sel_vars() -> structure() -> group_vars()
    ## 25                                                                                       <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply() -> tbl_nongroup_vars() -> setdiff() -> tbl_vars() -> new_sel_vars() -> structure() -> group_vars()
    ## 26                                                                                       <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply() -> tbl_nongroup_vars() -> setdiff() -> tbl_vars() -> new_sel_vars() -> structure() -> group_vars()
    ## 27                                                                                       <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply() -> tbl_nongroup_vars() -> setdiff() -> tbl_vars() -> new_sel_vars() -> structure() -> group_vars()
    ## 28                                            <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply() -> tbl_nongroup_vars() -> setdiff() -> tbl_vars() -> new_sel_vars() -> structure() -> group_vars() -> group_vars.grouped_df() -> group_data()
    ## 29                                            <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply() -> tbl_nongroup_vars() -> setdiff() -> tbl_vars() -> new_sel_vars() -> structure() -> group_vars() -> group_vars.grouped_df() -> group_data()
    ## 30                                            <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply() -> tbl_nongroup_vars() -> setdiff() -> tbl_vars() -> new_sel_vars() -> structure() -> group_vars() -> group_vars.grouped_df() -> group_data()
    ## 31                                            <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply() -> tbl_nongroup_vars() -> setdiff() -> tbl_vars() -> new_sel_vars() -> structure() -> group_vars() -> group_vars.grouped_df() -> group_data()
    ## 32                 <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply() -> tbl_nongroup_vars() -> setdiff() -> tbl_vars() -> new_sel_vars() -> structure() -> group_vars() -> group_vars.grouped_df() -> group_data() -> group_data.grouped_df()
    ## 33                 <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply() -> tbl_nongroup_vars() -> setdiff() -> tbl_vars() -> new_sel_vars() -> structure() -> group_vars() -> group_vars.grouped_df() -> group_data() -> group_data.grouped_df()
    ## 34                 <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply() -> tbl_nongroup_vars() -> setdiff() -> tbl_vars() -> new_sel_vars() -> structure() -> group_vars() -> group_vars.grouped_df() -> group_data() -> group_data.grouped_df()
    ## 35                 <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply() -> tbl_nongroup_vars() -> setdiff() -> tbl_vars() -> new_sel_vars() -> structure() -> group_vars() -> group_vars.grouped_df() -> group_data() -> group_data.grouped_df()
    ## 36                                                                                                                                                      <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply() -> tbl_nongroup_vars() -> setdiff()
    ## 37                                                                                                                                                      <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply() -> tbl_nongroup_vars() -> setdiff()
    ## 38                                                                                                                                                      <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply() -> tbl_nongroup_vars() -> setdiff()
    ## 39                                                                                                                                                      <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply() -> tbl_nongroup_vars() -> setdiff()
    ## 40                                                                                                                                                      <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> syms() -> map() -> lapply() -> tbl_nongroup_vars() -> setdiff()
    ## 41                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all()
    ## 42                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all()
    ## 43                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all()
    ## 44                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all()
    ## 45                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all()
    ## 46                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all()
    ## 47                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all()
    ## 48                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all()
    ## 49                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all()
    ## 50                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all()
    ## 51                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all()
    ## 52                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all()
    ## 53                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all()
    ## 54                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all()
    ## 55                                                                                                                                                                                                        <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> as_fun_list()
    ## 56                                                                                                                                                                                                        <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> as_fun_list()
    ## 57                                                                                                                                                                                                        <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> as_fun_list()
    ## 58                                                                                                                                                                                                        <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all() -> as_fun_list()
    ## 59                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all()
    ## 60                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all()
    ## 61                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all()
    ## 62                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all()
    ## 63                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all()
    ## 64                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all()
    ## 65                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all()
    ## 66                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all()
    ## 67                                                                                                                                                                                                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> summarize_all() -> manip_all()
    ## total

    bmodif_mean$memory

    ## [[1]]
    ## Memory allocations:
    ##        what    bytes
    ## 1     alloc      280
    ## 2     alloc     8240
    ## 3     alloc     8240
    ## 4     alloc  4000048
    ## 5     alloc  2000744
    ## 6     alloc     8256
    ## 7     alloc  4001440
    ## 8     alloc  4001440
    ## 9     alloc     8256
    ## 10    alloc      280
    ## 11    alloc  4000056
    ## 12    alloc  2000056
    ## 13    alloc  2000056
    ## 14    alloc  8000056
    ## 15    alloc     8264
    ## 16    alloc     8264
    ## total       30053976
    ##                                                                                                                                                                                                                                                                                                                                                                                                                                          calls
    ## 1                            <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> [() -> [.data.table() -> new.env()
    ## 2     <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> [() -> [.data.table() -> null.data.table() -> alloc.col()
    ## 3     <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> [() -> [.data.table() -> null.data.table() -> alloc.col()
    ## 4                            <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> [() -> [.data.table() -> forderv()
    ## 5                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> [() -> [.data.table()
    ## 6                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> [() -> [.data.table()
    ## 7                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> [() -> [.data.table()
    ## 8                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> [() -> [.data.table()
    ## 9                                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> [() -> [.data.table()
    ## 10                           <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> [() -> [.data.table() -> new.env()
    ## 11                            <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> [() -> [.data.table() -> gforce()
    ## 12                            <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> [() -> [.data.table() -> gforce()
    ## 13                            <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> [() -> [.data.table() -> gforce()
    ## 14                            <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> [() -> [.data.table() -> gforce()
    ## 15                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> [() -> [.data.table() -> alloc.col()
    ## 16                         <Anonymous> -> <Anonymous> -> process_file() -> withCallingHandlers() -> process_group() -> process_group.block() -> call_block() -> block_exec() -> in_dir() -> evaluate() -> <Anonymous> -> evaluate_call() -> timing_fn() -> handle() -> withCallingHandlers() -> withVisible() -> eval() -> eval() -> <Anonymous> -> eval_one() -> eval() -> eval() -> eval() -> eval() -> [() -> [.data.table() -> alloc.col()
    ## total

TL;DR
-----

In cases of adding a variable, filtering rows, and summarizing data,
both `dplyr` and `data.table` perform very well.

1.  Base R, `dplyr`, and `data.table` perform similarly when adding a
    single variable to an already copied data set.
2.  `data.table` is very efficient in filtering and both `dplyr` and
    `data.table` perform similarly in terms of speed.
3.  `dplyr` shows great memory efficiency in summarizing, while
    `data.table` is generally the fastest approach.

### Package Information

Note the package information for these analyses.

    sessioninfo::package_info()

    ##  package     * version date       lib source                        
    ##  assertthat    0.2.1   2019-03-21 [1] CRAN (R 3.5.2)                
    ##  bench       * 1.0.4   2019-09-06 [1] CRAN (R 3.5.2)                
    ##  cli           1.1.0   2019-03-19 [1] CRAN (R 3.5.2)                
    ##  codetools     0.2-15  2016-10-05 [1] CRAN (R 3.5.2)                
    ##  crayon        1.3.4   2017-09-16 [1] CRAN (R 3.5.0)                
    ##  data.table  * 1.12.0  2019-01-13 [1] CRAN (R 3.5.2)                
    ##  digest        0.6.21  2019-09-20 [1] CRAN (R 3.5.2)                
    ##  dplyr       * 0.8.3   2019-07-04 [1] CRAN (R 3.5.2)                
    ##  evaluate      0.14    2019-05-28 [1] CRAN (R 3.5.2)                
    ##  fansi         0.4.0   2018-10-05 [1] Github (brodieG/fansi@ab11e9c)
    ##  glue          1.3.1   2019-03-12 [1] CRAN (R 3.5.2)                
    ##  htmltools     0.3.6   2017-04-28 [1] CRAN (R 3.5.0)                
    ##  knitr         1.23    2019-05-18 [1] CRAN (R 3.5.2)                
    ##  lobstr      * 1.1.1   2019-07-02 [1] CRAN (R 3.5.2)                
    ##  magrittr      1.5     2014-11-22 [1] CRAN (R 3.5.0)                
    ##  pillar        1.4.2   2019-06-29 [1] CRAN (R 3.5.2)                
    ##  pkgconfig     2.0.3   2019-09-22 [1] CRAN (R 3.5.2)                
    ##  profmem       0.5.0   2018-01-30 [1] CRAN (R 3.5.0)                
    ##  pryr        * 0.1.4   2018-02-18 [1] CRAN (R 3.5.0)                
    ##  purrr         0.3.2   2019-03-15 [1] CRAN (R 3.5.2)                
    ##  R6            2.4.0   2019-02-14 [1] CRAN (R 3.5.2)                
    ##  Rcpp          1.0.2   2019-07-25 [1] CRAN (R 3.5.2)                
    ##  rlang         0.4.0   2019-06-25 [1] CRAN (R 3.5.2)                
    ##  rmarkdown     1.12    2019-03-14 [1] CRAN (R 3.5.2)                
    ##  sessioninfo   1.1.1   2018-11-05 [1] CRAN (R 3.5.0)                
    ##  stringi       1.4.3   2019-03-12 [1] CRAN (R 3.5.2)                
    ##  stringr       1.4.0   2019-02-10 [1] CRAN (R 3.5.2)                
    ##  tibble        2.1.3   2019-06-06 [1] CRAN (R 3.5.2)                
    ##  tidyselect    0.2.5   2018-10-11 [1] CRAN (R 3.5.0)                
    ##  utf8          1.1.4   2018-05-24 [1] CRAN (R 3.5.0)                
    ##  withr         2.1.2   2018-03-15 [1] CRAN (R 3.5.0)                
    ##  xfun          0.8     2019-06-25 [1] CRAN (R 3.5.2)                
    ##  yaml          2.2.0   2018-07-25 [1] CRAN (R 3.5.0)                
    ## 
    ## [1] /Library/Frameworks/R.framework/Versions/3.5/Resources/library
