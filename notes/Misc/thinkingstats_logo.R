## Logo


library(tidyverse)
library(ggjoy)
library(furniture)

set.seed(84321)
df = data.frame(
  "ID" = 1:1000,
  "A" = rnorm(1000, -.5, 1.8) + rbinom(1000, 50, .3),
  "B" = rnorm(1000, 10, 2) + rbinom(1000, 50, .2),
  "C" = rnorm(1000, 15, 3) + rbinom(1000, 50, .2),
  "D" = rnorm(1000, 15, 3) + rbinom(1000, 50, .2),
  "E" = rnorm(1000, 10, 5) + rbinom(1000, 100, .2)
)

df_long = long(df,
               c("A", "B", "C", "D", "E"),
               v.names = c("value"),
               timevar = "variable") %>%
  mutate(variable = factor(variable))

ggplot(df_long, aes(value, variable, fill = variable, color = variable)) +
  geom_joy2(alpha = .65) +
  theme_bw() +
  scale_color_manual(values = c("coral2", "darkorchid2", "chartreuse2", "dodgerblue2", "firebrick3"),
                     guide = FALSE) +
  scale_fill_manual(values = c("coral2", "darkorchid2", "chartreuse2", "dodgerblue2", "firebrick3"),
                    guide = FALSE) +
  labs(x = "",
       y = "") +
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.border = element_blank(),
        panel.background = element_rect(fill = "#2E4053"),
        axis.line = element_blank(),
        panel.grid.major.x = element_line(color = "grey50", size = .1),
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_line(color = "grey50", size = .05)) +
  coord_cartesian(ylim = c(1,5.75))

