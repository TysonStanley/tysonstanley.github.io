---
layout: post
title: "Reading In and Joining Together Multiple Files in a Single Step"
categories: jekyll update
author: Tyson S. Barrett
comments: true
---

It is a common problem in the social sciences where we have several disparate data files that all have information we want combined into one beautiful, complete data set. But how to do this?

Many take the manual way, with copying-and-pasting over and over again in a spreadsheet. This is tedious, error-prone, and non-replicable. Mistakes happen easily without any simple way to backtrack without starting over. Luckily, there is a better way (shocking!).

In `R`, we can pull in all the data, join them and reshape within a single reproducible script. 

## Example 1

For a quick example, we have 10 `.csv` files (you can have many more and of different types). Each have different variables on the same people. So in this case, we want to join these files. The code below does the trick.

{% highlight r %}
library(tidyverse)

setwd("Where/Your/Data/Is/Located/")

df = list.files(pattern="*.csv") %>%
  lapply(read.csv) %>%
  Reduce(full_join, .)
{% endhighlight %}

This succinctly grabs all `.csv` files in the directory (`list.files(pattern="*.csv")` finds all file names that have `.csv` in the name), reads them in (`lapply(read.csv)` repeatedly applies the `read.csv()` to each file), and uses `Reduce()` to apply `full_join()` to each file that was read in to produce one beautiful `data.frame`.

With a few lines of code, we have combined any number of files together into one `data.frame`.

## Example 2

Say you had data on the same variables (e.g., ID, demographics, outcome measures) but for different people across your files. If this is the case, a small tweak will do it. Namely, we use `do.call(rbind, .)` to "row bind" each of the files together. In other words, we glue each file to the bottom of the other.

{% highlight r %}
library(tidyverse)

setwd("Where/Your/Data/Is/Located/")

df = list.files(pattern="*.csv") %>%
  lapply(read.csv) %>%
  do.call(rbind, .)
{% endhighlight %}

Again, we have a single `data.frame` containing all the data from all of the `.csv` files in the working directory.

## Example 3

Finally, I wanted to highlight that we can clean the data within this step as well.

{% highlight r %}
library(tidyverse)

setwd("Where/Your/Data/Is/Located/")

df = list.files(pattern="*.csv") %>%
  lapply(read.csv) %>%
  do.call(rbind, .) %>%
  select(ID, var1, var2, var3) %>%
  reshape(varying = list(c("var1", "var2", "var3")),
          v.names = c("var"),
          direction = "long",
          timevar = "Time")
{% endhighlight %}

We selected variables and then reshaped the data into long form (see [my previous post]({{ site.baseurl }}//jekyll/update/2017/05/18/ReshapingWithReshape) on reshaping) all while reading in and combining the individual files.

## R Does It Again

There you have it. Enjoy the simple beauty that `R` provides and let me know if you have any questions :) 




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


