#Purpose of this script is to create a gif of points on a 2D plane with a sequence of possible regression lines overlaid on top until the 
# true regression line

#set seed
set.seed(20160119)

# Making up data
d <- data.frame(x = rnorm(50), y = rnorm(50), alpha=1,
                size = .25, colour='#6699FF', id = 1:50,
                stringsAsFactors = FALSE)
#Run regression and predict new set of datapoints to shift into
trueLm<-lm(y~x, d)
d1<-data.frame(x=seq(-2,2,.075), colour=rep('#F8766D',54), alpha=1,
               size = .25, id = 1:54,
               stringsAsFactors = FALSE)
d1$y<-predict(trueLm, d1)
d2<-d1


#Single out an observation to be the reference student
d3<-d2
point<-d3[23,c("x","y")]

#Make points transparent
d4<-d3
d4$alpha<-0.1

ts <- list(d1, d3, d4)


# Using tweenr
tf <- tween_states(ts, tweenlength = 2, statelength = 1, 
                   ease = c('cubic-in-out', 'cubic-in-out','cubic-in-out'), 
                   nframes = 300)

#Single out an observation to be the reference student and change color
tf$colour<-ifelse(tf$id==23 & tf$.frame>25,'#00BD5C','#F8766D')
tf$alpha<-ifelse(tf$id==23 & tf$.frame>25,1,tf$alpha)

#Single out the ten points below the reference student (for later: make this more programmtic) 
for (i in 22:13){
  if (i==22){j=0}
  j=j+1
  frameiter<-30+(10*j)
  tf$colour<-ifelse(tf$id==i & tf$.frame>frameiter,'#C77CFF',tf$colour)
  tf$alpha<-ifelse(tf$id==i & tf$.frame>frameiter,1,tf$alpha)
  
  print(frameiter)
}
#Add text for 50 students below
below <- data.frame(x=0, y=-.21, label = 'Prior Achievement', stringsAsFactors = F)
below <- below[rep(1, 300),]
below$.frame <- 1:300

for (i in 24:33){
  if (i==24){j=0}
  j=j+1
  frameiter<-140+(10*j)
  tf$colour<-ifelse(tf$id==i & tf$.frame>frameiter,'#C77CFF',tf$colour)
  tf$alpha<-ifelse(tf$id==i & tf$.frame>frameiter,1,tf$alpha)
  
  print(frameiter)
}

#Plot x-axis title
xaxisLogo <- data.frame(x=0, y=-.21, label = 'Prior Achievement', stringsAsFactors = F)
xaxisLogo <- xaxisLogo[rep(1, 300),]
xaxisLogo$.frame <- 1:300

#Plot x-axis line
xaxisLine <- data.frame(x=-.2, stringsAsFactors = F)
xaxisLine <- xaxisLine[rep(1, 300),1,drop=FALSE]
xaxisLine$.frame <- 1:300

#Plot y-axis title
yaxisLogo <- data.frame(x=-2.5, y=0, label = 'Fitted EOY Achievement', stringsAsFactors = F)
yaxisLogo <- yaxisLogo[rep(1, 300),]
yaxisLogo$.frame <- 1:300

#Plot y-axis line
yaxisLine <- data.frame(x=-2.25, stringsAsFactors = F)
yaxisLine <- yaxisLine[rep(1, 300),1,drop=FALSE]
yaxisLine$.frame <- 1:300

#Plot rectangle to highlight 50 peers above and below
#below<-data.frame(x=)

# Animate with gganimate
p <- ggplot(data=tf, aes(x=x, y=y)) + 
  geom_text(aes(label = label, frame = .frame), data=xaxisLogo, size = 9) +
  geom_text(aes(label = label, frame = .frame), data=yaxisLogo, size = 9, angle=90) + 
  geom_hline(aes(yintercept=x, frame=.frame), xaxisLine)+
  geom_vline(aes(xintercept=x, frame=.frame), yaxisLine)+
  geom_point(aes(frame=.frame, size=size, alpha =alpha, colour = colour)) + 
  geom_abline(aes(intercept=coef(trueLm)[1], slope=coef(trueLm)[2], colour='#F8766D'), size=1.15, alpha=.75)+
#  annotate("rect", xmin=-0.35, xmax=0.4, ymin=-.2, ymax=.2, alpha=0.25)+
#  annotate("rect", xmin=-1.1, xmax=-0.35, ymin=-.2, ymax=.2, alpha=0.25, frame=50:152)+
#  annotate("segment", x =-1.1, xend =-0.425, y = -0.0868-.03, yend = -0.039-.03, arrow=arrow(ends="both", angle=90, length=unit(.2,"cm"))) +
  scale_colour_identity() + 
  scale_alpha(range = c(0.1, 1), guide = 'none') +
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
gganimate(p, "Peers/findPeers.html", title_frame = F)