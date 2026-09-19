## From https://chichacha.netlify.com/2018/12/22/bubble-packed-chart-with-r-using-packcircles-package/

library(tidyverse) ## I need tidyverse for everything :) 
library(imager) ## to create data frame from image
library(scales) ## rescale function is so handy!
library(packcircles) ## making circle packing easy! 

## Step 1
#im <- load.image("assets/images/avatar_2019.png") # avatar
#im <- load.image("assets/images/earth.jpg") # avatar
#im <- load.image("assets/images/succulent.png") # avatar

## if you want to take a look at image.. :) 
plot(im)

## Convert Image into Data Frame
im.df.colour <- im %>%
  as.data.frame(wide="c") %>% ## so that rgb value is in separate column.
  rename(im_x=x,im_y=y) %>%
  mutate(hex=rgb(c.1,c.2,c.3))

## Step 2 using circleProgressiveLayout function.
## Generate circle packing layout using rbeta distribution as size of circles
pack_layout <- circleProgressiveLayout(rbeta(10000,1,4), sizetype='area') %>% 
  ## Step 3 - I want to figure out what colour to use, so I want layout & image df to have same scaling. 
  mutate(im_x=floor(rescale(x,to=range(im.df.colour$im_x))),  
         im_y=floor(rescale(y,to=range(im.df.colour$im_y))),
         ## also generate id, so i can join the data frame easily later!
         id=row_number()) %>% 
  inner_join(im.df.colour %>% select(im_x,im_y,hex), by=c("im_x","im_y"))


## Step 4 
## Using the layout above create data frame using circleLayoutVertices function so that you can plot circle using ggplot2
data_gg <- circleLayoutVertices(pack_layout) %>% 
  inner_join(pack_layout %>% select(id,hex), by=c("id"))

## Step 5
data_gg %>% 
  ggplot(aes(x=x,y=y,group=id)) +
  geom_polygon(aes(fill=hex)) +  
  scale_fill_identity() + 
  coord_equal() +
  scale_y_reverse() +  ## you need to reverse y-axis
  theme_void() +
  theme(panel.background = element_rect(fill = "#FEF9E7"))
