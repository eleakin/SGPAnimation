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

tweenlogo <- data.frame(x=0.5, y=0.5, label = 'tweenr', stringsAsFactors = F)
tweenlogo <- tweenlogo[rep(1, 60),]
tweenlogo$.frame <- 316:375

# Using tweenr
tf <- tween_states(ts, tweenlength = 2, statelength = 1, 
                   ease = c('cubic-in-out', 'elastic-out'), 
                   nframes = 375)

# Animate with gganimate
p <- ggplot(data=tf, aes(x=x, y=y)) + 
  #geom_text(aes(label = label, frame = .frame), data=tweenlogo, size = 13) + 
  geom_point(aes(frame=.frame, size=size, alpha =alpha, colour = colour)) + 
  scale_colour_identity() + 
  scale_alpha(range = c(1, 1), guide = 'none') +
  scale_size(range = c(2, 15), guide = 'none') + 
  theme_bw()
animation::ani.options(interval = 1/15)
gganimate(p, "dancing ball.html", title_frame = F)
