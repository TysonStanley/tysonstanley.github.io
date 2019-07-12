---
layout: post
title: "Why I Chose to Learn `data.table` (and such related things)"
categories: jekyll update
author: Tyson S. Barrett
comments: true
---


The `data.table` package has been a fun thing to learn about this week.

Since getting into R several years ago, I had known `data.table` was a
fast and efficient tool for larger data sets. I had tried using it but
got confused early on and, unfortunately, switched to what I knew (mainly just
`data.frame`s).

Then came along the `tidyverse`. Suddenly, R was straightforward; I was
making less errors, producing meaningful insights, and more fully
enjoying data analysis. It was a great way to become more productive and
transparent in my code.

Recently, though, I’ve come to realize that I had a renewed interest in
`data.table`. But it is difficult to break out of the habit of the same
workflow I had been using for the past few years with `dplyr` and
friends. But then I came across Elio’s
[post](https://eliocamp.github.io/codigo-r/en/2019/07/why-i-love-data-table/)
about using pipes (`%>%`) with `data.table`. This was incredibly
eye-opening to me! I had no idea that the tools that I liked the most
would work so flawlessly with `data.table`.

Since then I’ve been trying to learn as much as I could about what makes
`data.table` great. Turns out, there are a lot! But with it, comes some
learning, particularly about the ins-and-outs of “modifying by
reference”.

To help both you and me remember some of the ways that `data.table`
works, I put this small post together.

What does it mean to "modify by reference?"
-------------------------------------------

Well, it essentially means we are not creating a new object (by copying) when we make
certain types of changes to a data table. There are different forms of copying (shallow and deep) but we won't dive into that here. Instead, I just want to highlight the basics of it.

To start, let’s create a data table.

{% highlight r %}
library(magrittr)
library(data.table)
library(dplyr)

dt <- data.table(x = rnorm(1000),
                 y = rnorm(1000))
dt
{% endhighlight %}

    ##                 x          y
    ##    1: -1.15896577 -0.2353484
    ##    2: -0.01390793  0.6754804
    ##    3:  0.67174583  0.4768178
    ##    4: -0.63404027 -0.7564434
    ##    5: -0.08900686  1.6690585
    ##   ---                       
    ##  996: -0.03963833  1.2541693
    ##  997: -1.12119906 -0.4761572
    ##  998:  0.36184986  1.3305127
    ##  999:  1.33421477  0.2147001
    ## 1000:  0.48826897 -0.1454968

This object is located in the computer at:

{% highlight r %}
tracemem(dt)
{% endhighlight %}

    ## [1] "<0x7f85af59c200>"

This means that the name `dt` is just pointing to that location, where the data table with two variables lives. If we make changes to `dt` in the way `data.table` likes to (by reference), then the object is not copied (or else the criptic `"<...>"` message would show
up telling us we made a copy).

{% highlight r %}
dt[, z := rnorm(1000)]
dt
{% endhighlight %}

    ##                 x          y          z
    ##    1: -1.15896577 -0.2353484 -0.7019355
    ##    2: -0.01390793  0.6754804 -1.4883665
    ##    3:  0.67174583  0.4768178 -0.6216924
    ##    4: -0.63404027 -0.7564434  1.1432773
    ##    5: -0.08900686  1.6690585 -2.0481956
    ##   ---                                  
    ##  996: -0.03963833  1.2541693 -0.1078108
    ##  997: -1.12119906 -0.4761572  0.3982713
    ##  998:  0.36184986  1.3305127  1.3616968
    ##  999:  1.33421477  0.2147001  1.3059844
    ## 1000:  0.48826897 -0.1454968  1.2999326

So now that same location: `"<0x7f85af59c200>"` holds a data table with 3 variables.

Importantly, this approach means that if we make a new pointer (in essence a new name
that points to the same data), then changes to one makes changes to the
other. This can be seen with us creating a new “object” called `dt2`. In
reality, `dt2` just points to the same data that `dt` was pointing to.
So, if we change `dt` by reference, it will change `dt2` as well. (Note,
by using `:= NULL`, we are removing that variable.)

{% highlight r %}
dt2 <- dt
dt[, z := NULL]

dt2
{% endhighlight %}

    ##                 x          y
    ##    1: -1.15896577 -0.2353484
    ##    2: -0.01390793  0.6754804
    ##    3:  0.67174583  0.4768178
    ##    4: -0.63404027 -0.7564434
    ##    5: -0.08900686  1.6690585
    ##   ---                       
    ##  996: -0.03963833  1.2541693
    ##  997: -1.12119906 -0.4761572
    ##  998:  0.36184986  1.3305127
    ##  999:  1.33421477  0.2147001
    ## 1000:  0.48826897 -0.1454968

This is different than what happens when we don’t modify by reference.
Notice that below, we create and modify the `dt3` object (originally it
was pointing to the same data as `dt`). At the moment we make a change,
a new data object is “created” (thus the tracemem output telling us we
made a copy).

{% highlight r %}
dt3 <- dt
dt3$a <- rnorm(1000)
{% endhighlight %}

    ## tracemem[0x7f85af59c200 -> 0x7f85b69052c8]
    ## tracemem[0x7f85b69052c8 -> 0x7f85b693de48]: copy $<-.data.table

{% highlight r %}
dt3
{% endhighlight %}

    ##                 x          y           a
    ##    1: -1.15896577 -0.2353484  0.03756247
    ##    2: -0.01390793  0.6754804 -0.26932195
    ##    3:  0.67174583  0.4768178  0.52593053
    ##    4: -0.63404027 -0.7564434 -1.77353843
    ##    5: -0.08900686  1.6690585 -1.22088857
    ##   ---                                   
    ##  996: -0.03963833  1.2541693 -1.76438842
    ##  997: -1.12119906 -0.4761572 -1.23612550
    ##  998:  0.36184986  1.3305127 -0.56491096
    ##  999:  1.33421477  0.2147001  0.86813699
    ## 1000:  0.48826897 -0.1454968  0.25290591

We can also see this by looking at our `dt` object and making sure there
isn’t a new variable called `a` in it. Turns out, there isn't. So we, in this case, did not modify by reference.

{% highlight r %}
dt
{% endhighlight %}

    ##                 x          y
    ##    1: -1.15896577 -0.2353484
    ##    2: -0.01390793  0.6754804
    ##    3:  0.67174583  0.4768178
    ##    4: -0.63404027 -0.7564434
    ##    5: -0.08900686  1.6690585
    ##   ---                       
    ##  996: -0.03963833  1.2541693
    ##  997: -1.12119906 -0.4761572
    ##  998:  0.36184986  1.3305127
    ##  999:  1.33421477  0.2147001
    ## 1000:  0.48826897 -0.1454968

So why would `data.table` want to perform this way? It is because it is
really efficient. We aren’t making copies of things every time we make
a change. This is hugely beneficial in large data sets, where RAM can
get used up with all the copies. In smaller data, this is often not a
big issue.^[Notably, the `dt3$a <- rnorm(1000)` code doesn’t change the type of
object it is—its still a data table. That means, you have the choice to
use “by reference” or “by copy”.]

The take-home message is two-fold:

1.  Modifying by reference is efficient, but can be surprising if you do not expect/understand it.
2.  `data.table` gives you the option to modify by reference or by
    making a copy.

For more information about this specific topic, run:

`vignette("datatable-reference-semantics")`

in R to see the great vignette explaining this further (and more clearly).

So what happens when we pipe?
-----------------------------

As I mentioned before, it was mind-blowing to see piping with
`data.table`. Several have commented and said this probably slows it
down a great deal. Again, Elio provided insight in this tweet:

<blockquote class="twitter-tweet" data-lang="en">
<p lang="en" dir="ltr">
A quick benchmark suggest that using pipes to chain data.table
operations doesn't add any appreciable overhead.
<a href="https://twitter.com/hashtag/rstats?src=hash&amp;ref_src=twsrc%5Etfw">\#rstats</a><a href="https://t.co/zp0ac7tymn">https://t.co/zp0ac7tymn</a>
<a href="https://t.co/pSkajjglEQ">pic.twitter.com/pSkajjglEQ</a>
</p>
— Elio Campitelli (@d\_olivaw)
<a href="https://twitter.com/d_olivaw/status/1149029823567863808?ref_src=twsrc%5Etfw">July
10, 2019</a>
</blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

This shows that regardless of the size of data, piping and chaining are very similar. 
So, nope. Piping is not a slower version of using `data.table`. Rather,
it is about using the fast features of `data.table` that will give you
the benefit, not if you pipe or chain.

To see how piping with data table ends up working, consider:

{% highlight r %}
dt[, z := rnorm(1000)] %>% 
  .[, binary_z := case_when(z > 0 ~ 1, 
                            TRUE ~ 0)] %>% 
  .[, x_y := x + y]
{% endhighlight %}

Note that the `tracemem` message didn’t show up. So what does that mean?
It modified by reference, even with the pipe. Also, we used a `dplyr`
function (`case_when()`) inside of a data table. Is that legal?! Turns
out, yes. Yes, it is. As long as the `dplyr` function works on a vector,
you can go ahead and use it in `data.table`.

So what is the point?
---------------------

The main point, here, is that `data.table` is a powerful framework for
working with data. It does some things differently, and these things are
important. If you ignore “by reference” changes, you’ll probably regret
it. But in the right situations (probably a lot of them), it is amazing
to use.

<iframe src="https://giphy.com/embed/sDjIG2QtbXKta" width="451" height="480" frameBorder="0" class="giphy-embed" allowFullScreen>
</iframe>


{% if page.comments %}
<script>
    /**
     *  RECOMMENDED CONFIGURATION VARIABLES: EDIT AND UNCOMMENT THE SECTION BELOW TO INSERT DYNAMIC VALUES FROM YOUR PLATFORM OR CMS.
     *  LEARN WHY DEFINING THESE VARIABLES IS IMPORTANT: https://disqus.com/admin/universalcode/#configuration-variables
     */
    /*
    var disqus_config = function () {
        this.page.url = page.url;  // Replace PAGE_URL with your page's canonical URL variable
        this.page.identifier = page.identifer; // Replace PAGE_IDENTIFIER with your page's unique identifier variable
    };
    */
    (function() {  // DON'T EDIT BELOW THIS LINE
        var d = document, s = d.createElement('script');
        
        s.src = '//tysonstanley.disqus.com/embed.js';
        
        s.setAttribute('data-timestamp', +new Date());
        (d.head || d.body).appendChild(s);
    })();
</script>
<noscript>
Please enable JavaScript to view the
<a href="https://disqus.com/?ref_noscript" rel="nofollow">comments
powered by Disqus.</a>
</noscript>

{% endif %}
