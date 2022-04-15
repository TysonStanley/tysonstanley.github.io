---
layout: default
title: "Regression Analysis"
permalink: /teaching/regression
---

<img src="{{ site.baseurl }}/assets/images/RDA2_logo.png" alt="RDA1_logo" width="35%" align="right">
# Regression Analysis

This class is all about applying regression analysis and linear models, including generalized linear models, mediation and moderation, with a little bit of machine learning techniques thrown in. The book we'll use throughout the class, and that drives the structure of the lecture slides, is [Regression Analysis and Linear Models](https://www.guilford.com/books/Regression-Analysis-and-Linear-Models/Darlington-Hayes/9781462521135/reviews) by Richard Darlington and Andrew Hayes. This course uses [R](https://www.r-project.org/) and [RStudio](https://www.rstudio.com/) for all data analyses. 

We will use several different data sets during the course:

- A subset of the [General Social Survey]({{ site.slidesurl }}/EDUC-7610/GSS_Data/Data/GSS_reduced_example.csv)
- A [data set used in Quas et al. about high risk youth]({{ site.slidesurl }}/EDUC-7610/HighRisk_Data/HighRisk.csv) data set
- A [data set regarding poverty, violence, and teen birth rates per state]({{ site.slidesurl }}/EDUC-7610/Poverty_Data/poverty.xlsx)
- A [small (ficticious) data set about *The Office (US)* and *Parks and Recreation* television shows]({{ base.url }}/assets/Data/OfficeParks.csv) 
- A [data set about the passengers of the titanic]({{ base.url }}/assets/Data/Titanic.csv)
- A [fictious data set about the "Married At First Sight" TV show]({{ base.url }}/assets/Data/mafs.csv)

We may also pull from [FiveThirtyEight's open data on GitHub](https://github.com/fivethirtyeight/data) occassionally throughout the class (many of these data sets can be used for your class project as well if they have both continuous and categorical predictors). 


## [Syllabus]({{ site.baseurl }}/syllabus/educ7610)

## Class Materials


### Unit 1

[In-Class Material RMD]({{ site.slidesurl }}/EDUC-7610/Slides-Flipped/InClass/InClass1.Rmd)

| Lecture                    |  Slides and Materials   |  Recorded Lecture      |
|:---------------------------|:-----------------------:|:-----------------------|
| L0: Intro to the class     | [PPTX]({{ site.slidesurl }}/EDUC-7610/Slides-Flipped/Unit 1/L0_EDUC7610_Intro.pptx)                  |  |    
| L1: Intro to R and RStudio | [HTML]({{ site.slidesurl }}/EDUC-7610/Slides-Flipped/Unit 1/L1_EDUC7610_IntroR.html)                 | [Intro to R](https://youtu.be/hjyQ_KOV0Bc) | 
| L2: Causation              | [PPTX]({{ site.slidesurl }}/EDUC-7610/Slides-Flipped/Unit 1/L2_EDUC7610_causation.pptx)              | [Causation](https://youtu.be/YHNbzAg9va0) | 
| L3: Simple Regression      | [PPTX]({{ site.slidesurl }}/EDUC-7610/Slides-Flipped/Unit 1/L3_EDUC7610_simple_reg.pptx)             | [Simple Regression](https://youtu.be/LRmSPXuPKic) | 
| L4: Multiple Regression    | [PPTX]({{ site.slidesurl }}/EDUC-7610/Slides-Flipped/Unit 1/L4_EDUC7610_multiple.pptx)               | [Multiple Regression](https://youtu.be/cFfGhKsVPHg) | 
| L5: Categorical Predictors | [PPTX]({{ site.slidesurl }}/EDUC-7610/Slides-Flipped/Unit 1/L5_EDUC7610_CategoricalPredictors.pptx)  | [Categorical Predictors](https://youtu.be/YCdKs61ClV4) | 

### Unit 2

[In-Class Material RMD]({{ site.slidesurl }}/EDUC-7610/Slides-Flipped/InClass/InClass2.Rmd)

| Lecture                    |  Slides and Materials   |  Recorded Lecture      |
|:---------------------------|:-----------------------:|:-----------------------|
| L6: Statistical Inference  | [PPTX]({{ site.slidesurl }}/EDUC-7610/Slides-Flipped/Unit 2/L6_EDUC7610_inference.pptx)    | [Inference Part 1](https://youtu.be/HcTA13vHzAM) & [Inference Part 2](https://youtu.be/0r6pFXuNYXA) |    
| L7: Model Diagnostics      | [PPTX]({{ site.slidesurl }}/EDUC-7610/Slides-Flipped/Unit 2/L7_EDUC7610_diagnostics.pptx)  | [Diagnostics Part 1](https://youtu.be/Iz4LpBlMRmA) & [Diagnostics Part 2](https://youtu.be/G3lQKCJ01DM) |
| L8: Missing Data & Such    | [PPTX]({{ site.slidesurl }}/EDUC-7610/Slides-Flipped/Unit 2/L8_EDUC7610_missingdata.pptx)  | [Missing Data](https://youtu.be/w41wU-yK3Pk) | 
| L9: Threats to Validity    | [PPTX]({{ site.slidesurl }}/EDUC-7610/Slides-Flipped/Unit 2/L9_EDUC7610_validity.pptx)     | [Threats to Validity](https://youtu.be/8jiHyigvfg4) | 


### Unit 3

[In-Class Material RMD]({{ site.slidesurl }}/EDUC-7610/Slides-Flipped/InClass/InClass3.Rmd)

| Lecture                      |  Slides and Materials   |  Recorded Lecture      |
|:-----------------------------|:-----------------------:|:-----------------------|
| L10: Effect Sizes            | [PPTX]({{ site.slidesurl }}/EDUC-7610/Slides-Flipped/Unit 3/L10_EDUC7610_EffectSize.pptx)    | [Effect Size](https://youtu.be/GfhG4dW_dSA) |    
| L11: Linear Interactions     | [PPTX]({{ site.slidesurl }}/EDUC-7610/Slides-Flipped/Unit 3/L11_EDUC7610_interactions.pptx)  | [Interactions Part 1](https://youtu.be/GuXy1ppBwHE) & [Interactions Part 2](https://youtu.be/X-TDipzads4) | 
| L12: Nonlinear Relationships | [PPTX]({{ site.slidesurl }}/EDUC-7610/Slides-Flipped/Unit 3/L12_EDUC7610_nonlinear.pptx)     | [Nonlinear](https://youtu.be/99kmluKmk5k) | 
| L13: Intro to GLMs           | [PPTX]({{ site.slidesurl }}/EDUC-7610/Slides-Flipped/Unit 3/L13_EDUC7610_glm.pptx)           | [Intro to GLMs](https://youtu.be/X-XVa7Z-uNo) | 

### Unit 4

[In-Class Material RMD]({{ site.slidesurl }}/EDUC-7610/Slides-Flipped/InClass/InClass4.Rmd)

| Lecture                      |  Slides and Materials   |  Recorded Lecture      |
|:-----------------------------|:-----------------------:|:-----------------------|
| L14: Logistic Regression     | [PPTX]({{ site.slidesurl }}/EDUC-7610/Slides-Flipped/Unit 4/L14_EDUC7610_logistic.pptx)  | [Logistic Regression](https://youtu.be/OgUlrSIVCbk) |    
| L15: Other GLMs              | [PPTX]({{ site.slidesurl }}/EDUC-7610/Slides-Flipped/Unit 4/L15_EDUC7610_otherglm.pptx)  | [Other GLMs](https://youtu.be/1FUgGYPXmFE) | 
| L16: Mediation Analysis      | [HTML](https://tysonbarrett.com/Workshops/MediationAnalysis.html#1)                      | [Mediation Analysis](https://youtu.be/WGPPqJaa1Ho) | 
| L17: Miscellaneous           | [PPTX]({{ site.slidesurl }}/EDUC-7610/Slides-Flipped/Unit 4/L17_EDUC7610_misc_updatedclean.pptx)  |  | 

### Final Project

[Here's]({{ site.slidesurl }}/assets/Course Materials/EDUC7610/Example Final Project.pdf) an example of a final project from a few years ago. This follows the template well but doesn't necessarily have all the stuff in it (e.g., they could have included a DAG, a plot of the data other than the diagnostics), but this shows understanding of the material so it receive a high grade.


