---
layout: post
title: "Simple Table 1 in R"
author: Tyson S. Barrett
comments: true
categories: jekyll update
---

This has been updated to work with the most recent version of the `furniture` package.

---------


As a follow up to my first post introducing the `furniture` package, I
wanted to show a much more in depth demonstration of `table1`'s
capabilities and ease of use. It is the star function of the package, afterall. To prep the data, I will also use another important function in the package--`washer()`--that allows easy cleaning of variables.

Similarly to my post on `furniture` we will use NHANES (see [my post
here][furniture]). I have provided the data
[here]( {{ site.baseurl }}/assets/Data/NHANES.zip). We will
ask a different question relating to adolescent and early adulthood
depression as it relates to chronic illness (specifically asthma for
this post).

{% highlight r %}
setwd("~/the/path/tothe/directory/")    ## set it where your data is at

library(plyr)       ## join_all
library(dplyr)      ## a bunch of functions
library(purrr)      ## map
library(foreign)    ## read.xport()
library(furniture)  ## table1 and washer
{% endhighlight %}

{% highlight r %}
d <- list.files()[1:4] %>%                   ## gets list of files in working directory
  map(read.xport) %>%                   ## reads in each .xpt file
  join_all(by="SEQN", type="full") %>%  ## joins them by their ID
  setNames(tolower(names(.))) %>%       ## variables names are now lowercase
  select(seqn, riagendr, ridageyr, mcq010, mcq365a,     ## selects variables
         paq710, paq706, dpq010, dpq020, dpq030,
         dpq040, dpq050, dpq060, dpq070, dpq080,
         dpq090, dpq100) %>%
  filter(ridageyr < 30)                 ## only young adults and children 
  
names(d) <- c("id", "gender", "age", "asthma", "loseweight",  ## renames the variables
              "tv_hrs", "act60", paste0("dep", 1:10))  

## This is a simple function to apply to the data
##    If the max is 9 then 7 and 9 are placeholders for NA
##    If the max is 99 then 77 and 99 are placeholders
type1 = function(x){
  if (max(x, na.rm=TRUE) == 9){
    x = washer(x, 7, 9)
  } else if (max(x, na.rm=TRUE) == 99){
    x = washer(x, 77, 99)
  } else {
    x = x
  }
}

d <- dmap(d, type1)

## If TV is 8 then that meant no hours watched, changed to 0
d$tv_hrs <- washer(d$tv_hrs, 8, value=0)
{% endhighlight %}


Table 1 Can Explore
-------------------

The first thing that `table1()` can add to your data life is that it can
help with exploratory data analysis. It can inform of relationships,
missing patterns, and much more.

{% highlight r %}
## Explore with Table 1
table1(d, dep1, dep2, dep3, dep4, dep5, dep6, dep7, dep8, dep9, dep10, 
       splitby = ~asthma, test = TRUE)
{% endhighlight %}
```
  ##                         1           2          Test P-Value
  ##  Observations         830        3962                      
  ##          dep1                          T-Test: 0.85   0.396
  ##                0.37 (0.7) 0.33 (0.66)                      
  ##          dep2                           T-Test: 0.4   0.689
  ##               0.31 (0.64) 0.29 (0.61)                      
  ##          dep3                          T-Test: 1.51   0.132
  ##               0.68 (0.93) 0.58 (0.86)                      
  ##          dep4                          T-Test: 1.82   0.069
  ##               0.76 (0.88) 0.65 (0.77)                      
  ##          dep5                          T-Test: 0.68   0.495
  ##               0.44 (0.78)  0.4 (0.78)                      
  ##          dep6                           T-Test: 1.3   0.196
  ##                0.3 (0.73)  0.24 (0.6)                      
  ##          dep7                          T-Test: 0.83    0.41
  ##                0.3 (0.71) 0.25 (0.62)                      
  ##          dep8                         T-Test: -0.07   0.948
  ##                0.18 (0.6) 0.18 (0.54)                      
  ##          dep9                          T-Test: 0.56   0.577
  ##               0.06 (0.27) 0.05 (0.26)                      
  ##         dep10                          T-Test: 0.56   0.578
  ##               0.32 (0.56) 0.29 (0.52)
```

{% highlight r %}
table1(d, dep1, dep2, dep3, dep4, dep5, dep6, dep7, dep8, dep9, dep10, 
       splitby = ~loseweight, test = TRUE)
{% endhighlight %}
```
  ##                         1           2          Test P-Value
  ##  Observations         220        1388                      
  ##          dep1                          T-Test: 0.94   0.347
  ##               0.39 (0.76) 0.33 (0.65)                      
  ##          dep2                           T-Test: 1.8   0.073
  ##               0.39 (0.71) 0.28 (0.59)                      
  ##          dep3                          T-Test: 2.23   0.027
  ##                  0.76 (1) 0.57 (0.85)                      
  ##          dep4                          T-Test: 2.42   0.016
  ##               0.82 (0.84) 0.65 (0.79)                      
  ##          dep5                          T-Test: 4.64       0
  ##                  0.74 (1) 0.35 (0.73)                      
  ##          dep6                          T-Test: 2.34    0.02
  ##               0.38 (0.77)  0.23 (0.6)                      
  ##          dep7                          T-Test: 2.08   0.039
  ##               0.37 (0.74) 0.24 (0.62)                      
  ##          dep8                          T-Test: 1.57   0.119
  ##               0.26 (0.71) 0.17 (0.52)                      
  ##          dep9                         T-Test: -0.17   0.868
  ##               0.04 (0.28) 0.05 (0.26)                      
  ##         dep10                          T-Test: 1.38    0.17
  ##               0.36 (0.62) 0.28 (0.51)
```

We quickly see that asthma does not appear to be related much to these
depression items in this sample; however, that is not true for the
"loseweight" variable. This variable consisted of a question asking the
individual if a doctor had ever suggested that he/she needed to lose
weight. This variable appears to be related to 5 or 6 of the 10
depression items. Specifically, the 10 items are:

1.  `dep1` is "Have little interest in doing things"
2.  `dep2` is "Feeling down, depressed, or hopeless"
3.  `dep3` is "Trouble sleeping or sleeping too much"
4.  `dep4` is "Feeling tired or having little energy"
5.  `dep5` is "Poor appetite or overeating"
6.  `dep6` is "Feeling bad about yourself"
7.  `dep7` is "Trouble concentrating on things"
8.  `dep8` is "Moving or speaking too slowly or too fast"
9.  `dep9` is "Thought you would be better off dead"
10. `dep10` is "Difficulty these problems have caused"

So here, "loseweight" is related to "Poor appetite or overeating,"
"Feeling bad about yourself," and "High Difficulty from these problems."

So now we can explore more aspects about these relationships. Maybe,
instead of means and SD's, we want counts. `table1()` gives you counts
when the variable is a factor.

{% highlight r %}
## Explore More
for (i in depvars){
  d[, i] = as.factor(d[, i])
}

table1(d, dep1, dep2, dep3, dep4, dep5, dep6, dep7, dep8, dep9, dep10, 
       splitby = ~loseweight, test = TRUE)
{% endhighlight %}

```
  ##                         1           2              Test P-Value
  ##  Observations         220        1388                          
  ##          dep1                         Chi Square: 10.66   0.014
  ##             0 115 (72.8%) 736 (75.7%)                          
  ##             1  33 (20.9%) 173 (17.8%)                          
  ##             2    2 (1.3%)   45 (4.6%)                          
  ##             3    8 (5.1%)   18 (1.9%)                          
  ##          dep2                          Chi Square: 4.93   0.177
  ##             0 113 (71.5%) 762 (78.3%)                          
  ##             1  34 (21.5%)   165 (17%)                          
  ##             2    6 (3.8%)   32 (3.3%)                          
  ##             3    5 (3.2%)   14 (1.4%)                          
  ##          dep3                         Chi Square: 22.42       0
  ##             0  82 (51.9%) 597 (61.3%)                          
  ##             1  52 (32.9%) 248 (25.5%)                          
  ##             2    4 (2.5%)     78 (8%)                          
  ##             3  20 (12.7%)   51 (5.2%)                          
  ##          dep4                          Chi Square: 7.74   0.052
  ##             0  62 (39.2%) 493 (50.7%)                          
  ##             1  72 (45.6%) 367 (37.7%)                          
  ##             2   14 (8.9%)   74 (7.6%)                          
  ##             3   10 (6.3%)     39 (4%)                          
  ##          dep5                         Chi Square: 33.78       0
  ##             0  88 (55.7%) 739 (75.9%)                          
  ##             1  40 (25.3%) 160 (16.4%)                          
  ##             2   13 (8.2%)   40 (4.1%)                          
  ##             3  17 (10.8%)   35 (3.6%)                          
  ##          dep6                         Chi Square: 10.48   0.015
  ##             0 118 (74.7%)   817 (84%)                          
  ##             1  28 (17.7%) 110 (11.3%)                          
  ##             2    4 (2.5%)   25 (2.6%)                          
  ##             3    8 (5.1%)   21 (2.2%)                          
  ##          dep7                          Chi Square: 6.85   0.077
  ##             0 118 (74.7%) 810 (83.2%)                          
  ##             1  27 (17.1%) 113 (11.6%)                          
  ##             2    7 (4.4%)   26 (2.7%)                          
  ##             3    6 (3.8%)   24 (2.5%)                          
  ##          dep8                          Chi Square: 4.91   0.179
  ##             0 134 (84.8%) 857 (88.1%)                          
  ##             1   14 (8.9%)   87 (8.9%)                          
  ##             2    3 (1.9%)   11 (1.1%)                          
  ##             3    7 (4.4%)   18 (1.8%)                          
  ##          dep9                          Chi Square: 1.94   0.584
  ##             0 153 (96.8%) 935 (96.1%)                          
  ##             1    4 (2.5%)   31 (3.2%)                          
  ##             2      0 (0%)    5 (0.5%)                          
  ##             3    1 (0.6%)    2 (0.2%)                          
  ##         dep10                          Chi Square: 3.41   0.332
  ##             0  84 (69.4%) 492 (74.4%)                          
  ##             1  32 (26.4%) 155 (23.4%)                          
  ##             2    3 (2.5%)   11 (1.7%)                          
  ##             3    2 (1.7%)    3 (0.5%)
```

Since the values in the depression scale are much more categorical
(factors), this is much more informative. Here, we also have `dep1`,
`dep4` and possibly `dep7` but no longer `dep10`. This suggests that
"loseweight" is associated with "Having little interest in doing
things," "Feeling tired or having little energy" as well as "Poor
appetite or overeating" and "Feeling bad about yourself."

You can keep the missingness in the counts to better understand the
distribution of missing.
{% highlight r %}
    table1(d, dep1, dep2, dep3, dep4, dep5, dep6, dep7, dep8, dep9, dep10, 
       splitby = ~loseweight, test = TRUE, NAkeep = TRUE)
{% endhighlight %}
```
  ##                         1           2              Test P-Value
  ##  Observations         220        1388                          
  ##          dep1                         Chi Square: 10.66   0.014
  ##             0 115 (52.3%)   736 (53%)                          
  ##             1    33 (15%) 173 (12.5%)                          
  ##             2    2 (0.9%)   45 (3.2%)                          
  ##             3    8 (3.6%)   18 (1.3%)                          
  ##       Missing  62 (28.2%)   416 (30%)                          
  ##          dep2                          Chi Square: 4.93   0.177
  ##             0 113 (51.4%) 762 (54.9%)                          
  ##             1  34 (15.5%) 165 (11.9%)                          
  ##             2    6 (2.7%)   32 (2.3%)                          
  ##             3    5 (2.3%)     14 (1%)                          
  ##       Missing  62 (28.2%) 415 (29.9%)                          
  ##          dep3                         Chi Square: 22.42       0
  ##             0  82 (37.3%)   597 (43%)                          
  ##             1  52 (23.6%) 248 (17.9%)                          
  ##             2    4 (1.8%)   78 (5.6%)                          
  ##             3   20 (9.1%)   51 (3.7%)                          
  ##       Missing  62 (28.2%) 414 (29.8%)                          
    ..... (output truncated)
```
Using just this one function, we have learned a lot about a handful of
relationships. In conjunction with other summary and exploratory
analysis functions, `table1()` can add to your ability to spot trends
and patterns quickly.

Table 1 Can Communicate
-----------------------

This is probably the best attribute of `table1()`. The output of the
function was formatted to produce a table just like many academic "Table
1" tables in peer-reviewed journals. It makes the process of building
the table much simpler--in fact, I'd say it makes it almost too easy.
Just kidding, that's not really a thing when it comes to creating a
table for a paper. Anything that makes it take less time and have fewer
errors must be a good thing.

Once the data is cleaned, exclusions are made, and the questions of
interest are established, `table1()` can help make a well-formatted,
easily exportable, simply reproducible table. Here, we'll assume we've
cleaned it and are now ready to report relationships. Note, you may get a warning about the \chi^2 approximation. This is due to low cell counts.

{% highlight r %}
  ## Communicate
table1(d, gender, age, dep1, dep4, dep5, dep6,  
       splitby = ~loseweight, 
       test = TRUE, 
       output = "stars",
       splitby_labels = c("Loseweight", "No Loseweight"),
       var_names = c("Gender", "Age", "Little Interest", "Tired", "Appetite", "Feel Bad"))
{% endhighlight %}

```

  ##                   Loseweight No Loseweight    
  ##     Observations         220          1388    
  ##           Gender                           ***
  ##                  1.61 (0.49)    1.47 (0.5)    
  ##              Age                              
  ##                  21.78 (4.2)  21.67 (4.07)    
  ##  Little Interest                             *
  ##                0 115 (72.8%)   736 (75.7%)    
  ##                1  33 (20.9%)   173 (17.8%)    
  ##                2    2 (1.3%)     45 (4.6%)    
  ##                3    8 (5.1%)     18 (1.9%)    
  ##            Tired                              
  ##                0  62 (39.2%)   493 (50.7%)    
  ##                1  72 (45.6%)   367 (37.7%)    
  ##                2   14 (8.9%)     74 (7.6%)    
  ##                3   10 (6.3%)       39 (4%)    
  ##         Appetite                           ***
  ##                0  88 (55.7%)   739 (75.9%)    
  ##                1  40 (25.3%)   160 (16.4%)    
  ##                2   13 (8.2%)     40 (4.1%)    
  ##                3  17 (10.8%)     35 (3.6%)    
  ##         Feel Bad                             *
  ##                0 118 (74.7%)     817 (84%)    
  ##                1  28 (17.7%)   110 (11.3%)    
  ##                2    4 (2.5%)     25 (2.6%)    
  ##                3    8 (5.1%)     21 (2.2%)
```

We were able to print just stars (many journals like this) and we can
adjust the labels both on the stratifying variable (`splitby_labels`)
and the variables (`var.names`).

Table 1 Can Pipe
----------------

Finally, with the popularity of piping (`%>%` operator found in `dplyr`
and `magrittr`), we've built in a feature to add `table1()` to a
pipeline. It prints the table while not changing the data object so it
can continue in the piping.

{% highlight r %}
  d %>%
    table1(gender, age, dep1, dep4, dep5, dep6, 
           splitby = ~loseweight, 
           test = TRUE, 
           output = "stars",
           splitby_labels = c("Loseweight", "No Loseweight"),
           var.names = c("Gender", "Age", "Little Interest", "Tired", "Appetite", "Feel Bad")) %>%
    filter(age > 20 & age < 50) %>%
    table1(gender, age, dep1, dep4, dep5, dep6, 
           splitby = ~loseweight, 
           test = TRUE, 
           output = "stars",
           splitby_labels = c("Loseweight", "No Loseweight"),
           var_names = c("Gender", "Age", "Little Interest", "Tired", "Appetite", "Feel Bad"))
{% endhighlight %}
```
    ##                   Loseweight No Loseweight    
    ##     Observations         220          1388    
    ##           Gender                           ***
    ##                  1.61 (0.49)    1.47 (0.5)    
    ##              Age                              
    ##                  21.78 (4.2)  21.67 (4.07)    
    ##  Little Interest                             *
    ##                0 115 (72.8%)   736 (75.7%)    
    ##                1  33 (20.9%)   173 (17.8%)    
    ##                2    2 (1.3%)     45 (4.6%)    
    ##                3    8 (5.1%)     18 (1.9%)    
    ##            Tired                              
    ##                0  62 (39.2%)   493 (50.7%)    
    ##                1  72 (45.6%)   367 (37.7%)    
    ##                2   14 (8.9%)     74 (7.6%)    
    ##                3   10 (6.3%)       39 (4%)    
    ##         Appetite                           ***
    ##                0  88 (55.7%)   739 (75.9%)    
    ##                1  40 (25.3%)   160 (16.4%)    
    ##                2   13 (8.2%)     40 (4.1%)    
    ##                3  17 (10.8%)     35 (3.6%)    
    ##         Feel Bad                             *
    ##                0 118 (74.7%)     817 (84%)    
    ##                1  28 (17.7%)   110 (11.3%)    
    ##                2    4 (2.5%)     25 (2.6%)    
    ##                3    8 (5.1%)     21 (2.2%)


    ##                   Loseweight No Loseweight    
    ##     Observations         118           760    
    ##           Gender                            **
    ##                  1.62 (0.49)    1.47 (0.5)    
    ##              Age                              
    ##                  25.1 (2.66)   24.8 (2.62)    
    ##  Little Interest                             *
    ##                0  72 (72.7%)   506 (78.3%)    
    ##                1  19 (19.2%)   104 (16.1%)    
    ##                2      2 (2%)       26 (4%)    
    ##                3    6 (6.1%)     10 (1.5%)    
      ..... (output truncated)
```

This example isn't incredibly useful, but hopefully it illustrates that
it can flow easily within a pipe.

Stratify by Two or More Variables
---------------------------------

It is possible to stratify by two or more variables as well. This can be done via:

{% highlight r %}
  table1(d,
         gender, age, dep1, dep4, dep5, dep6, 
         splitby = ~interaction(loseweight, asthma), 
           test = TRUE, 
           var.names = c("Gender", "Age", "Little Interest", "Tired", "Appetite", "Feel Bad"))
{% endhighlight %}


Conclusion
----------

I hope this helped demonstrate the utility of the function. Let me know
if you'd like additional features or if you have found it useful in your work.


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

[furniture]: {{site.url}}/blog/jekyll/update/2016/08/23/intro_furniture.html

