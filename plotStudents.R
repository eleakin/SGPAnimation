#Purpose of this script is to create a gif of points that shift from varying colors and sizes to a uniform color and shape 
# and then add Y and X axes

#set function for default ggplot colors
gg_color_hue <- function(n) {
  hues = seq(15, 375, length = n + 1)
  hcl(h = hues, l = 65, c = 100)[1:n]
}
colourKeep<-c("#F37B59","#FC717F","#F066EA","#FF689F","#00A5FF","#BF80FF","#BB9D00","#AC88FF",
              "#E7861B", "#DC71FA", "#5BB300", "#529EFF", "#C59900", "#00BBDB", "#00BFC4",
              "#E76BF3","#00BA42", "#7997FF", "#FC61D5", "#00BC59", "#00C08D", "#00BF7D",
              "#AFA100", "#00BE6C","#00B0F6", "#00B4EF", "#00BDD0", "#00B81F", "#72B000",
              "#00C1AA", "#39B600", "#00ABFD","#FF62BC", "#FF6C90", "#A3A500", "#00C19C",
              "#ED8141", "#D89000", "#CF78FF", "#85AD00","#F763E0", "#00C0B8", "#95A900",
              "#9590FF", "#CF9400", "#FF61C9", "#F8766D", "#00B8E5","#E08B00", "#FF65AE")
#set seed
set.seed(20160119)

# Making up data
d <- data.frame(x = rnorm(50), y = rnorm(50), time = sample(100, 50), alpha = 1, 
                size = sample(c(3,5,10),50, replace=TRUE), colour=colourKeep, id = 1:50,
                stringsAsFactors = FALSE)

#restrict y values that are too negative
d$y<-ifelse(d$y<(-2.2),-2, d$y)
d2 <- d
d2$time <- d$time + 10
d2$alpha <- 1
d2$size <- 1
d2$colour<-"#6699FF"
d3 <- d2

ts <- list(d, d2,d3)

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
p2 <- ggplot(data=tf, aes(x=x, y=y)) + 
  geom_text(aes(label = label, frame = .frame), data=xaxisLogo, size = 6.5) +
  geom_text(aes(label = label, frame = .frame), data=yaxisLogo, size = 6.5, angle=90) + 
  geom_hline(aes(yintercept=x, frame=.frame), xaxisLine)+
  geom_vline(aes(xintercept=x, frame=.frame), yaxisLine)+
  geom_point(aes(frame=.frame, size=size, alpha =alpha, colour = colour)) + 
  scale_colour_identity() + 
  scale_alpha(range = c(.5, 1), guide = 'none') +
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
#gganimate(p2, "Plot/plotStudents.html", title_frame = F)