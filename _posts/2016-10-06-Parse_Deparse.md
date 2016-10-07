---
layout: post
title: "Parse and Deparse"
categories: jekyll update
author: Tyson S. Barrett
comments: true
---

This post is entirely for note taking purposes. I wrote a function that turned out to not be all that useful, but in the process I learned a few things about `parse()` and `deparse`. It turns out these are very useful in adding flexibility to your code.

`parse(text = deparse("string"))` is the structure that I learned to use. It makes it so you can take a string (e.g., "x < 5") and turn that into an evaluated--`x < 5`--logical comparison. For example,

{% highlight r %}
parse(text = paste("x", parse(text = deparse("< 5"))))
{% endhighlight %}
```
expression(x < 5)
```

To finish this, we need to evaluate the expression with `eval`.
{% highlight r %}
thing <- parse(text = paste("x", parse(text = deparse("< 5"))))
eval(thing)
{% endhighlight %}

If `x` is a numeric vector, this will return a logical vector of where `x < 5`.

The code below is not very well developed and wasn't very useful (you actually can do everything cleaner with `%in%`, but I'm going to save it here for furture reference or if you have ideas on how to turn this operator into something useful.

{% highlight r %}
`%on%` <- function(lhs, rhs){
  match = match.call()
  lhss  = match[[2]]
  rhss  = match[[3]]
  
  .x = eval(lhss)
  .y = eval(rhss)

  if (!is.vector(.y))
    stop("The right hand side needs to be a vector.")
  
  .l1 = list()
  for (i in seq_along(.y)){
    if (grepl(">|<", .y[[i]])){
      .e = parse(text = paste(".x", parse(text = deparse(.y[[i]]))))
      .l1[[i]] = eval(.e)
    } else {
      .l1[[i]] = .x %in% .y[[i]]
    }
  }
  
  .l2 = do.call("cbind", .l1)
  .l  = apply(.l2, 1, any)
  return(.l)
  
}
{% endhighlight %}


