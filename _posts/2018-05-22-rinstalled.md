---
layout: post
title: "`rinstalled` for Keeping Your Packages When Updating R"
categories: jekyll update
author: Tyson S. Barrett
comments: true
---

When we update `R` to a new version, the packages you downloaded for the previous version won't get loaded. Some code has been dispersed to take care of this, but there are so notably shortcomings to this. 

1. It doesn't work if some of the packages were not downloaded from CRAN (e.g., GitHub).
2. You need to do this *before* updating. People like me don't always think ahead when they see a new version of `R` available. 

I wrote a quick package that helps with this. It currently only works on Mac unless you tell it where the packages are downloaded (up to and including the "Versions" folder). From there, the package will do the heavy lifting for you. It helps you determine which of your packages were downloaded from CRAN and which were from another source. It also helps simplify the code.

So let's say we just updated our `R` to version `3.5.0`. Let's install devtools so we can install `rinstalled` (it isn't available on CRAN yet).

{% highlight r %}
install.packages("devtools")
devtools::install_github("tysonstanley/rinstalled")
{% endhighlight %}

From there, we load `rinstalled`, use the `installed_cran()` function that gives us the formerly installed packages and versions that are available on CRAN with the argument `updated = TRUE`. The argument tells `R` that we already updated it so it should look for the updated packages in the version right below the newest. From there, we grab the `Package` column and turn it into a character vector and assign it to `packages`. We can then give `install.packages()` the vector and it will do the rest for us.

{% highlight r %}
library(rinstalled)

packages <- installed_cran() %>%
  .$Package %>%
  as.character

install.packages(packages)
{% endhighlight %}

There is also a function to see the package-version combinations not available on CRAN. Both the `installed_cran()` and the `installed_not_cran()` provide a data.frame with a column with the package name (`Package`) and version (`Version`).

{% highlight r %}
installed_not_cran()
{% endhighlight %}

Hope this helps ease the transition to new versions of `R`!



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

