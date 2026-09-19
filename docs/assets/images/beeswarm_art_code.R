

library(tidyverse)
library(ggbeeswarm)

set.seed(84322)
d <- tibble(timings = rnorm(1000, 100, 5),
            method = sample(c("Control", "Treatment 1", "Treatment 2", "Waitlist"), size = 1000, replace = TRUE))

d %>% 
  mutate(timings = case_when(method == "Treatment 1" ~ timings - 30 + rnorm(1000),
                             method == "Treatment 2" ~ timings - 15 + rnorm(1000),
                             TRUE ~ timings)) %>% 
  ggplot(aes(method, timings, color = method)) +
    geom_beeswarm(show.legend = FALSE,
                  alpha = .9) +
    stat_summary(geom = "errorbar", 
                 color = "#922B21", 
                 fun.data = "mean_cl_boot", 
                 fun.args = c(B = 1),
                 size = 1.5,
                 alpha = .5) +
    annotate("curve", 
             arrow = arrow(length = unit(.3, "cm")),
             xend = 1.45, x = 1.75,
             yend = 100.5,  y = 104,
             color = "#922B21",
             curvature = .25) +
    annotate("text",
             label = c("The Group Average"),
             x = 1.76,
             y = 104.5,
             hjust = 0,
             color = "#922B21") +
    annotate("curve", 
             arrow = arrow(length = unit(.3, "cm")),
             xend = 3.15, x = 3.35,
             yend = 72,  y = 67,
             color = viridisLite::viridis(1,begin = .66, end = .66),
             curvature = .25) +
    annotate("text",
             label = c("Individual Values"),
             x = 3.35,
             y = 66,
             hjust = .5,
             color = viridisLite::viridis(1,begin = .66, end = .66)) +
    theme_minimal() +
    theme(panel.grid.major.x = element_blank(),
          axis.line = element_line(color = "lightgrey")) +
    scale_color_viridis_d() +
    labs(x = "",
         y = "Outcome")
  