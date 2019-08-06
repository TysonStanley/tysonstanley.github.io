---
layout: post
title: "More on how base R and `data.table` work: memory usage and address"
categories: jekyll update
author: Tyson S. Barrett
comments: true
---


This post is designed to help me understand how `data.table`s `copy()`
function works, along with its *modify-by-reference* behavior (as
compared to the modify-by-copy that Hadley references in Advanced R’s
[memory chapter](http://adv-r.had.co.nz/memory.html)).

First, we’ll use four packages:

{% highlight r %}
library(microbenchmark)
library(dplyr)
library(data.table)
library(pryr)
{% endhighlight %}

The `pryr` package (pronounced Pry R) is a Hadley package that helps us
see some of the internal behavior of R.

We’ll use the following data table for this post.

{% highlight r %}
dt <- data.table(
  x = rnorm(100000),
  y = runif(100000)
)
{% endhighlight %}

It is roughly 1.6 MB and has an address of `address(dt)`. We won’t be
using this address later on because we’ll be making copies of this data
table, but note that an object has a size and address.

{% highlight r %}
object_size(dt)
address(dt)
{% endhighlight %}

    ## 1.6 MB
    ## "0x7f8986c3f600"

To better understand `data.table`’s behavior, let’s do four different
ways of adding a variable to a data frame.

1.  Use the base R way of adding a variable.
2.  Use the `mutate()` function.
3.  Use `copy()` to make a deep copy of the data table and then modify
    by reference.
4.  Use the modify-by-reference inherent with `:=` in `data.table`.

<!-- -->

{% highlight r %}
based   <- expression({dt_based$z <- rnorm(100000)})
mutated <- expression({dt_mutate <- mutate(dt_mutate, z = rnorm(100000))})
copied  <- expression({dt_copied <- copy(dt)[, z := rnorm(100000)]})
modify  <- expression({dt_modify[, z := rnorm(100000)]})
{% endhighlight %}

Because both `based`, `mutated`, and `modify` will change the original
`dt` data table, let’s create a copy for each to use and see their
corresponding addresses. Note that both change from the original `dt`
object since it is fully copied now.

{% highlight r %}
dt_based <- copy(dt)
dt_mutate <- copy(dt)
dt_modify <- copy(dt)
{% endhighlight %}
{% highlight r %}
address(dt_based)
{% endhighlight %}

    ## [1] "0x7f898ad6ba00"

{% highlight r %}
address(dt_mutate)
{% endhighlight %}

    ## [1] "0x7f898d11ca00"

{% highlight r %}
address(dt_modify)
{% endhighlight %}

    ## [1] "0x7f8986c06800"

Importantly, `copy()` does something very different than just assigning
to another name. `copy()` creates a whole new object while assigning to
another name just creates another name pointing to the same object
(until one or the other is modified). For example, the following lines
do different things. We can see this by looking at their addresses,
where `just_pointing_to_dt` is the same location and the same object.
The `copied_object` is an entirely different object with a different
address. (Hadley covers this in depth in Advanced R.)

{% highlight r %}
copied_object <- copy(dt)
just_pointing_to_dt <- dt
{% endhighlight %}
{% highlight r %}
address(dt)
{% endhighlight %}

    ## [1] "0x7f8986c3f600"

{% highlight r %}
address(copied_object)
{% endhighlight %}

    ## [1] "0x7f8986c0ac00"

{% highlight r %}
address(just_pointing_to_dt)
{% endhighlight %}

    ## [1] "0x7f8986c3f600"

First, let’s look at the memory change, from before an expression is
evaluated to after.

{% highlight r %}
mem_change(eval(based))
{% endhighlight %}

    ## 947 kB

{% highlight r %}
mem_change(eval(mutated))
{% endhighlight %}

    ## 1.18 MB

{% highlight r %}
mem_change(eval(copied))
{% endhighlight %}

    ## 3.91 MB

{% highlight r %}
mem_change(eval(modify))
{% endhighlight %}

    ## 834 kB

Not surprisingly, the `:=` approach results in the smallest change. It
is only slightly more memory than simply creating a variable with
`rnorm(100000)`. The `mutate()` way is slightly more than the base R,
which was slightly surprising to me as I had figured they were,
ultimately, doing the same thing.

{% highlight r %}
object_size(z <- rnorm(100000))
{% endhighlight %}

    ## 800 kB

Did addresses change for any of these objects? Of course the copied one
changes as we are explicitly making a deep copy of it. But the others?
Yes, all changed except for the `dt_modify`, the one that
modified-by-reference.

{% highlight r %}
address(dt_based)
{% endhighlight %}

    ## [1] "0x7f898688ae00"

{% highlight r %}
address(dt_mutate)
{% endhighlight %}

    ## [1] "0x7f898c50a3d8"

{% highlight r %}
address(dt_copied)
{% endhighlight %}

    ## [1] "0x7f898805f000"

{% highlight r %}
address(dt_modify)
{% endhighlight %}

    ## [1] "0x7f8986c06800"


That's all for now. 