---
layout: page
title: R for the Health, Behavioral, and Social Sciences
permalink: /R/
---

[![Rstats]({{ site.baseurl }}/assets/images/Cover.png)]( {{site.baseurl}} /Rstats/)

I have written a book entitled **R for the Health, Behavioral, and Social Sciences** designed to help teach `R` to health, behavioral, and social scientists that have little or no experience with `R`. The online version is available at [tysonstanley.github.io/Rstats]( {{site.baseurl}} /Rstats/), a paper copy and a Kindle-version copy should be available soon (I'll post a link for it on Amazon's website).

The data necessary for several chapters of the book can be downloaded [here]({{site.baseurl}} /assets/Data/NHANES_2012.rda). The code below shows the additional steps taken to clean it up (if you are interested---no pressure!).

{% highlight r %}
library(foreign)
library(furniture)
library(tidyverse)
dem_df <- read.xport("~/Box Sync/GitHub/blog_rstats/assets/Data/NHANES_demographics_11.xpt")
med_df <- read.xport("~/Box Sync/GitHub/blog_rstats/assets/Data/NHANES_MedHeath_11.xpt")
men_df <- read.xport("~/Box Sync/GitHub/blog_rstats/assets/Data/NHANES_MentHealth_11.xpt")
act_df <- read.xport("~/Box Sync/GitHub/blog_rstats/assets/Data/NHANES_PhysActivity_11.xpt")
names(dem_df) <- tolower(names(dem_df))
names(med_df) <- tolower(names(med_df))
names(men_df) <- tolower(names(men_df))
names(act_df) <- tolower(names(act_df))
df <- dem_df %>%
  full_join(med_df, by="seqn") %>%
  full_join(men_df, by="seqn") %>%
  full_join(act_df, by="seqn") %>%
  mutate(marriage = factor(washer(dmdmartl, 77, 99))) %>%
  filter(complete.cases(marriage)) %>%
  mutate(race = factor(ridreth1, 
                       labels=c("MexicanAmerican", "OtherHispanic", 
                                "White", "Black", "Other"))) %>%
  mutate(famsize = as.numeric(washer(dmdfmsiz, 7,9))) %>%
  mutate(dpq010 = washer(dpq010, 7,9),
         dpq020 = washer(dpq020, 7,9),
         dpq030 = washer(dpq030, 7,9),
         dpq040 = washer(dpq040, 7,9),
         dpq050 = washer(dpq050, 7,9),
         dpq060 = washer(dpq060, 7,9),
         dpq070 = washer(dpq070, 7,9),
         dpq080 = washer(dpq080, 7,9),
         dpq090 = washer(dpq090, 7,9),
         dpq100 = washer(dpq100, 7,9)) %>%
  mutate(dep = dpq010 + dpq020 + dpq030 + dpq040 + dpq050 +
               dpq060 + dpq070 + dpq080 + dpq090) %>%
  mutate(dep2 = factor(ifelse(dep >= 10, 1,
                       ifelse(dep < 10, 0, NA))))
df <- df %>%
  mutate(asthma = washer(mcq010, 9, 7),
         asthma = factor(washer(asthma, 2, value = 0),
                         labels = c("No Asthma", "Asthma"))) %>%
  mutate(sed = washer(pad680, 9999, 7777)) %>%
  mutate(cluster = sdmvstra - 89) %>%
  filter(complete.cases(asthma) & complete.cases(dep2)) 
{% endhighlight %}



