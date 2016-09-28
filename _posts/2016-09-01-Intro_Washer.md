---
layout: post
title: "Wash Your Data"
author: "Tyson Barrett"
date: "2016-09-01"
comments: true
categories: jekyll update
---

A bit part of being a data scientist, analyst, or anything else data related, is cleaning up your data. There are several things that have to be done to get the data ready. To help you in this process, the `washer()` function in the `furniture` R package can be used to clean your data in several situations. I'll show you a few situations
where it is particularly helpful.

To install, use the following code to install from GitHub.
{% highlight r %}
library(devtools)
install_github("tysonstanley/furniture")
{% endhighlight %}

## Placeholders

If you have data that has placeholders for missingness or another value,
`washer()`. For example, in the following data.frame the x variable
contains a single missing value placeholder -- 9. The variable, y, has
two missing placeholders -- 88 and 99. The arguments for washer are:

`washer(x, ..., value=NA)`

1.  `x` is a variable. It can be numeric, factor, or character.
2.  `...` is a list of values or functions.
3.  `value` is the value that replaces the anything in `...`


{% highlight r %}
library(furniture)

df <- data.frame(x = c(1, 2, 1, 1, 9, 0, 1), 
                 y = c(5, 8, 9, 88, 99, 4, 9))
washer(df$x, 9)
{% endhighlight %}
```
## [1]  1  2  1  1 NA  0  1
```
{% highlight r %}  
washer(df$y, 88, 99)
{% endhighlight %}
```
## [1]  5  8  9 NA NA  4  9
```
## Combining Levels

Sometimes there are several small levels in a categorical variable that
you would like to combine into an "other" category. This can save a lot
of time writing a bunch of `ifelse` statements.

{% highlight r %}  
fct <- factor(c(rep(1, 30), rep(2, 20), rep(3, 5), rep(4, 2)), 
              labels = c("BigGroup", "MidGroup", "Small", "Tiny"))
washer(fct, "Small", "Tiny", value="Other")
{% endhighlight %}
```
  ##  [1] "BigGroup" "BigGroup" "BigGroup" "BigGroup" "BigGroup" "BigGroup"
  ##  [7] "BigGroup" "BigGroup" "BigGroup" "BigGroup" "BigGroup" "BigGroup"
  ## [13] "BigGroup" "BigGroup" "BigGroup" "BigGroup" "BigGroup" "BigGroup"
  ## [19] "BigGroup" "BigGroup" "BigGroup" "BigGroup" "BigGroup" "BigGroup"
  ## [25] "BigGroup" "BigGroup" "BigGroup" "BigGroup" "BigGroup" "BigGroup"
  ## [31] "MidGroup" "MidGroup" "MidGroup" "MidGroup" "MidGroup" "MidGroup"
  ## [37] "MidGroup" "MidGroup" "MidGroup" "MidGroup" "MidGroup" "MidGroup"
  ## [43] "MidGroup" "MidGroup" "MidGroup" "MidGroup" "MidGroup" "MidGroup"
  ## [49] "MidGroup" "MidGroup" "Other"    "Other"    "Other"    "Other"   
  ## [55] "Other"    "Other"    "Other"
```

Since `washer()` converts factors to character vectors, you can add a
simple `as.factor()` to retain factor status.

{% highlight r %}
as.factor(washer(fct, "Small", "Tiny", value="Other"))
{% endhighlight %}
```
  ##  [1] BigGroup BigGroup BigGroup BigGroup BigGroup BigGroup BigGroup
  ##  [8] BigGroup BigGroup BigGroup BigGroup BigGroup BigGroup BigGroup
  ## [15] BigGroup BigGroup BigGroup BigGroup BigGroup BigGroup BigGroup
  ## [22] BigGroup BigGroup BigGroup BigGroup BigGroup BigGroup BigGroup
  ## [29] BigGroup BigGroup MidGroup MidGroup MidGroup MidGroup MidGroup
  ## [36] MidGroup MidGroup MidGroup MidGroup MidGroup MidGroup MidGroup
  ## [43] MidGroup MidGroup MidGroup MidGroup MidGroup MidGroup MidGroup
  ## [50] MidGroup Other    Other    Other    Other    Other    Other   
  ## [57] Other   
  ## Levels: BigGroup MidGroup Other
```

Note that this may change the order of your factor. You can easily adjust that using:

{% highlight r %}
factor(washer(fct, "Small", "Tiny", value="Other"), 
       levels = c("MidGroup", "BigGroup", "Other"))
{% endhighlight %}
```
  ##  [1] BigGroup BigGroup BigGroup BigGroup BigGroup BigGroup BigGroup
  ##  [8] BigGroup BigGroup BigGroup BigGroup BigGroup BigGroup BigGroup
  ## [15] BigGroup BigGroup BigGroup BigGroup BigGroup BigGroup BigGroup
  ## [22] BigGroup BigGroup BigGroup BigGroup BigGroup BigGroup BigGroup
  ## [29] BigGroup BigGroup MidGroup MidGroup MidGroup MidGroup MidGroup
  ## [36] MidGroup MidGroup MidGroup MidGroup MidGroup MidGroup MidGroup
  ## [43] MidGroup MidGroup MidGroup MidGroup MidGroup MidGroup MidGroup
  ## [50] MidGroup Other    Other    Other    Other    Other    Other   
  ## [57] Other   
  ## Levels: MidGroup BigGroup Other
```

This allows you to easily combine factor levels and retain the order that you want for any graphing or other analyses.

## Conclusion

The `washer()` function allows for simple data cleaning, but providing a simple way to adjust for any placeholder values and to combine levels of a factor. If the function is useful or you have suggestions please contact me.

### Small Update

Since developing the `furniture` package, Hadley Wickham and his RStudio team released the `forcats` package which has functions for recoding and combining factors (it turns out `forcats` is an anagram of `factors`--very clever!). Although `washer()` has some overlap with some of the functions in `forcats`, it is able to work with numeric, character and factor variables making it a simple function to use in several situations. In addition, it can be used within the "tidyverse" really easily.

For example, in a fictitious data frame `df`:

{% highlight r %}
df %>% 
  mutate(fct = washer(fct, "Small", "Tiny", value="Other")) %>%
  ... more cleaning, visualizing, and modeling ...
{% endhighlight %}

See my previous posts on `table1()` and `furniture` to see `washer()` in action. Thanks for reading!


{% if page.comments %} 
<div id="disqus_thread"></div>
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
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
{% endif %}
