---
layout: default
title: "Regression Analysis"
permalink: /teaching/regression
---

<img src="{{ site.baseurl }}/assets/images/RDA2_logo.png" alt="RDA1_logo" width="35%" align="right">
# Regression Analysis

This class is all about applying regression analysis and linear models, including generalized linear models, mediation and moderation, with a little bit of machine learning techniques thrown in. The book we'll use throughout the class, and that drives the structure of the lecture slides, is [Regression Analysis and Linear Models](https://www.guilford.com/books/Regression-Analysis-and-Linear-Models/Darlington-Hayes/9781462521135/reviews) by Richard Darlington and Andrew Hayes. This course uses [R](https://www.r-project.org/) and [RStudio](https://www.rstudio.com/) for all data analyses. 

A subset of the [General Social Survey](https://cehs-research.github.io/EDUC-7610/GSS_Data/Data/GSS_reduced_example.csv) data set, a [data set used in Quas et al. about high risk youth](https://cehs-research.github.io/EDUC-7610/HighRisk_Data/HighRisk.csv) data set, and a [data set regarding poverty, violence, and teen birth rates per state](https://cehs-research.github.io/EDUC-7610/Poverty_Data/poverty.xlsx) will be used in the examples. We will also pull from [FiveThirtyEight's open data on GitHub](https://github.com/fivethirtyeight/data) occassionally throughout the class (many of these data sets can be used for your class project as well if they have both continuous and categorical predictors). Finally, [a small (ficticious) data set about *The Office (US)* and *Parks and Recreation* television shows]({{ base.url }}/assets/Data/OfficeParks.csv) is also available.


[Syllabus]({{ site.baseurl }} /syllabus/educ7610)

### Lecture Slides

1. Introductions to the class [PPTX](https://cehs-research.github.io/EDUC-7610/Slides/00_EDUC7610_Intro.pptx) or [PDF](https://cehs-research.github.io/EDUC-7610/Slides/00_EDUC7610_Intro.pdf) and to R and RStudio [HTML](https://cehs-research.github.io/EDUC-7610/Slides/00_EDUC7610_IntroR.html) or [RMD](https://cehs-research.github.io/EDUC-7610/Slides/00_EDUC7610_IntroR.Rmd) and Chapter 1 [PPTX](https://cehs-research.github.io/EDUC-7610/Slides/01_EDUC7610_stat_control.pptx) or [PDF](https://cehs-research.github.io/EDUC-7610/Slides/01_EDUC7610_stat_control.pdf)
  - Readings: [Tidy Data](https://cehs-research.github.io/EDUC-7610/Readings/Hadley_TidyData_2014.pdf) and [Data Guidelines](https://cehs-research.github.io/EDUC-7610/Readings/Broman_DataSpreadsheets_2017.pdf)
  - Examples [HTML](https://cehs-research.github.io/EDUC-7610/Slides/01_EDUC7610_stat_control_example.html)
2. Chapter 2 [PPTX](https://cehs-research.github.io/EDUC-7610/Slides/02_EDUC7610_simple_reg.pptx) or [PDF](https://cehs-research.github.io/EDUC-7610/Slides/02_EDUC7610_simple_reg.pdf)
  - Readings: [Plot Your Data](https://cehs-research.github.io/EDUC-7610/Readings/SameStats-DifferentGraphs.pdf)
  - Examples [HTML](https://cehs-research.github.io/EDUC-7610/Slides/02_EDUC7610_simple_reg_example.html) or [RMD](https://cehs-research.github.io/EDUC-7610/Slides/02_EDUC7610_simple_reg_example.Rmd)
3. Chapter 3 [PPTX](https://cehs-research.github.io/EDUC-7610/Slides/03_EDUC7610_multiple_reg.pptx) or [PDF](https://cehs-research.github.io/EDUC-7610/Slides/03_EDUC7610_multiple_reg.pdf)
  - Examples [HTML](https://cehs-research.github.io/EDUC-7610/Slides/03_EDUC7610_multiple_reg_example) or [RMD](https://cehs-research.github.io/EDUC-7610/Slides/03_EDUC7610_multiple_reg_example.Rmd)
4. Chapter 4 [PPTX](https://cehs-research.github.io/EDUC-7610/Slides/04_EDUC7610_inference.pptx) or [PDF](https://cehs-research.github.io/EDUC-7610/Slides/04_EDUC7610_inference.pdf)
  - Examples [HTML](https://cehs-research.github.io/EDUC-7610/Slides/04_EDUC7610_inference_example) or [RMD](https://cehs-research.github.io/EDUC-7610/Slides/04_EDUC7610_inference_example.Rmd)
  - Extra Stuff [HTML](https://cehs-research.github.io/EDUC-7610/GuessAge) or [RMD](https://cehs-research.github.io/EDUC-7610/GuessAge.Rmd)
5. Chapter 5 [PPTX](https://cehs-research.github.io/EDUC-7610/Slides/05_EDUC7610_extending.pptx) or [PDF](https://cehs-research.github.io/EDUC-7610/Slides/05_EDUC7610_extending.pdf)
  - Examples [HTML](https://cehs-research.github.io/EDUC-7610/Slides/05_EDUC7610_extending_example) or [RMD](https://cehs-research.github.io/EDUC-7610/Slides/05_EDUC7610_extending_example.Rmd)
  - Review Material for Exam 1: [PPTX](https://cehs-research.github.io/EDUC-7610/Slides/20_Review_Interpretation.pptx) and [PDF](https://cehs-research.github.io/EDUC-7610/Slides/20_Review_Interpretation.pdf)
  - Me, trying to explain why the slope changes when you control for a variable related to both X and Y while the correlation changes if the control variable is related to Y: [VennDiagram.mp4]({{ site.baseurl }}/assets/Videos/VennDiagram.mp4)
  - Why Correlation Changes When Slope Doesn't Sometimes When Controlling: [PPTX](https://cehs-research.github.io/EDUC-7610/Slides/20_Review_Slope_Correlation.pptx) and [PDF](https://cehs-research.github.io/EDUC-7610/Slides/20_Review_Slope_Correlation.pdf)
6. Chapter 6 [PPTX](https://cehs-research.github.io/EDUC-7610/Slides/06_EDUC7610_control.pptx) or [PDF](https://cehs-research.github.io/EDUC-7610/Slides/06_EDUC7610_control.pdf)
  - Examples [HTML](https://cehs-research.github.io/EDUC-7610/Slides/06_EDUC7610_control_example) or [RMD](https://cehs-research.github.io/EDUC-7610/Slides/06_EDUC7610_control_example.Rmd)
7. Chapter 7 [PPTX](https://cehs-research.github.io/EDUC-7610/Slides/07_EDUC7610_prediction.pptx) or [PDF](https://cehs-research.github.io/EDUC-7610/Slides/07_EDUC7610_prediction.pdf)
  - Examples [HTML](https://cehs-research.github.io/EDUC-7610/Slides/07_EDUC7610_prediction_example) or [RMD](https://cehs-research.github.io/EDUC-7610/Slides/07_EDUC7610_prediction_example.Rmd)
8. Chapter 8 [PPTX](https://cehs-research.github.io/EDUC-7610/Slides/08_EDUC7610_importance.pptx) or [PDF](https://cehs-research.github.io/EDUC-7610/Slides/08_EDUC7610_importance.pdf)
  - Examples [HTML](https://cehs-research.github.io/EDUC-7610/Slides/08_EDUC7610_importance_example) or [RMD](https://cehs-research.github.io/EDUC-7610/Slides/08_EDUC7610_importance_example.Rmd)
9. Chapter 9 and 10 [PPTX](https://cehs-research.github.io/EDUC-7610/Slides/09_EDUC7610_multicat.pptx) or [PDF](https://cehs-research.github.io/EDUC-7610/Slides/09_EDUC7610_multicat.pdf)
  - Examples [HTML](https://cehs-research.github.io/EDUC-7610/Slides/09_EDUC7610_multicat_example) or [RMD](https://cehs-research.github.io/EDUC-7610/Slides/09_EDUC7610_multicat_example.Rmd)
10. Chapter 11 [PPTX](https://cehs-research.github.io/EDUC-7610/Slides/11_EDUC7610_multipletest.pptx) or [PDF](https://cehs-research.github.io/EDUC-7610/Slides/11_EDUC7610_multipletest.pdf)
  - Examples [HTML](https://cehs-research.github.io/EDUC-7610/Slides/11_EDUC7610_multipletest_example) or [RMD](https://cehs-research.github.io/EDUC-7610/Slides/11_EDUC7610_multipletest_example.Rmd)
11. Chapter 12 [PPTX](https://cehs-research.github.io/EDUC-7610/Slides/12_EDUC7610_nonlinear.pptx) or [PDF](https://cehs-research.github.io/EDUC-7610/Slides/12_EDUC7610_nonlinear.pdf)
  - Examples [HTML](https://cehs-research.github.io/EDUC-7610/Slides/12_EDUC7610_nonlinear_example) or [RMD](https://cehs-research.github.io/EDUC-7610/Slides/12_EDUC7610_nonlinear_example.Rmd)
12. Chapter 13 and 14 [PPTX](https://cehs-research.github.io/EDUC-7610/Slides/13_EDUC7610_interactions.pptx) or [PDF](https://cehs-research.github.io/EDUC-7610/Slides/13_EDUC7610_interactions.pdf)
  - Examples [HTML](https://cehs-research.github.io/EDUC-7610/Slides/13_EDUC7610_interactions_example) or [RMD](https://cehs-research.github.io/EDUC-7610/Slides/13_EDUC7610_interactions_example.Rmd)
  - Review of Interactions - [PPTX](https://cehs-research.github.io/EDUC-7610/Slides/20_Review_Interactions.pptx) and [PDF](https://cehs-research.github.io/EDUC-7610/Slides/20_Review_Interactions.pdf)
13. Chapters 16 and 17 [PPTX](https://cehs-research.github.io/EDUC-7610/Slides/16_EDUC7610_assumptions.pptx) or [PDF](https://cehs-research.github.io/EDUC-7610/Slides/16_EDUC7610_assumptions.pdf)
  - Examples [HTML](https://cehs-research.github.io/EDUC-7610/Slides/16_EDUC7610_assumptions_example.html) or [RMD](https://cehs-research.github.io/EDUC-7610/Slides/16_EDUC7610_assumptions_example.Rmd)
  - [Measurement Error and Reproducibility](http://science.sciencemag.org/content/sci/355/6325/584.full.pdf)
  - [Measurement Error in Practice](http://www.quantpsy.org/pubs/cole_preacher_2014.pdf)
  - Missing Data - see Little, R. J., & Rubin, D. B. (2014). Statistical analysis with missing data (Vol. 333). John Wiley & Sons.
  - [Missing Data Overview](http://journals.sagepub.com/doi/pdf/10.1177/1094428114548590)
  - [Resampling Techniques: Bootstrapping and Monte Carlo Examples](https://cehs-research.github.io/EDUC-7610/Slides/20_EDUC7610_bootstrap.html)
14. Chapter 18 [PPTX](https://cehs-research.github.io/EDUC-7610/Slides/18_EDUC7610_glm.pptx) or [PDF](https://cehs-research.github.io/EDUC-7610/Slides/18_EDUC7610_glm.pdf)
  - Examples [HTML](https://cehs-research.github.io/EDUC-7610/Slides/18_EDUC7610_glm_example) or [RMD](https://cehs-research.github.io/EDUC-7610/Slides/18_EDUC7610_glm_example.Rmd)
15. Chapter 15 [HTML](https://tysonstanley.github.io/Workshops/MediationAnalysis.html)
  - Examples [HTML](https://cehs-research.github.io/EDUC-7610/Slides/15_EDUC7610_mediation_example) or [RMD](https://cehs-research.github.io/EDUC-7610/Slides/15_EDUC7610_mediation_example.Rmd)

### Homework Assignments

1. Homework 1 [HTML](https://cehs-research.github.io/EDUC-7610/Homework/HW1) and [RMD](https://cehs-research.github.io/EDUC-7610/Homework/HW1.Rmd)
2. Homework 2 [HTML](https://cehs-research.github.io/EDUC-7610/Homework/HW2.html) and [RMD](https://cehs-research.github.io/EDUC-7610/Homework/HW2.Rmd)
3. Homework 3 [HTML](https://cehs-research.github.io/EDUC-7610/Homework/HW3) and [RMD](https://cehs-research.github.io/EDUC-7610/Homework/HW3.Rmd)
4. (Optional) Homework 4 [HTML](https://cehs-research.github.io/EDUC-7610/Homework/HW4) and [RMD](https://cehs-research.github.io/EDUC-7610/Homework/HW4.Rmd)
5. Final Project [HTML](https://cehs-research.github.io/EDUC-7610/Homework/Final)
  - Example Final Project [PDF](https://cehs-research.github.io/EDUC-7610/Homework/Example Final Project.pdf) and [Word](https://cehs-research.github.io/EDUC-7610/Homework/Example Final Project.docx)

### Outdated Material

1. [Polynomials and Interactions (A Little Outdated)](https://cehs-research.github.io/EDUC-7610/Slides/20_Review_Ch12_17)
