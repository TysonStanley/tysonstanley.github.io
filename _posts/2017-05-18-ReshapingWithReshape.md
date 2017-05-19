---
layout: post
title: "Reshaping Your Data (Long to Wide, Wide to Long)"
categories: jekyll update
author: Tyson S. Barrett
comments: true
---

I am currently teaching an Introductory R class for Health, Behavioral, Educational, and Social Scientists. As such, I created a [PDF handout]({{ site.baseurl }}/assets/images/DataCleaning_Handout.pdf) describing the base `R` function `reshape()` to help the students to better comprehend each of the arguments and how it moves the data. It is a flexible function that can change your data from wide to long format and vice versa. Other functions, including those in the `tidyverse`, are very helpful too (e.g., `gather()` and `spread()`) although I do not cover these in any depth in the handout. 

One of the great benefits of `reshape()` is that it can easily reshape the data based on several variables/measures [e.g., depression measured at time 1 (`depr1`) and time 2(`depr2`) and anxiety measured at time 1 (`anx1`) and time 2 (`anx2`)]. This is shown in the handout, from wide to long and long to wide.

A PNG copy of the handout is shown below.

![Reshaping]({{ site.baseurl }}/assets/images/DataCleaning_Handout.png)




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


