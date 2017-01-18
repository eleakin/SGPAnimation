#Purpose of this script is to create a gif of points of varying colors and size appearing randomly on a plane

#set function for default ggplot colors
gg_color_hue <- function(n) {
  hues = seq(15, 375, length = n + 1)
  hcl(h = hues, l = 65, c = 100)[1:n]
}

#set seed
set.seed(20160118)

# Making up data
d <- data.frame(x = rnorm(50), y = rnorm(50), time = sample(100, 50), alpha = 0, 
                size = 10, colour=gg_color_hue(50), id = 1:50,
                stringsAsFactors = FALSE)
d2 <- d
d2$time <- d$time + 10
d2$alpha <- 1
d2$size <- 1
d2$colour<-"#6699FF"

ts <- list(d, d2)

# Using tweenr
tf <- tween_states(ts, tweenlength = 2, statelength = 1, 
                   ease = c('linear', 'linear'), 
                   nframes = 150)

#Plot x-axis title
xaxisLogo <- data.frame(x=0, y=-2.5, label = 'Prior Achievement', stringsAsFactors = F)
xaxisLogo <- xaxisLogo[rep(1, 62),]
xaxisLogo$.frame <- 90:151

#Plot x-axis line
xaxisLine <- data.frame(x=-2.25, stringsAsFactors = F)
xaxisLine <- xaxisLine[rep(1, 62),1,drop=FALSE]
xaxisLine$.frame <- 90:151

#Plot y-axis title
yaxisLogo <- data.frame(x=-2.5, y=0, label = 'EOY Achievement', stringsAsFactors = F)
yaxisLogo <- yaxisLogo[rep(1, 50),]
yaxisLogo$.frame <- 102:151

#Plot y-axis line
yaxisLine <- data.frame(x=-2.25, stringsAsFactors = F)
yaxisLine <- yaxisLine[rep(1, 50),1,drop=FALSE]
yaxisLine$.frame <- 102:151


# Animate with gganimate
p <- ggplot(data=tf, aes(x=x, y=y)) + 
  geom_text(aes(label = label, frame = .frame), data=xaxisLogo, size = 9) +
  geom_text(aes(label = label, frame = .frame), data=yaxisLogo, size = 9, angle=90) + 
  geom_hline(aes(yintercept=x, frame=.frame), xaxisLine)+
  geom_vline(aes(xintercept=x, frame=.frame), yaxisLine)+
  geom_point(aes(frame=.frame, size=size, alpha =alpha, colour = colour)) + 
  scale_colour_identity() + 
  scale_alpha(range = c(1, 1), guide = 'none') +
  scale_size(range = c(2, 15), guide = 'none') + 
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

animation::ani.options(interval = 1/15)
gganimate(p, "plotStudents.html", title_frame = F)