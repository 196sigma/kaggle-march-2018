rm(list=ls())
m1 <- read.csv('data/results/predictions-03102018-a.csv', stringsAsFactors = FALSE)
m2 <- read.csv('data/results/predictions-03102018-b.csv', stringsAsFactors = FALSE)
m3 <- read.csv('data/results/predictions-03102018-c.csv', stringsAsFactors = FALSE)
m4 <- read.csv('data/results/predictions-03102018-d.csv', stringsAsFactors = FALSE)
m5 <- read.csv('data/results/predictions-03102018-e.csv', stringsAsFactors = FALSE)

models.mat <- merge(m1, m2, by = "id")

models.mat <- merge(models.mat, m3, by = "id")

models.mat <- merge(models.mat, m4, by = "id")

models.mat <- merge(models.mat, m5, by = "id")

names(models.mat) <- c("id", "m1", "m2", "m3", "m4", "m5")

cor(models.mat[,c("m1", "m2", "m3", "m4", "m5")])
plot(density(models.mat$m1))
lines(density(models.mat$m2))
lines(density(models.mat$m3))
lines(density(models.mat$m4))
lines(density(models.mat$m5))
summary(models.mat)

## test effect of upward bound on win probability
max.winprob <- .8

plot(density(models.mat$m1))
lines(density(pred1), col='red')
source('code/log-loss-evaluation.R')
f <- function(x){
  pv <- models.mat[c("id", "m1")]
  pv$pred <- pmin(x, models.mat$m1)
  logloss.evaluate("", pv)
}
f2 <- function(x){
  pv <- models.mat[c("id", "m1")]
  pv$pred <- pmax(x, models.mat$m1)
  logloss.evaluate("", pv)
}
max.winprob.list <- seq(0.75,.99, .01)
min.winprob.list <- seq(0.01,.5, .01)
x <- c()
for(i in min.winprob.list) x <- c(x, f2(i))
plot(min.winprob.list, x, type='l')
abline(h = 0.57)
