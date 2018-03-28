---
layout: post
title: "Using to Jamovi: Correlation and Regression"
categories: jekyll update
author: Tyson S. Barrett
comments: true
---

This post is part of a series--demonstrating the use of Jamovi--mainly because some of my students asked for it. Notably, this is using version 0.8.6.0. Today's topic is correlation and linear regression.

Note: This starts by assuming you know how to get data into Jamovi and start getting descriptive statistics.

## Correlation

Running correlation in Jamovi requires only a few steps once the data is ready to go. To start, click on the `Regression` tab and then on `Correlation Matrix`. The following screen becomes visible.

![]( {{ site.baseurl }}/assets/Jamovi/corr_01.png)

From here, we can drag all our continuous (or ordinal) variables over to the right-hand side. The table on the right (the output) will autofill as shown below.

![]( {{ site.baseurl }}/assets/Jamovi/corr_02.png)

This table gives us the Pearson's r correlation and its associated p-value. If we are looking at using another type of correlation, we can click on Spearmans or Kendall's tau-b in the middle-left of the screen. We can ask for confidence intervals, we can change the hypotheses (two-tailed or one-tailed), and we can ask for a plot that provides some important information. If we click on "Correlation matrix" below the `Plot` header, we obtain what is shown below.

![]( {{ site.baseurl }}/assets/Jamovi/corr_03.png)

This matrix plot gives us a scatterplot, density plots of the individual variables, and reports the correlation. When there are many variables, this is a viable way to report all that information concisely and transparently.

That's all I'm going to talk about with correlation as it is fairly simple compared to the next section--Linear Regression.


## Linear Regression








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

