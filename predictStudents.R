#Purpose of this script is to create a gif of points on a 2D plane with a sequence of possible regression lines overlaid on top until the 
# true regression line

#set seed
set.seed(20160119)

# Making up data
d <- data.frame(x = rnorm(50), y = rnorm(50), time = sample(100, 50), alpha = 1, 
                size = .25, colour='#6699FF', id = 1:50,
                stringsAsFactors = FALSE)
d2<-d
d2$time <- d$time + 10

#Run regression and predict new set of datapoints to shift into
trueLm<-lm(y~x, d)
d3<-data.frame(x =d[1], y =predict(lm(y~x,d)),
                    colour=rep('#F8766D',50),
                    stringsAsFactors = FALSE)
d4 <- d3




ts <- list(d, d2,d3,d4)


# Using tweenr
tf <- tween_states(ts, tweenlength = 2, statelength = 1, 
                   ease = c('elastic-in-out', 'elastic-in-out'), 
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
yaxisLogo_1 <- data.frame(x=-2.5, y=0, label = 'EOY Achievement', stringsAsFactors = F)
yaxisLogo_1 <- yaxisLogo_1[rep(1, 95),]
yaxisLogo_1$.frame <- 1:95
yaxisLogo_2 <- data.frame(x=-2.5, y=0, label = 'Fitted EOY Achievement', stringsAsFactors = F)
yaxisLogo_2 <- yaxisLogo_2[rep(1, 57),]
yaxisLogo_2$.frame <- 96:152
yaxisLogo<-rbind(yaxisLogo_1, yaxisLogo_2)

#Plot y-axis line
yaxisLine <- data.frame(x=-2.25, stringsAsFactors = F)
yaxisLine <- yaxisLine[rep(1, 152),1,drop=FALSE]
yaxisLine$.frame <- 1:152

# Animate with gganimate
p4 <- ggplot(data=tf, aes(x=x, y=y)) + 
  geom_text(aes(label = label, frame = .frame), data=xaxisLogo, size = 6.5) +
  geom_text(aes(label = label, frame = .frame), data=yaxisLogo, size = 6.5, angle=90) + 
  geom_hline(aes(yintercept=x, frame=.frame), xaxisLine)+
  geom_vline(aes(xintercept=x, frame=.frame), yaxisLine)+
  geom_point(aes(frame=.frame, size=size, alpha =alpha, colour = colour)) + 
  geom_abline(aes(intercept=coef(trueLm)[1], slope=coef(trueLm)[2], colour='#F8766D'),linetype='dashed', size=1.15, alpha=.75)+
  scale_colour_identity() + 
  scale_alpha(range = c(.75, 1), guide = 'none') +
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
#gganimate(p4, "predictStudents.html", title_frame = F)