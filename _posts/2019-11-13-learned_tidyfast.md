---
layout: post
title: "Six Things I Learned While Making `tidyfast`"
categories: jekyll update
author: Tyson S. Barrett
comments: true
---

This post highlights six major themes of what I learned while creating the
[`tidyfast` R package](https://tysonbarrett.com/tidyfast/). This process
taught me about the `tidyverse`, `data.table`, `R`, and data science in
general.

Before getting into that though, disclaimer: I am not part of the
development teams of either the `tidyverse` or `data.table`. Instead, I
am a big fan of both, and have profound gratitude for what they’ve
allowed R to become. As such, my lessons are my opinions and don’t
reflect the opinions of either group. And it should be noted that these
are things I learned making a package that creates tidy-like functions
with `data.table`. As such, most of the topics discussed will have to do
with these packages.

TL;DR
-----

My six lessons learned:

1.  `tidyverse` and `data.table` have many similarities even though
    their overall frameworks are different
2.  Both the `tidyverse` and `data.table` are doing things to make it
    harder to mess up your data
3.  Data grammar, as explicitly stated in `dplyr`, is important
4.  Speed and efficiency, as shown by `data.table`, are important
5.  Both 3 and 4 are not mutually exclusive
6.  Nothing works for every situation, but a general workflow can apply
    to most situations

These lessons highlight the complimentarity and overlap between the
powerful frameworks of the `tidyverse` and `data.table`.

Lesson 1: `tidyverse` and `data.table` have many similarities even though their overall frameworks are different
----------------------------------------------------------------------------------------------------------------

With the obvious differences between the two, I’m not sure what I was
expecting here. But as I became more familiar with both, similarities
became more and more clear. Consider some of those similarities below:

-   Both use an extension of data frames. The `tidyverse` has `tibbles`,
    which come with a cleaner and clearer printing method, is safer
    (doesn’t change types as easily), and allows informative attributes
    (e.g. grouped data). Similarly, `data.table` has a more informative
    printing method, is safer (again makes accidental changes of types
    harder), and has informative attributes (e.g. sorted by the key).
    As an example, the printing approaches are shown below:

{% highlight r %}
library(tidyverse)
library(data.table)
library(nycflights13)

flights2 <- flights[, 1:6]
flights_tbl <- as_tibble(flights2)
flights_dt <- as.data.table(flights2)

flights_tbl
{% endhighlight %}

    ## # A tibble: 336,776 x 6
    ##     year month   day dep_time sched_dep_time dep_delay
    ##    <int> <int> <int>    <int>          <int>     <dbl>
    ##  1  2013     1     1      517            515         2
    ##  2  2013     1     1      533            529         4
    ##  3  2013     1     1      542            540         2
    ##  4  2013     1     1      544            545        -1
    ##  5  2013     1     1      554            600        -6
    ##  6  2013     1     1      554            558        -4
    ##  7  2013     1     1      555            600        -5
    ##  8  2013     1     1      557            600        -3
    ##  9  2013     1     1      557            600        -3
    ## 10  2013     1     1      558            600        -2
    ## # … with 336,766 more rows

{% highlight r %}
flights_dt
{% endhighlight %}

    ##         year month day dep_time sched_dep_time dep_delay
    ##      1: 2013     1   1      517            515         2
    ##      2: 2013     1   1      533            529         4
    ##      3: 2013     1   1      542            540         2
    ##      4: 2013     1   1      544            545        -1
    ##      5: 2013     1   1      554            600        -6
    ##     ---                                                 
    ## 336772: 2013     9  30       NA           1455        NA
    ## 336773: 2013     9  30       NA           2200        NA
    ## 336774: 2013     9  30       NA           1210        NA
    ## 336775: 2013     9  30       NA           1159        NA
    ## 336776: 2013     9  30       NA            840        NA

-   Both rely on non-standard evaluation, making it easier to interact
    with variables without redundancies. For example, in the
    `tidyverse`, interacting with variables happens within functions
    that don’t require repetitive `df$..` code or lots of quotes.
    `data.table` does this similarly, but within the `data.table` square brackes
    (e.g. `dt[var == 1]`). The form of non-standard evaluation does
    differ somewhat between the two (I’ll discuss this later). For now,
    consider the following examples showing their similar syntax:

{% highlight r %}
# tidyverse
filter(flights_tbl, dep_delay > 100)
# data.table
flights_dt[dep_delay > 100]
{% endhighlight %}

-   Both have a way of piping/chaining commands. `tidyverse` uses pipes
    (`%>%`) while `data.table` has built in functionality with their
    square brackets (`[]`). Notably, pipes can be used with `data.table`
    but hasn’t seemed to be used a lot yet.

-   Both use either `C` or `C++` to improve speed. `data.table` uses
    this for nearly all of the functionality, while `tidyverse` uses it
    often but not nearly as much.
    
-   Both have ways to interact with their non-standard evaluation 
    programmatically. They go about it very differently, but both 
    allow this to happen in various ways (e.g. `{{ }}` operator in `dplyr`).

-   Both have a team of developers that work together in a synergistic
    fashion. These teams come with a range of experiences, expertise,
    and perspectives.

On the other hand, there are important differences in emphasis, style,
and framework. These differences make the two, in my opinion, quite
complimentary. Where one falls short, the other shines. And vice versa.
Some of these differences will be highlighted in these next lessons
discussed next. But here I wanted to highlight some notable differences.

-   `tidyverse` has recently emphasized type safety (see
    [`vctrs`](https://vctrs.r-lib.org) for example). This matches
    their overall style of being explicit in all behavior. This, at
    times, is at the expense of parsimony.

-   `data.table` emphasizes speed and efficiency in both performance and
    syntax. This creates flexibility and conciseness, but, at times, can
    lack explicit syntax. Most of the underlying behavior of
    `data.table` relies on their extensive library of `C` code that
    almost always creates opportunities to work with data that most
    other programs could not even begin to work with.

-   `tidyverse` works with a whole host of packages (possibly somewhat based on
    the idea of [“conscious decoupling”](https://www.tidyverse.org/blog/2018/10/devtools-2-0-0/#conscious-uncoupling)) 
    all designed for specific purposes. This makes it so these have several 
    dependencies (`dplyr` currently as 11 imports and 25 suggests). 
    `data.table`, on the other hand, is very self-contained with only 
    1 import (“methods”, which is always included in R) and 8
    suggests. This idea is not as simple as just counting dependencies, however.
    To better understand the situation, I recommend watching Jim Hester's
    [talk](https://resources.rstudio.com/rstudio-conf-2019/it-depends-a-dialog-about-dependencies).

-   Related to dependencies, the `tidyverse` has many (100’s) functions
    that are clear about their functionality. `data.table` has only a
    few functions total. Depending on your personal
    preferences, one may work better than the other for you. But keep in mind,
    and I discuss it more later on, that nearly all functionality in each 
    can be replicated by the other (some of this is shown in `dtplyr` and 
    `tidyfast`).

-   `data.table` uses a special operator that assigns by reference (or
    in place). This avoids a copy of the data, but with how R does
    shallow copies (only copies what is absolutely necessary), this has
    become less necessary. As such, the `tidyverse` does not use any
    modifications in place.

These are just some of the differences, and in several ways, it helps
meet the needs of a variety of analysts with varying styles. Instead of
a weakness in the R world, I see this as a great strength. This strength
has been clearly demonstrated even more so with the collaboration 
between `data.table` and `tidyverse` teams on making `dtplyr`.

Lesson 2: Both the `tidyverse` and `data.table` are doing things to make it harder to mess up your data
-------------------------------------------------------------------------------------------------------

In `vctrs`, Hadley and the `tidyverse` team show some crazy examples of
ways R can really mess up. Consider:

{% highlight r %}
c(factor("a"), factor("a"))
{% endhighlight %}

    ## [1] 1 1

If you are like me, your first reaction was a series of emojis: 🤔 😱 😞 😿
🤨. The `tidyverse` team has been working on ways to make sure things
like this don’t happen, particularly with `vctrs`.

Importantly, though, both `data.table` and `tidyverse` have many safety
checks to make sure one doesn’t mix data types already integrated into
their frameworks. Along with these safety checks, they both have more
informative errors, that can help shape how a user can fix any issues
they encounter. Compared to base R errors, these are much more
approachable.

Personally, I’m grateful for both working hard to make it easier to keep
my data consistent and to work through errors.

Lesson 3: Data grammar is important
-----------------------------------

Being able to communicate about data wrangling across languages is
important. It allows individuals to communicate methods, goals, and
ideals, without regards to how these are actually done with code. For
example, being able to discuss the steps needed to extract, manipulate,
and clean data using SQL or R is often beneficial within an
organization.

However, even more important is being able to communicate within a
language. Recently, this has been a concern for some with the rise of
the `tidyverse`, as it has profoundly changed the way users interact
with R. The concern is that the use of R could become split, with some
only using `tidyverse` syntax while others use more base R syntax (or
`data.table` syntax).

This may become the case in years to come. I don’t know. But I’m not
convinced that it is a problem. The thing that needs to be clear is the
grammar of what is happening, regardless of the syntax used to perform
it. Whether one is using all base R syntax or using pipes and other tidy
functions, it is important that we can communicate what is actually
being done with the data in concrete, accepted terminology. Because
`dplyr` and friends already offer a grammar that has been widely
accepted in the R community, it is probably smart to build on this and
use, at least some, of the verbs offered there. This, whether explicitly
used in function names or implicitly through base R or `data.table`
syntax, is less important (although arguably relevant in some contexts).
But the adoption of the grammar is what is important—to be able to
communicate across modalities and styles.[1]


Lesson 4: Speed and efficiency are important
--------------------------------------------

It is a common misconception that R is super slow, when in fact it can
be incredibly fast. A little familiarization with `data.table` can be
convincing pretty quickly that R is often as fast or faster than other
data software. Just see the table on [`data.table`s
website](https://h2oai.github.io/db-benchmark/). It clearly shows how
well R stacks up to other major data software (particularly when using
`data.table`).

In many situations, this performance is not just nice, it is necessary.
A recent tweet by [Ivan Leung](https://twitter.com/urganmax) highlighted
one way an organization sees data work across different packages given
they work with much more than 1 million lines of data.

<blockquote class="twitter-tweet">
<p lang="en" dir="ltr">
<a href="https://twitter.com/mdancho84?ref_src=twsrc%5Etfw">@mdancho84</a>
<a href="https://twitter.com/bizScienc?ref_src=twsrc%5Etfw">@bizScienc</a>
guide is my go-to (see pic).<br><br>I like keeping input, model & output
objects in one dataframe; nesting is ideal for this, with combo of
mutate+map\*(). But tidyverse framework hits a limit with bigger data
set…{tidyfast} to the rescue 🙌🏼
<a href="https://t.co/VbAgpj5Yvh">pic.twitter.com/VbAgpj5Yvh</a>
</p>
— Ivan Leung (@urganmax)
<a href="https://twitter.com/urganmax/status/1194374362410864640?ref_src=twsrc%5Etfw">November
12, 2019</a>
</blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

Lesson 5: Grammar and speed/efficiency are not mutually exclusive
-----------------------------------------------------------------

It may seem, at times, that you can have an explicit, easy-to-read
syntax or speed/efficiency. Turns out, there is no such dichotomy. In
fact, both can happen simultaneously. There are several examples:

-   Many functions in `dplyr` are both relatively fast (sometimes using
    Rcpp under the hood) and explicit in functionality.
-   `tidyfast` attempts to do have explicit functionality with other
    functions (e.g. nesting and unnesting) using `data.table` behind the
    scenes.
-   `dtplyr` makes use of this extensively by making many `dplyr`
    functions built on `data.table`.
-   `data.table`s `fread()` function is extremely fast and explicit in
    functionality.
-   `data.table`s `dt[i, j, by]` syntax can be very clear in function
    while being extremely fast.

Importantly, though, is that familiarity with `data.table` or base R (or
any other syntax) makes many functions that don’t explicitly use the
grammar just as clear as if they were. That is, the readability of code
depends heavily on who is reading it. But to emphasize lesson 3, we
should still be able to communicate what is happening with a shared
grammar.

This leads us to our last lesson.

Lesson 6: Nothing works for every situation, but a general workflow can apply to most situations
------------------------------------------------------------------------------------------------

As much as I’ve wanted a single framework to work well for every data
situation that I find myself in, it just doesn’t seem to exist. Some
situations lend themselves to one; and another to another. So what can
one do? Learn everything?

I don’t think so. Instead, I think learning workflows that allows you to
take messy, disconnected data to tidy, connected data is what will help
in nearly all situations.

This relates to understanding the data grammar. With such understanding,
you can search for the data verb you need to perform and the framework
that would work best for your situation. This is ultimately what led me
to start working on `tidyfast`. I wanted to see if a very “tidy”
approach, that of nesting and unnesting data into and from list-columns
could be done in a “non-tidy” package: `data.table`. It became clear
that it could be done.

The functions found in `tidyfast` show that a common grammar (using the
terms “nesting” and “unnesting” data into list-columns) was transferable
and could be replicated with code that looks very different. Even though
the functions in `tidyfast` are not nearly as well tested and used as
those found in the `tidyverse`, it is an option that can be used in
situations that call for it without changing the overall workflow or
changing the data grammar that is used.

Miscellaneous Notes
------------------

Any general workflow should include *safe-guards*. This is particularly
necessary when you are using a syntax you are less familiar with. These
safe-guards can be:

-   including simple tests (e.g. `assertthat`) in your scripts that make
    sure things are working
-   using data approaches like nesting to keep analyses and cleaning
    within groups
-   avoiding excessive copying-and-pasting and, instead, 
    rely more on functions and loops
-   read the documentation on any packages you are using

These can help one regardless of workflow preferences.

Conclusions
-----------

R is a beautiful mix of various styles of syntax that can provide
functionality for nearly any data situation. Both `tidyverse` and
`data.table` have much overlap in functionality but also offer vast
complementarity. This provides great strength to the R community and
adds flexibility to handle a wide range of data challenges.

#### Upcoming Post

In the next few weeks, I will post about a general workflow that can be
used with `dtplyr` and `tidyfast` together. This will provide a general
example that can be used when needed.

[1] Note, the `dt[i, j, by]` arguably is a grammar itself but is not
often appreciated as such.
