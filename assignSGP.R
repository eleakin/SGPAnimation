#Purpose of this script is to create a gif of a reference student and corresponding peer points then rearrange the points base on 
#the actual EOY score.
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

top<-d1[d1$id %in% c(13:22),]
topdf<-rbind(top,top)

bottom<-d1[d1$id %in% c(24:33),]
bottomdf<-rbind(bottom,bottom)

d1<-rbind(topdf,d1[d1$id==23,],bottomdf)

d1$id<-1:41

d1$x<-d1$x-0.5


#Single out an observation to be the reference student
#Single out the pool of reference students and peers
d2<-d1
#Change color of reference student
d2[d2$id==21,]$colour<-"#00BD5C"

#Change color of peers
d2[d2$id!=21,]$colour<-"#C77CFF"

#Create dataframe of points that lie on vertical line
d3<-data.frame(y=seq(-0.2, 0.2, .4/40), x=rep(-2,41), colour=rep('#C77CFF',41), alpha=1,
               size = .25, id = 1:41)

#Reidentify reference student
d3$colour<-ifelse(d3$id==21, "#00BD5C", '#C77CFF')


#Shift points in d3 to create a true EOY score
d4<-data.frame(y=sample(seq(-0.2, 0.2, .4/40),41), x=rep(-.25,41), colour=rep('#C77CFF',41), alpha=1,
               size = .25, id = 1:41)

#Reidentify reference student
d4$colour<-ifelse(d4$id==21, "#00BD5C", '#C77CFF')

ts <- list(d2, d3, d4)

# Using tweenr
tf <- tween_states(ts, tweenlength = 2, statelength = 1, 
                   ease = c('cubic-in-out', 'cubic-in-out','linear'), 
                   nframes = 300)

#Plot x-axis title
xaxisLogo <- data.frame(x=-1, y=-.21, label = 'Prior Achievement', stringsAsFactors = F)
xaxisLogo <- xaxisLogo[rep(1, 300),]
xaxisLogo$.frame <- 1:50

#Plot x-axis line
xaxisLine <- data.frame(x=-.2, stringsAsFactors = F)
xaxisLine <- xaxisLine[rep(1, 300),1,drop=FALSE]
xaxisLine$.frame <- 1:50

#Plot y-axis title
yaxisLogo <- data.frame(x=-2.75, y=0, label = 'Fitted EOY Achievement', stringsAsFactors = F)
yaxisLogo <- yaxisLogo[rep(1, 300),]
yaxisLogo$.frame <- 1:300

#Plot y-axis line
yaxisLine <- data.frame(x=-2.5, stringsAsFactors = F)
yaxisLine <- yaxisLine[rep(1, 300),1,drop=FALSE]
yaxisLine$.frame <- 1:300

#Plot text for transformation
betweenLogo <- data.frame(x=-1.15, y=0, label = 'Rank on Actual\n EOY Achievement', stringsAsFactors = F)
betweenLogo <- betweenLogo[rep(1, 161),]
betweenLogo$.frame <- 140:300

#Plot y-axis line for actual EOY Achievement
transLine <- data.frame(x=0, stringsAsFactors = F)
transLine <- transLine[rep(1, 121),1,drop=FALSE]
transLine$.frame <- 180:300

#Plot y-axis line for actual EOY Achievement
transLogo <- data.frame(x=0.25, y=0, label = 'Actual EOY Achievement', stringsAsFactors = F)
transLogo <- transLogo[rep(1, 121),]
transLogo$.frame <- 180:300


#Plot SGP Result
sgp <- data.frame(x=-0.5, y=0.17, label = 'SGP = 92', stringsAsFactors = F)
sgp <- sgp[rep(1, 42),]
sgp$.frame <- 259:300

# Animate with gganimate
p6 <- ggplot(data=tf, aes(x=x, y=y)) + 
  geom_text(aes(label = label, frame = .frame), data=xaxisLogo, size = 6.5) +
  geom_text(aes(label = label, frame = .frame), data=yaxisLogo, size = 6.5, angle=90) + 
  geom_text(aes(label = label, frame = .frame), data=transLogo, size = 6.5, angle=90) + 
  geom_text(aes(label = label, frame = .frame), data=betweenLogo, size = 6.5) +
  geom_text(aes(label = label, frame = .frame), data=sgp, size = 6.5) + 
  geom_hline(aes(yintercept=x, frame=.frame), xaxisLine)+
  geom_vline(aes(xintercept=x, frame=.frame), yaxisLine)+
  geom_vline(aes(xintercept=x, frame=.frame), transLine)+
  geom_point(aes(frame=.frame, size=size, alpha =alpha, colour = colour)) + 
#  geom_abline(aes(intercept=coef(trueLm)[1], slope=coef(trueLm)[2], colour='#F8766D'), size=1.15, alpha=.75)+
#  annotate("rect", xmin=-0.35, xmax=0.4, ymin=-.2, ymax=.2, alpha=0.25)+
#  annotate("rect", xmin=-1.1, xmax=-0.35, ymin=-.2, ymax=.2, alpha=0.25, frame=50:152)+
  scale_colour_identity() + 
#  scale_alpha(range = c(0.2, 1), guide = 'none') +
  scale_linetype()+
  expand_limits(x=c(-2.75,.5))+
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
#gganimate(p, "SGP/assignSGP.html", title_frame = F)
