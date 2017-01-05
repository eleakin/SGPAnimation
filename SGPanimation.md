SGPanimation
================

Purpose
-------

Purpose of this book is to develop an animation that takes advantage of **gganimate**, **tweenr**, and other R packages. The animation will hopefully provide an intuitive animation for how student growth percentiles are created in the NYC Department of Education.

Load Packages
-------------

``` r
library(ggplot2)
library(gganimate)
library(ggforce)
library(tweenr)
```

Create Data
-----------

The data created below is based on the **tweenr** Github example

``` r
# Making up data
t <- data.frame(x=seq(0:11), y=rep(0,12), colour = 'forestgreen', size=0.5, alpha = 1, 
                stringsAsFactors = FALSE)
t$colour<-ifelse(t$x==5, 'steelblue',t$colour)
#t <- t[rep(1, 12),]
#t$alpha[2:12] <- 0
t2 <- t
t2$y <- 1
t2$x<-0
t2$colour <- 'firebrick'
t2$size<-10
t3 <- t2
t3$x <- 1
t3$colour <- 'steelblue'
t4 <- t3
t4$y <- 0
t4$colour <- 'goldenrod'
t9 <- t
ts <- list(t, t2)
```

Apply **tweenr** Function and Plot
----------------------------------

For the time being, I am just trying to wrap my head around using **tweenr** package. The gola is to plot 10 distinct points that then convert into a larger point.

Still having trouble plotting the animation file in markdown and getting the plot to loop/run quickly.

``` r
# Using tweenr
tf <- tween_states(ts, tweenlength = 2, statelength = 1, 
                   ease = c('cubic-in-out', 'elastic-out'), 
                   nframes = 175)

# Animate with gganimate
p <- ggplot(data=tf, aes(x=x, y=y)) + 
  #geom_text(aes(label = label, frame = .frame), data=tweenlogo, size = 13) + 
  geom_point(aes(frame=.frame, size=size, alpha =alpha, colour = colour)) + 
  scale_colour_identity() + 
  scale_alpha(range = c(1, 1), guide = 'none') +
  scale_size(range = c(2, 15), guide = 'none') + 
  theme_bw()
```

    ## Warning: Ignoring unknown aesthetics: frame

``` r
animation::ani.options(interval = 1/15)
gganimate(p)
```

<video   controls loop>
<source src="SGPanimation_files/figure-markdown_github/tweenr-.webm" />
<p>
video of chunk tweenr
</p>
</video>
