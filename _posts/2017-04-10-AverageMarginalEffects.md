---
layout: post
title: "Introducing Average Marginal Effects"
categories: jekyll update
author: Tyson S. Barrett
comments: true
---

**Average Marginal Effects** (AMEs) provide a powerful framework from which to interpret generalized linear models (GLMs). However, their use is uncommon in most fields (there is some use in econometrics literature). 

Part of my dissertation work regards AMEs in their use with 2-part models. The presentation below was made for a seminar that I presented in and highlights the attributes of AMEs, especially in regards to logistic regression GLMs. The Monte Carlo simulation model that it proposed is partially done and will be finished soon. A paper presenting the method and the results of the simulation in much more depth will be appearing soon (I'll update this post and post anew once that it is the case).

<iframe src="https://docs.google.com/presentation/d/1xRZ412P6NksYolxaRifw90u0g4NTodw-ywaknNDdgJo/embed?start=false&loop=true&delayms=60000" frameborder="0" width="650" height="500" allowfullscreen="true" mozallowfullscreen="true" webkitallowfullscreen="true"></iframe>

Please feel free to post a question or a comment below. Thank you!

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


