---
layout: default
title: "Regression Analysis"
permalink: /teaching/regression
---

<img src="{{ site.baseurl }}/assets/images/RDA2_logo.png" alt="RDA1_logo" width="35%" align="right">
# Regression Analysis

This class is all about applying regression analysis and linear models, including generalized linear models, mediation and moderation, with a little bit of machine learning techniques thrown in. The book we'll use throughout the class, and that drives the structure of the lecture slides, is [Regression Analysis and Linear Models](https://www.guilford.com/books/Regression-Analysis-and-Linear-Models/Darlington-Hayes/9781462521135/reviews) by Richard Darlington and Andrew Hayes. This course uses [R](https://www.r-project.org/) and [RStudio](https://www.rstudio.com/) for all data analyses. 

A subset of the [General Social Survey]({{ slidesurl }}/EDUC-7610/GSS_Data/Data/GSS_reduced_example.csv) data set, a [data set used in Quas et al. about high risk youth]({{ slidesurl }}/EDUC-7610/HighRisk_Data/HighRisk.csv) data set, and a [data set regarding poverty, violence, and teen birth rates per state]({{ slidesurl }}/EDUC-7610/Poverty_Data/poverty.xlsx) will be used in the examples. We will also pull from [FiveThirtyEight's open data on GitHub](https://github.com/fivethirtyeight/data) occassionally throughout the class (many of these data sets can be used for your class project as well if they have both continuous and categorical predictors). Finally, [a small (ficticious) data set about *The Office (US)* and *Parks and Recreation* television shows]({{ base.url }}/assets/Data/OfficeParks.csv) is also available.


[Syllabus]({{ site.baseurl }} /syllabus/educ7610)

### Class Materials

| Chapter                |  Slides and Materials   |  Recorded Lecture      |  Examples          |
|:----------------------:|:------------------------|:-----------------------|:-------------------|
| Intro to the class     | [PPTX]({{ slidesurl }}/EDUC-7610/Slides/00_EDUC7610_Intro.pptx)          & [PDF]({{ slidesurl }}/EDUC-7610/Slides/00_EDUC7610_Intro.pdf)        | [Recorded Lecture]() |  |    
| Intro to R and RStudio | [HTML]({{ slidesurl }}/EDUC-7610/Slides/00_EDUC7610_IntroR.html)         & [RMD]({{ slidesurl }}/EDUC-7610/Slides/00_EDUC7610_IntroR.Rmd)       | [Recorded Lecture]() |  |
| Chapter 1              | [PPTX]({{ slidesurl }}/EDUC-7610/Slides/01_EDUC7610_stat_control.pptx)   & [PDF]({{ slidesurl }}/EDUC-7610/Slides/01_EDUC7610_stat_control.pdf) | [Recorded Lecture]() | [Examples]({{ slidesurl }}/EDUC-7610/Slides/01_EDUC7610_stat_control_example.html) |
|                        | [Tidy Data]({{ slidesurl }}/EDUC-7610/Readings/Hadley_TidyData_2014.pdf) & [Data Guidelines]({{ slidesurl }}/EDUC-7610/Readings/Broman_DataSpreadsheets_2017.pdf) | |
| Chapter 2              | [PPTX]({{ slidesurl }}/EDUC-7610/Slides/02_EDUC7610_simple_reg.pptx)     & [PDF]({{ slidesurl }}/EDUC-7610/Slides/02_EDUC7610_simple_reg.pdf)   | [Recorded Lecture]() | [Examples]({{ slidesurl }}/EDUC-7610/Slides/02_EDUC7610_simple_reg_example.html) |
|                        | [Plot Your Data]({{ slidesurl }}/EDUC-7610/Readings/SameStats-DifferentGraphs.pdf) | |
| Chapter 3              | [PPTX]({{ slidesurl }}/EDUC-7610/Slides/03_EDUC7610_multiple_reg.pptx)   & [PDF]({{ slidesurl }}/EDUC-7610/Slides/03_EDUC7610_multiple_reg.pdf) | [Recorded Lecture]() | [Examples]({{ slidesurl }}/EDUC-7610/Slides/03_EDUC7610_multiple_reg_example) |
| Chapter 4              | [PPTX]({{ slidesurl }}/EDUC-7610/Slides/04_EDUC7610_inference.pptx)      & [PDF]({{ slidesurl }}/EDUC-7610/Slides/04_EDUC7610_inference.pdf)    | [Recorded Lecture]() | [Examples]({{ slidesurl }}/EDUC-7610/Slides/04_EDUC7610_inference_example) |
| Chapter 5              | [PPTX]({{ slidesurl }}/EDUC-7610/Slides/05_EDUC7610_extending.pptx)      & [PDF]({{ slidesurl }}/EDUC-7610/Slides/05_EDUC7610_extending.pdf)    | [Recorded Lecture]() | [Examples]({{ slidesurl }}/EDUC-7610/Slides/05_EDUC7610_extending_example) & [Review 1]({{ slidesurl }}/EDUC-7610/Slides/20_Review_Interpretation.pdf) & [Review 2]({{ slidesurl }}/EDUC-7610/Slides/20_Review_Slope_Correlation.pptx) & [Review 3]({{ slidesurl }}/EDUC-7610/Slides/20_Review_Slope_Correlation.pdf) |
| Chapter 6              | [PPTX]({{ slidesurl }}/EDUC-7610/Slides/06_EDUC7610_control.pptx)        & [PDF]({{ slidesurl }}/EDUC-7610/Slides/06_EDUC7610_control.pdf)      | [Recorded Lecture]() | [Examples]({{ slidesurl }}/EDUC-7610/Slides/06_EDUC7610_control_example) |
| Chapter 7              | [PPTX]({{ slidesurl }}/EDUC-7610/Slides/07_EDUC7610_prediction.pptx)     & [PDF]({{ slidesurl }}/EDUC-7610/Slides/07_EDUC7610_prediction.pdf)   | [Recorded Lecture]() | [Examples]({{ slidesurl }}/EDUC-7610/Slides/07_EDUC7610_prediction_example) |
| Chapter 8              | [PPTX]({{ slidesurl }}/EDUC-7610/Slides/08_EDUC7610_importance.pptx)     & [PDF]({{ slidesurl }}/EDUC-7610/Slides/08_EDUC7610_importance.pdf)   | [Recorded Lecture]() | [Examples]({{ slidesurl }}/EDUC-7610/Slides/08_EDUC7610_importance_example) |
| Chapter 9 and 10       | [PPTX]({{ slidesurl }}/EDUC-7610/Slides/09_EDUC7610_multicat.pptx)       & [PDF]({{ slidesurl }}/EDUC-7610/Slides/09_EDUC7610_multicat.pdf)     | [Recorded Lecture]() | [Examples]({{ slidesurl }}/EDUC-7610/Slides/09_EDUC7610_multicat_example) |
| Chapter 11             | [PPTX]({{ slidesurl }}/EDUC-7610/Slides/11_EDUC7610_multipletest.pptx)   & [PDF]({{ slidesurl }}/EDUC-7610/Slides/11_EDUC7610_multipletest.pdf) | [Recorded Lecture]() | [Examples]({{ slidesurl }}/EDUC-7610/Slides/11_EDUC7610_multipletest_example) |
| Chapter 12             | [PPTX]({{ slidesurl }}/EDUC-7610/Slides/12_EDUC7610_nonlinear.pptx)      & [PDF]({{ slidesurl }}/EDUC-7610/Slides/12_EDUC7610_nonlinear.pdf)    | [Recorded Lecture]() | [Examples]({{ slidesurl }}/EDUC-7610/Slides/12_EDUC7610_nonlinear_example) |
| Chapters 13 and 14     | [PPTX]({{ slidesurl }}/EDUC-7610/Slides/13_EDUC7610_interactions.pptx)   & [PDF]({{ slidesurl }}/EDUC-7610/Slides/13_EDUC7610_interactions.pdf) | [Recorded Lecture]() | [Examples]({{ slidesurl }}/EDUC-7610/Slides/13_EDUC7610_interactions_example) & [Review Material]({{ slidesurl }}/EDUC-7610/Slides/20_Review_Interactions.pdf) |
| Chapters 16 and 17     | [PPTX]({{ slidesurl }}/EDUC-7610/Slides/16_EDUC7610_assumptions.pptx)    & [PDF]({{ slidesurl }}/EDUC-7610/Slides/16_EDUC7610_assumptions.pdf)  | | [Examples]({{ slidesurl }}/EDUC-7610/Slides/16_EDUC7610_assumptions_example.html) |
|                        | [Measurement/Reproducibility](http://science.sciencemag.org/content/sci/355/6325/584.full.pdf) & [Measurement Error](http://www.quantpsy.org/pubs/cole_preacher_2014.pdf) & Missing Data - see Little, R. J., & Rubin, D. B. (2014). Statistical analysis with missing data (Vol. 333). John Wiley & Sons. & [Missing Data Overview](http://journals.sagepub.com/doi/pdf/10.1177/1094428114548590) | | [Resampling Examples]({{ slidesurl }}/EDUC-7610/Slides/20_EDUC7610_bootstrap.html) |
| Chapter 18             | [PPTX]({{ slidesurl }}/EDUC-7610/Slides/18_EDUC7610_glm.pptx)            & [PDF]({{ slidesurl }}/EDUC-7610/Slides/18_EDUC7610_glm.pdf) | | [Examples]({{ slidesurl }}/EDUC-7610/Slides/18_EDUC7610_glm_example) |
| Chapter 15             | [HTML](https://tysonstanley.github.io/Workshops/MediationAnalysis.html)  | | [Examples]({{ slidesurl }}/EDUC-7610/Slides/15_EDUC7610_mediation_example) |

### Homework Assignments

| Homework | HTML (Easier to Read) | RMD (To Work With) |
|:--------:|:---------------------:|:------------------:|
| 1        | [HTML]({{ slidesurl }}/EDUC-7610/Homework/HW1) | [RMD]({{ slidesurl }}/EDUC-7610/Homework/HW1.Rmd) |
| 2        | [HTML]({{ slidesurl }}/EDUC-7610/Homework/HW2.html) | [RMD]({{ slidesurl }}/EDUC-7610/Homework/HW2.Rmd) |
| 3        | [HTML]({{ slidesurl }}/EDUC-7610/Homework/HW3) | [RMD]({{ slidesurl }}/EDUC-7610/Homework/HW3.Rmd) |
| Final Project | [HTML]({{ slidesurl }}/EDUC-7610/Homework/Final) | Example Final Project [PDF]({{ slidesurl }}/EDUC-7610/Homework/Example Final Project.pdf) and [Word]({{ slidesurl }}/EDUC-7610/Homework/Example Final Project.docx) |


