---
layout: post
title: "Reading in, Joining together, and Reshaping Multiple Files"
categories: jekyll update
author: Tyson S. Barrett
comments: true
---

It is a common problem in the social sciences where we have several disparate data files that all have information we want combined into one beautiful, complete data set. But how to do this?

Many take the manual way, with copying-and-pasting over and over again in a spreadsheet. This is tedious, error-prone, and non-replicable. Mistakes happen easily without any simple way to backtrack without starting over. Luckily, there is a better way (shocking!).

In `R`, we can pull in all the data, join them and reshape within a single reproducible script. 

# Example

For a quick example, we have 10 `.csv` files (you can have many more and of different types). Each have different variables on the same people. So in this case, we want to join these files. The code below does the trick.

{% highlight r %}
library(foreign)
library(tidyverse)

setwd("Where/Your/Data/Is/Located/")

df = list.files(pattern="*.csv") %>%
  lapply(read.csv) %>%
  Reduce(full_join, .)
{% endhighlight %}

This succinctly grabs all `.csv` files in the directory, reads them in, and uses `full_join()` to produce one beautiful `data.frame`.

Say you had data on the same variables but for different people across your files. A small tweak will do it.

{% highlight r %}
library(foreign)
library(tidyverse)

setwd("Where/Your/Data/Is/Located/")

df = list.files(pattern="*.csv") %>%
  lapply(read.csv) %>%
  do.call(rbind, .)
{% endhighlight %}

There you have it. Enjoy the simple beauty that `R` provides :) 




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


