# Packages used
library(rticles)
library(data.table)
library(dplyr)
library(stringr)
library(rvest)
library(bench)
library(ggbeeswarm)
library(ggrepel)
library(janitor)
library(performance)
library(lobstr)

# Example Data
url_2018 <- "https://www.nbastuffer.com/2017-2018-nba-player-stats/"
url_2019 <- "https://www.nbastuffer.com/2018-2019-nba-player-stats/"
players_2018 <- read_html(url_2018)
players_2019 <- read_html(url_2019)

extract_fun <- function(html){
  tabs <- html_nodes(html, "table")[2] %>% 
    html_table(fill = TRUE)
  tabs[[1]] 
}

player_2018 <- 
  extract_fun(players_2018) %>% 
  mutate(year = 2018,
         AGE = as.numeric(AGE))
player_2019 <- 
  extract_fun(players_2019) %>% 
  mutate(year = 2019)

players <- 
  bind_rows(player_2018, player_2019) %>% 
  clean_names() %>% 
  rename(ppg = ppg_points_points_per_game,
         apg = apg_assists_assists_per_game) %>% 
  data.table()

head(players[, .(full_name, team, year, mpg, ppg, apg)])


# Nesting function for data.table
group_nest_dt <- function(dt, ..., .key = "data"){
  stopifnot(is.data.table(dt))
  
  by <- substitute(list(...))
  
  dt <- dt[, list(list(.SD)), by = eval(by)]
  setnames(dt, old = "V1", new = .key)
  dt
}

head(group_nest_dt(players, team))
head(group_nest(players, team))

# Speed/memory comparisons
players_tbl <- as_tibble(players)
first <- bench::mark(group_nest = group_nest(players_tbl, team), 
                     time_unit = "us",
                     iterations = 200) %>% 
  mutate(expression = paste(expression))
second <- bench::mark(group_nest_dt = group_nest_dt(players, team), 
                      time_unit = "us",
                      iterations = 200) %>% 
  mutate(expression = paste(expression))

# Unnest function
unnest_vec_dt <- function(dt, cols, id, nam){
  stopifnot(is.data.table(dt))
  
  by <- substitute(id)
  cols <- substitute(unlist(cols, recursive = FALSE, use.names = FALSE))
  
  dt <- dt[, eval(cols), by = eval(by)]
  setnames(dt, old = paste0("V", 1:length(nam)), new = nam)
  dt
}

# Plotting results
theme_set(theme_minimal() +
            theme(panel.grid.major.x = element_blank(),
                  legend.position = "none"))
p <- rbind(first, second) %>%
  data.table() %>% 
  unnest_vec_dt(cols = list(time), id = list(expression), nam = "time") %>% 
  ggplot(aes(x = expression, 
             y = time, 
             color = expression, 
             fill = expression)) +
  geom_beeswarm(size = 1.5, alpha = .8) +
  labs(y = expression(paste("Milliseconds (", log[10], " Scale)")),
       x = "") +
  scale_color_viridis_d(end = 1, 
                        begin = .2)
ggsave(here::here("assets/rstudio_conf_2020/ArXiv/timings_manuscript.png"), plot = p,
       height = 4, width = 4)

head(group_nest_dt(players, team, year))

# Example data analyses
players_nested <- group_nest_dt(players, team, year)
players_nested[, ppg_apg    := purrr::map(data, ~lm(ppg ~ apg, data = .x))]
players_nested[, r2_list    := purrr::map(ppg_apg, ~performance::r2(.x))]
players_nested[, r2_ppg_apg := purrr::map_dbl(r2_list, ~.x[[1]])]
head(players_nested)

library(ggrepel)
theme_set(theme_minimal() +
            theme(panel.grid.major.x = element_blank(),
                  legend.position = "none"))

ex_fig <- players_nested %>% 
  dcast(team ~ year, value.var = "r2_ppg_apg") %>% 
  ggplot(aes(`2018`, `2019`, group = team)) +
  geom_point() +
  geom_text_repel(aes(label = team)) +
  geom_abline(slope = 1) +
  coord_fixed(ylim = c(0,1),
              xlim = c(0,1))
ggsave(here::here("assets/rstudio_conf_2020/ArXiv/ex_fig.png"), plot = ex_fig,
       height = 4, width = 4)


# Unnest function as displayed in article
unnest_dt <- function(dt, col, id){
  stopifnot(is.data.table(dt))
  
  by <- substitute(id)
  col <- substitute(unlist(col, recursive = FALSE))
  
  dt[, eval(col), by = eval(by)]
}

# Unnesting with data.table
players_unnested <- unnest_dt(players_nested, 
                              col = data, 
                              id = list(team, year))
players_unnested[, .(team, year, full_name, pos, age, gp, mpg)]

# Comparison of speed/memory for unnest
players_nested_tbl <- group_nest(players,team)
group_nested_dt <- group_nest_dt(players,team)
firstu <- bench::mark(unnest = tidyr::unnest(players_nested_tbl, cols = data), 
                      time_unit = "us",
                      iterations = 200) %>% 
  mutate(expression = paste(expression))
secondu <- bench::mark(unnest_dt = unnest_dt(group_nested_dt, 
                                             col = data, 
                                             id = list(team)), 
                       time_unit = "us",
                       iterations = 200) %>% 
  mutate(expression = paste(expression))

# Plot results
theme_set(theme_minimal() +
            theme(panel.grid.major.x = element_blank(),
                  legend.position = "none"))
p2 <- 
  rbind(firstu, secondu) %>%
  data.table() %>% 
  unnest_vec_dt(cols = list(time), id = list(expression), nam = "time") %>% 
  ggplot(aes(x = expression, 
             y = time, 
             color = expression, 
             fill = expression)) +
  geom_beeswarm(size = 1.5, alpha = .8) +
  labs(y = expression(paste("Milliseconds (", log[10], " Scale)")),
       x = "") +
  scale_color_viridis_d(end = 1, 
                        begin = .2)
ggsave(here::here("assets/rstudio_conf_2020/ArXiv/timings_unnest_manuscript.png"), plot = p2,
       height = 4, width = 4)


# Unnesting vector
unnest_vec_dt <- function(dt, cols, id, name){
  stopifnot(is.data.table(dt))
  
  by <- substitute(id)
  cols <- substitute(unlist(cols, 
                            recursive = FALSE))
  
  dt <- dt[, eval(cols), by = eval(by)]
  setnames(dt, old = paste0("V", 1:length(name)), new = name)
  dt
}


unnest_vec_dt(players_nested, 
              cols = list(r2_list), 
              id = list(team, year), 
              name = "r2")


# Memory usage across formats
# Wide
wide_format <- data.table(id = 1:1e6,
                          x1 = rnorm(1e6),
                          x2 = rnorm(1e6),
                          y1 = rnorm(1e6),
                          y2 = rnorm(1e6),
                          group = rbinom(1e6, 1, .5))
nested_wide_format <- group_nest_dt(wide_format, group)

# Long
long_format <- melt.data.table(wide_format, 
                               id.vars = c("id", "group"),
                               measure.vars = c("x1", "x2", "y1", "y2"))
nested_long_format <- group_nest_dt(long_format, group)

data.table("Format" = c("Wide Format", 
                        "Nested Wide Format", 
                        "Long Format", 
                        "Nested Long Format"),
           "Memory (MB)" = 
             (lobstr::obj_sizes(wide_format, 
                                nested_wide_format, 
                                long_format, 
                                nested_long_format)/1e6)
) %>% 
  xtable::xtable(caption = "Memory usage for each format of the same data", 
                 label = "memtab",
                 digits = 1) %>% 
  print(caption.placement = "top",
        include.rownames = FALSE,
        booktabs = TRUE,
        comment = FALSE)


