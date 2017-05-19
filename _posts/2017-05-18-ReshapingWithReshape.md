---
layout: post
title: "Reshaping Your Data (Long to Wide and Wide to Long)"
categories: jekyll update
author: Tyson S. Barrett
comments: true
---

I am currently teaching an Intro to R class for Health, Behavioral, Educational, and Social Scientists. As such, I created a [PDF handout]({{ site.baseurl }}/assets/images/DataCleaning_Handout.pdf) describing the base function `reshape()`. It is a powerful function to change your data from wide format to long format and vice versa. Other functions, including those in the `tidyverse`, are very helpful too (e.g., `gather()` and `spread()`) although I do not cover these in any depth in the handout.

![Reshape]({{ site.baseurl }}/assets/images/DataCleaning_Handout.png)




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


