#Purpose of this script is to create a gif of points of varying colors and size appearing randomly on a plane

#set seed
set.seed(20160118)

# Making up data
d <- data.frame(x = rnorm(50), y = rnorm(50), time = sample(100, 50), alpha = 0, 
                size = 1, ease = 'elastic-out', id = 1:50, 
                stringsAsFactors = FALSE)
d2 <- d
d2$time <- d$time + 10
d2$alpha <- 1
d2$size <- 3
d2$ease <- 'linear'

d3 <- d2
d3$time <- d2$time + sample(50:100, 50)
d3$size = 10
d3$ease <- 'bounce-out'

d4 <- d3
d4$time <- max(d4$time)

df <- rbind(d, d2, d3, d4)

# Using tweenr
dt <- tween_elements(df, 'time', 'id', 'ease', nframes = 150)

# Animate with gganimate
p <- ggplot(data = dt) + 
  geom_point(aes(x=x, y=y, size=size, alpha=alpha, frame= .frame, colour=factor(x)))+ 
  scale_size(range = c(0.1, 20), guide = 'none') + 
  scale_alpha(range = c(0, 1), guide = 'none') +
  theme(axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        legend.position="none",
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        plot.background=element_blank())

animation::ani.options(interval = 1/24)
#Save
gganimate(p, 'studentAppear.html', title_frame = F)
