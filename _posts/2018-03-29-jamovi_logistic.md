---
layout: post
title: "Using Jamovi: Logistic Regression"
categories: jekyll update
author: Tyson S. Barrett
comments: true
---

This post is part of a series--demonstrating the use of Jamovi--mainly because some of my students asked for it. Notably, this is using version 0.8.6.0. Today's topic is logistic regression (with a binary outcome).

Note: This starts by assuming you know how to get data into Jamovi and start getting descriptive statistics.

## Logistic Regression

Running correlation in Jamovi requires only a few steps once the data is ready to go. To start, click on the `Regression` tab and then on `2 Outcomes` below the "Logistic Regression" minor header. The following screen becomes visible.

![]( {{ site.baseurl }}/assets/Jamovi/logreg_01.png)

In this instance, we need to have a binary outcome that we put into the "Dependent Variable" slot. As was the case in the [Linear Regression method in Jamovi](http://tysonbarrett.com//jekyll/update/2018/03/28/jamovi_correlation_regression/), the covariates are the continuous predictors and the factors are the categorical predictors.

![]( {{ site.baseurl }}/assets/Jamovi/logreg_02.png)





## Conclusions

Well, that's it for now. Leave comments or questions below!






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

