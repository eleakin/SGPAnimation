#Purpose of this script is to create a gif of points that shift from varying colors and sizes to a uniform color and shape 
# and then add Y and X axes

#set seed
set.seed(20160119)

# Making up data
d <- data.frame(x = rnorm(50), y = rnorm(50), time = sample(100, 50), alpha = 1, 
                size = .25, colour='#6699FF', id = 1:50,
                stringsAsFactors = FALSE)
d2<-d
d2$time <- d$time + 10

d3 <- d2

ts <- list(d, d2,d3)


# Using tweenr
tf <- tween_states(ts, tweenlength = 2, statelength = 1, 
                   ease = c('linear', 'linear'), 
                   nframes = 150)

#Plot x-axis title
xaxisLogo <- data.frame(x=0, y=-2.5, label = 'Prior Achievement', stringsAsFactors = F)
xaxisLogo <- xaxisLogo[rep(1, 152),]
xaxisLogo$.frame <- 1:152

#Plot x-axis line
xaxisLine <- data.frame(x=-2.25, stringsAsFactors = F)
xaxisLine <- xaxisLine[rep(1, 152),1,drop=FALSE]
xaxisLine$.frame <- 1:152

#Plot y-axis title
yaxisLogo <- data.frame(x=-2.5, y=0, label = 'EOY Achievement', stringsAsFactors = F)
yaxisLogo <- yaxisLogo[rep(1, 152),]
yaxisLogo$.frame <- 1:152

#Plot y-axis line
yaxisLine <- data.frame(x=-2.25, stringsAsFactors = F)
yaxisLine <- yaxisLine[rep(1, 152),1,drop=FALSE]
yaxisLine$.frame <- 1:152

#Create dataframe of regression line
reg<-data.frame(x =0.5, y = sample(-10:10,100, replace=TRUE), time = sample(100, 100),
                colour='red', .frame = 1:100,
                stringsAsFactors = FALSE)


# Animate with gganimate
p <- ggplot(data=tf, aes(x=x, y=y)) + 
  geom_text(aes(label = label, frame = .frame), data=xaxisLogo, size = 9) +
  geom_text(aes(label = label, frame = .frame), data=yaxisLogo, size = 9, angle=90) + 
  geom_hline(aes(yintercept=x, frame=.frame), xaxisLine)+
  geom_vline(aes(xintercept=x, frame=.frame), yaxisLine)+
  geom_point(aes(frame=.frame, size=size, alpha =alpha, colour = colour)) + 
  geom_abline(aes(frame=.frame, intercept=x, slope=y, colour=colour, size=size),reg, linetype='dashed', size=1)+
  scale_colour_identity() + 
  scale_alpha(range = c(1, 1), guide = 'none') +
  scale_linetype()+
  
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
gganimate(p, "lmStudents.html", title_frame = F)