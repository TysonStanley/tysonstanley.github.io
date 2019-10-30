---
layout: post
title: "Guest Post: <i>Interpreting Interactions in Multilevel Models</i>"
categories: jekyll update
author: Tyson S. Barrett
comments: true
---

This is a guest post by Jeremy Haynes, a doctoral student at Utah State University.

## Contents

-   [Fitting Model and Specifying Simple Intercepts and Simple
    Slopes](#fitting-model-and-specifying-simple-intercepts-and-simple-slopes)
-   [Methods of Probing Interactions (Preacher et
    al., 2006)](#methods-of-probing-interactions-preacher-et-al.-2006)
    -   [Simple Slopes Technique](#simple-slopes-technique)
    -   [Johnson-Neyman Technique](#johnson-neyman-technique)

Fitting Model and Specifying Simple Intercepts and Simple Slopes
================================================================

<table cellspacing="0" align="center" style="border: none;">
<caption align="bottom" style="margin-top:0.3em;">
Statistical models
</caption>
<tr>
<th style="text-align: left; border-top: 2px solid black; border-bottom: 1px solid black; padding-right: 12px;">
<b></b>
</th>
<th style="text-align: left; border-top: 2px solid black; border-bottom: 1px solid black; padding-right: 12px;">
<b>Model 1</b>
</th>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">
(Intercept)
</td>
<td style="padding-right: 12px; border: none;">
-1.21<sup style="vertical-align: 0px;">\*\*\*</sup>
</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">
</td>
<td style="padding-right: 12px; border: none;">
(0.27)
</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">
sexgirl
</td>
<td style="padding-right: 12px; border: none;">
1.24<sup style="vertical-align: 0px;">\*\*\*</sup>
</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">
</td>
<td style="padding-right: 12px; border: none;">
(0.04)
</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">
extrav
</td>
<td style="padding-right: 12px; border: none;">
0.80<sup style="vertical-align: 0px;">\*\*\*</sup>
</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">
</td>
<td style="padding-right: 12px; border: none;">
(0.04)
</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">
texp
</td>
<td style="padding-right: 12px; border: none;">
0.23<sup style="vertical-align: 0px;">\*\*\*</sup>
</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">
</td>
<td style="padding-right: 12px; border: none;">
(0.02)
</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">
extrav:texp
</td>
<td style="padding-right: 12px; border: none;">
-0.02<sup style="vertical-align: 0px;">\*\*\*</sup>
</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">
</td>
<td style="padding-right: 12px; border: none;">
(0.00)
</td>
</tr>
<tr>
<td style="border-top: 1px solid black;">
AIC
</td>
<td style="border-top: 1px solid black;">
4798.45
</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">
BIC
</td>
<td style="padding-right: 12px; border: none;">
4848.86
</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">
Log Likelihood
</td>
<td style="padding-right: 12px; border: none;">
-2390.23
</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">
Num. obs.
</td>
<td style="padding-right: 12px; border: none;">
2000
</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">
Num. groups: class
</td>
<td style="padding-right: 12px; border: none;">
100
</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">
Var: class (Intercept)
</td>
<td style="padding-right: 12px; border: none;">
0.48
</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">
Var: class extrav
</td>
<td style="padding-right: 12px; border: none;">
0.01
</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;">
Cov: class (Intercept) extrav
</td>
<td style="padding-right: 12px; border: none;">
-0.03
</td>
</tr>
<tr>
<td style="border-bottom: 2px solid black;">
Var: Residual
</td>
<td style="border-bottom: 2px solid black;">
0.55
</td>
</tr>
<tr>
<td style="padding-right: 12px; border: none;" colspan="3">
<span
style="font-size:0.8em"><sup style="vertical-align: 0px;">***</sup>p
&lt; 0.001, <sup style="vertical-align: 0px;">**</sup>p &lt; 0.01,
<sup style="vertical-align: 0px;">*</sup>p &lt; 0.05</span>
</td>
</tr>
</table>
<br>

1.  Write out model equation
    *y*<sub>*i**j*</sub> = *γ*<sub>00</sub> + *γ*<sub>10</sub>*X*<sub>*i**j*</sub> + *γ*<sub>20</sub>*X*<sub>*i**j*</sub> + *γ*<sub>01</sub>*Z*<sub>*j*</sub> + *γ*<sub>21</sub>*X*<sub>*i**j*</sub>*Z*<sub>*j*</sub> + *μ*<sub>0*j*</sub> + *μ*<sub>2*j*</sub> + *e*<sub>*i**j*</sub>
     <br>

2.  Separate fixed effects from random effects
    *y*<sub>*i**j*</sub> = (*γ*<sub>00</sub> + *γ*<sub>10</sub>*X*<sub>*i**j*</sub> + *γ*<sub>20</sub>*X*<sub>*i**j*</sub> + *γ*<sub>01</sub>*Z*<sub>*j*</sub> + *γ*<sub>21</sub>*X*<sub>*i**j*</sub>*Z*<sub>*j*</sub>) + (*μ*<sub>0*j*</sub> + *μ*<sub>2*j*</sub> + *e*<sub>*i**j*</sub>)
     <br>

3.  Derive prediction equation
    *E*\[*y*|*X*, *Z*\] = *γ̂*<sub>00</sub> + *γ̂*<sub>10</sub>*X*<sub>*i**j*</sub> + *γ̂*<sub>20</sub>*X*<sub>*i**j*</sub> + *γ̂*<sub>01</sub>*Z*<sub>*j*</sub> + *γ̂*<sub>21</sub>*X*<sub>*i**j*</sub>*Z*<sub>*j*</sub>
     <br>

4.  Separate simple intercept from simple slope - this indirectly
    defines the focal predictor and moderator
    *E*\[*y*|*X*, *Z*\] = (*γ̂*<sub>00</sub> + *γ̂*<sub>10</sub>*X*<sub>*i**j*</sub> + *γ̂*<sub>20</sub>*X*<sub>*i**j*</sub>) + (*γ̂*<sub>01</sub>*Z*<sub>*j*</sub> + *γ̂*<sub>21</sub>*X*<sub>*i**j*</sub>*Z*<sub>*j*</sub>)
     <br>

5.  Formally define focal predictor (Level 2: Z) and moderator (Level 1:
    X)
    *E*\[*y*|*X*, *Z*\] = (*γ̂*<sub>00</sub> + *γ̂*<sub>10</sub>*X*<sub>*i**j*</sub> + *γ̂*<sub>20</sub>*X*<sub>*i**j*</sub>) + (*γ̂*<sub>01</sub> + *γ̂*<sub>21</sub>*X*<sub>*i**j*</sub>)*Z*<sub>*j*</sub>
     <br>

6.  Define simple intercept (*ω*<sub>0</sub>) and simple slope
    (*ω*<sub>1</sub>)
    *ω*<sub>0</sub> = *γ̂*<sub>00</sub> + *γ̂*<sub>10</sub>*X*<sub>*i**j*</sub> + *γ̂*<sub>20</sub>*X*<sub>*i**j*</sub>

*ω*<sub>1</sub> = *γ̂*<sub>01</sub> + *γ̂*<sub>21</sub>*X*<sub>*i**j*</sub>
 <br>



Methods of Probing Interactions (Preacher et al., 2006)
=======================================================

Simple Slopes Technique
-----------------------

1.  Specify conditional values of X (EXT) to evaluate significance for
    simple slope of y regressed on Z (TEXP)  

-   For continuous variables, this requires the “pick-a-point” method
    (Rogosa, 1980)  
-   First, I get some descriptives and will use the mean, +1 SD, and -1
    SD (Cohen & Cohen, 1983)  
-   Values of 3.953, 5.215, and 6.477 for *X*

*ω*<sub>1</sub> = *γ̂*<sub>01</sub> + *γ̂*<sub>21</sub>*X*<sub>*i**j*</sub>

<table style="text-align:center"><caption><strong>Descriptive statistics, aggregate over entire sample</strong></caption>
<tr><td colspan="8" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Statistic</td><td>N</td><td>Mean</td><td>St. Dev.</td><td>Min</td><td>Pctl(25)</td><td>Pctl(75)</td><td>Max</td></tr>
<tr><td colspan="8" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">extrav</td><td>2,000</td><td>5.215</td><td>1.262</td><td>1</td><td>4</td><td>6</td><td>10</td></tr>
<tr><td colspan="8" style="border-bottom: 1px solid black"></td></tr></table>


{% highlight r %}
low = mean(popularity$extrav, na.rm = FALSE) - sd(popularity$extrav, na.rm = FALSE)
mid = mean(popularity$extrav, na.rm = FALSE)
upp = mean(popularity$extrav, na.rm = FALSE) + sd(popularity$extrav, na.rm = FALSE)

modelSum = summary(model)
omegaLow = modelSum$coefficients[3] + modelSum$coefficients[5] * low
omegaMid = modelSum$coefficients[3] + modelSum$coefficients[5] * mid
omegaUpp = modelSum$coefficients[3] + modelSum$coefficients[5] * upp
{% endhighlight %}


1.  Calculate standard error of *ω̂*<sub>1</sub>

-   Variance of *ω̂*<sub>1</sub>

*v**a**r*(*ω̂*<sub>1</sub>|*z*) = *v**a**r*(*γ̂*<sub>01</sub>) + 2*X**c**o**v*(*γ̂*<sub>01</sub>, *γ̂*<sub>21</sub>) + *X*<sup>2</sup>*v**a**r*(*γ̂*<sub>21</sub>)

-   Covariance matrix

<!-- -->

{% highlight r %}
vcov(model)
{% endhighlight %}

    ## 5 x 5 Matrix of class "dpoMatrix"
    ##               (Intercept)       sexgirl        extrav          texp   extrav:texp
    ## (Intercept)  7.392993e-02  1.764158e-05 -9.462046e-03 -4.187639e-03  5.370955e-04
    ## sexgirl      1.764158e-05  1.312796e-03 -9.458320e-05 -2.852607e-05  3.075874e-06
    ## extrav      -9.462046e-03 -9.458320e-05  1.609389e-03  5.400536e-04 -9.232641e-05
    ## texp        -4.187639e-03 -2.852607e-05  5.400536e-04  2.824846e-04 -3.686219e-05
    ## extrav:texp  5.370955e-04  3.075874e-06 -9.232641e-05 -3.686219e-05  6.526482e-06

-   Calculate SE of *ω̂*<sub>1</sub> for each value of X

<!-- ############################################################################################## -->
1.  Form critical ratios for each value of X

$$t = \\frac{\\hat\\omega\_1 - 0}{SE\_{\\hat\\omega\_1}}$$

<!-- ############################################################################################## -->
1.  Calculate *d**f* and critical *t*-values

-   Degrees of freedom = *N* − *p* − 1

-   Critical *t*-values

<!-- ############################################################################################## -->
1.  Determine significance

-   If any of the *t*-values are above or below  ± *t*-crit,
    respectively, then the simple slope of the focal predictor (Z) is
    significant at that conditional value of X

<!-- -->
{% highlight r %}
paste("t-crit:", tCrit)
paste("t-value for lower conditional value:", tLow)
paste("t-value for middle conditional value:", tMid)
paste("t-value for upper conditional value:", tUpp)
{% endhighlight %}

    ## [1] "t-crit: -1.96116040314397" "t-crit: 1.96116040314397"
    ## [1] "t-value for lower conditional value: 22.5300221770147"
    ## [1] "t-value for middle conditional value: 23.5026768695656"
    ## [1] "t-value for upper conditional value: 24.5447253519584"


1.  Plot that S\*\*t

-   Calculating predicted values

<!-- -->

{% highlight r %}
simpleData = bind_rows(
    data.frame(texp = c(0:25)) %>% mutate(extrav = 5.215 - 1.262),
    data.frame(texp = c(0:25)) %>% mutate(extrav = 5.215),
    data.frame(texp = c(0:25)) %>% mutate(extrav = 5.215 + 1.262)) %>% 
    mutate(popularity = (modelSum$coefficients[3] + modelSum$coefficients[5] * extrav) * texp,
           extrav = factor(extrav))
{% endhighlight %}

-   Plot
    ![]({{ base.url }}/assets/RMD/Probing-Interactions-in-MLM_files/figure-markdown_strict/unnamed-chunk-12-1.png)

Conclusion: The slope of teacher experience is significantly different from 0 at 1 SD of the mean and at the mean of extraversion. <br>


Johnson-Neyman Technique
------------------------

1.  Start with the *t*-statistic

$$\\pm t = \\frac{\\hat\\omega\_1}{SE\_{\\hat\\omega\_1}}$$

Expand

$$\\pm t = \\frac{(\\hat\\gamma\_{01} + \\hat\\gamma\_{21}X)}{var(\\hat\\gamma\_{01}) + 2Xcov(\\hat\\gamma\_{01}, \\hat\\gamma\_{21}) + X^2 var(\\hat\\gamma\_{21})}$$

1.  Find values of X that solve for *t*  

-   X can be found by solving the following quadratic (Carden, Holtzman,
    Strube, 2017):

$$X\_{lower}, X\_{upper} = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}$$

where

*a* = *t*<sub>*α*/2</sub><sup>2</sup>*V**a**r*(*γ̂*<sub>21</sub>) − *γ̂*<sub>3</sub><sup>2</sup>,

*b* = 2*t*<sub>*α*/2</sub><sup>2</sup>*C**o**v*(*γ̂*<sub>1</sub>, *γ̂*<sub>21</sub>) − 2*γ̂*<sub>1</sub>*γ̂*<sub>21</sub>,

*c* = *t*<sub>*α*/2</sub><sup>2</sup>*V**a**r*(*γ̂*<sub>1</sub>) − *γ̂*<sub>1</sub><sup>2</sup>

{% highlight r %}
a = qt(.025, df)^2 * .000006526482 - modelSum$coefficients[5] ^ 2
b = 2 * qt(.025, df)^2 * -.00009232641 - 2 * modelSum$coefficients[3] * modelSum$coefficients[5]
c = qt(.025, df)^2 * .001609389 - modelSum$coefficients[3]^2
      
# Functions for solving quadratic equation (Hatzistavrou, https://rpubs.com/kikihatzistavrou/80124)
# Constructing delta
delta = function(a, b, c){
      b^2 - 4*a*c
}

# Constructing Quadratic Formula
result = function(a, b, c){
  if(delta(a, b, c) > 0){ # First case where Delta > 0
        x1 = (-b + sqrt(delta(a, b, c)))/(2*a)
        x2 = (-b - sqrt(delta(a, b, c)))/(2*a)
        return(c(x1, x2))
  }
  else if(delta(a, b, c) == 0){ # Second case where Delta = 0
        x = -b/(2*a)
        return(x)
  }
  else {"There are no real roots."} # Third case where Delta < 0
}
{% endhighlight %}

The regions of significance for the slope of teacher experience, conditioned on extraversion are significant beyond 29.1564177269881 and 37.4077675641277 points of extraversion. This is outside the range of extraversion; therefore, the slope of teacher experience is significantly different from 0 at all values of extraversion.

<br>

1.  Plotting  

-   Calculating estimates of the slope for teacher experience as a
    function of extraversion

<!-- -->

{% highlight r %}
jnData = data.frame(extrav = c(1:50)) %>% 
  mutate(texp = modelSum$coefficients[3] + modelSum$coefficients[5] * extrav)
  
jnData %>% 
  ggplot() +
  aes(x = extrav,
      y = texp) +
  geom_line() +
  theme_bw() +
  labs(x = "Extraversion",
       y = "Simple Slope of Teacher Experience Predicting Popularity") +
  theme(legend.key.width = unit(2, "cm"),
        legend.background = element_rect(color = "Black"),
        legend.position = c(1, 0),
        legend.justification = c(1, 0)) +
  geom_vline(xintercept = c(result(a, b, c)), linetype = 2)
{% endhighlight %}


![]({{ base.url }}/assets/RMD/Probing-Interactions-in-MLM_files/figure-markdown_strict/unnamed-chunk-16-1.png)
