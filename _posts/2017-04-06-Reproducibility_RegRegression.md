---
layout: post
title: "Reproducibility and Regularized Regression"
categories: jekyll update
author: Tyson S. Barrett
comments: true
---

Below is a Prezi presentation I have prepared for a presentation I am doing on **Reproducibility and Regularized Regression**. It briefly presents a step by step on how to use regularized regression (specifically elastic net) to explore predictors of marijuana use among adolescents with asthma. The data set, after selecting the variables that could be important, had p = 78 variables. 

It does not provide code on actually performing it. For that, I am going to post another time with the code and the reasoning behind each step.

<iframe id="iframe_container" frameborder="0" webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen="" width="600" height="400" src="https://prezi.com/embed/jjw8kev_00qk/?bgcolor=ffffff&amp;lock_to_path=1&amp;autoplay=0&amp;autohide_ctrls=0&amp;landing_data=bHVZZmNaNDBIWnNjdEVENDRhZDFNZGNIUE43MHdLNWpsdFJLb2ZHanI0am1TWHIwR0RnL09jSVkzVEx0OEVtakFnPT0&amp;landing_sign=i8yXOpqg1v3U0Si_kylHELbHCAb31NVPpqIN204PjvM"></iframe>

Thanks for following! And feel free to comment below.


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


