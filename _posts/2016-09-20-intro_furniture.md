---
layout: post
title:  "Introducing the Furniture R Package!"
categories: jekyll update
author: Tyson S. Barrett
comments: true
---

![Table in Forest]({{ site.baseurl }}/assets/images/table_in_forest.jpg)

# Introducing `furniture`
This R package provides "furniture" for quantitative researchers.

> Furniture is meant to be used and enjoyed. - Natalie Morales

Natalie Morales is right. Furniture is meant for our enjoyment. This package provides functions that are just like furniture--they provide something to look at but they are also there to make your life better.

I know there are over 9,000 packages on CRAN alone but there are many reasons to pay some attention. `furniture` contains functions that are particularly useful for both exploratory data analysis and publishing your results. In conjunction with the **tidy tools** that Hadley Wickham and the RStudio team have developed, `furniture` becomes a valuable tool to understand your data and communicate it.

I'll demonstrate, on data from the 2011-2012 release of the [NHANES][NHANES] data, how we can explore the relationship between demographic characteristics and dietary and other health behaviors in children and adolescents. I have provided the data [here]( {{ site.url }}/blog/assets/Data/NHANES.zip).

Before we start, you can download the package in two ways. The first, the stable version (1.0.1) on CRAN can be downloaded via:
{% highlight r %}
install.packages("furniture")
{% endhighlight %}

The second option is the developmental version (1.1.0), which can be downloaded from GitHub via:
{% highlight r %}
if (!require(devtools){
  install.packages(devtools)
}
devtools::install_github("tysonstanley/furniture")
{% endhighlight %}

## Example

Using NHANES, we are going to explore the relationship between asthma and activity level in children and adolescence. Activity level will be measured by hours spent watching TV each day and by the number of times a week the child is activity for 60 minutes during the day.

We will start by setting the working directory (wherever you downloaded the data to...) and loading some packages that will be useful for us here.

{% highlight r %}
setwd("~/the/path/tothe/directory/")    ## set it where your data are at

library(purrr)      ## map()
library(plyr)       ## join_all()
library(dplyr)      ## %>% and a bunch of other stuff
library(foreign)    ## read.xport()

{% endhighlight %}

After that, we are going to import the data. Below, I show the code using the `tidyverse` framework using the `%>%` operator. You can learn more about that using this [cheetsheat][dplyr]. There are many other resources to look into. Hadley Wickham and RStudio are the developers to look into.

{% highlight r %}
d <- list.files() %>%                   ## gets list of files in working directory
  map(read.xport) %>%                   ## reads in each .xpt file
  join_all(by="SEQN", type="full") %>%  ## joins them by their ID
  setNames(tolower(names(.))) %>%       ## variables names are now lowercase
  select(seqn, riagendr, ridageyr, mcq010, mcq365a,     ## selects variables
         paq710, paq706) %>%
  filter(ridageyr < 20)                 ## only adolescents and children 

names(d) <- c("id", "gender", "age", "asthma", "loseweight",  ## renames the variables
              "tv_hrs", "act60")  
              
{% endhighlight %}

Now we have a data frame `d` that has our variables and only contains the children and adolescents in the data. We are going to demonstrate 3 of the functions in `furniture`: 

1. `washer`
2. `table1`

First, washer takes a variable and several values and changes them to another value (the default is `NA`). Here we are replacing place holder values in the data with `NA`. 


{% highlight r %}
## Now we are going to use the new `furniture` package
library(furniture)  ## load the function

## We need to first clean the data and tidy it up
### 1. Adjust for place holders using washer()
d$act60  <- washer(d$act60, 77, 99)       ## 77 and 99 are place holders
d$tv_hrs <- washer(d$tv_hrs, 77, 99)      ## 77 and 99 are place holders
d$tv_hrs <- washer(d$tv_hrs, 8, value=0)  ## 8 meant no tv watched (changed to 0)

### 2. Adjust variable types (making factors)
d$gender <- as.factor(d$gender)
levels(d$gender) <- c("male", "female")
d$asthma <- as.factor(d$asthma)
d$loseweight <- as.factor(d$loseweight)
levels(d$asthma) <- c("Yes", "No", "Other")
levels(d$loseweight) <- c("Yes", "No")
d$asthma <- as.factor(washer(d$asthma, "Other"))  ## Fixes the Other category to NA

{% endhighlight %}

Second, we are showing `table1`. This is a powerful function that takes a data frame and creates a table of descriptive statistics. We gave it 4 variables to get descriptives on, stratified by our asthma variable. We also set the `test = TRUE`, providing bivariate tests of significance. This is a great function to use to get an early idea of relationships in the data. I recommend doing this early on to get a good idea of how the data look. (In fact, I recommend doing exploratory data analysis early in any project. This can be done using `ggplot2` package for visualization and by using `table1()`.)

We also model the data using a poisson distribution and a log link (our outcomes are counts so this type of model generally fits the data very well). We get the average marginal effects (based on the derivative) and then we adjusted the reported average marginal effect to reflect values in minutes instead of hours.

{% highlight r %}
### 3. Check descriptives using table1()
table1(d, act60, tv_hrs, gender, age, 
       splitby = ~asthma, 
       test = TRUE)
{% endhighlight %}

```
                        No          Yes              Test P-Value
 Observations         3160          638                          
        act60                               T-Test: -0.97    0.33
                 6.2 (1.7)  6.29 (1.58)                          
       tv_hrs                               T-Test: -2.56   0.011
               2.04 (1.48)  2.22 (1.55)                          
       gender                           Chi Square: 14.91    0.00
         male 1550 (49.1%)  367 (57.5%)                          
       female 1610 (50.9%)  271 (42.5%)                          
          age                               T-Test: -6.73    0.00
               8.75 (5.39) 10.28 (5.21)                          
```



I hope this demonstrated to a small degree, the benefits the `furniture` package offers. I will certainly post on more in depth uses of each of the functions in `furniture` (e.g., the many ways to use the `table1` function and use it to produce a publish-ready table). 

To review:

1. There is a simple data cleaning tool in `furniture` (i.e., `washer`).
2. There is a great exploratory data analysis and communicating tool in `table1`. It provides a simple function to get important information about means and counts of the variables of interest and an understanding of the the relationships in the data. Further, it is well formatted for easy reporting, potentially in a publishable report.

If you have suggestions, or find a bug, please comment below or email me: <t.barrett@aggiemail.usu.edu>.

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

[NHANES]: http://wwwn.cdc.gov/nchs/nhanes/search/nhanes11_12.aspx
[dplyr]: {{ site.url}}/assets/images/dplyr.pdf
