## Reginald Edwards
## CREATED: 1 March 2018
## MODIFIED:
## DESCRIPTION: Compute the probability that a higher seeded team beats a lower
## seeded opopnent from historical data. This is exploratory in nature.
###############################################################################

rm(list=ls())

## load training data
load('data/working/training.RData')

upsets.by.season <- aggregate(upset ~ season, data = X.train, FUN = mean)
names(upsets.by.season) <- c('season', 'pct.upsets')

x <- aggregate(upset ~ season, data = X.train, FUN = sum)
names(x) <- c('season', 'n.upsets')
upsets.by.season <- merge(upsets.by.season, x)

avg.upsets <- mean(X.train$upset)
avg.n.upsets <- mean(upsets.by.season$n.upsets)

barplot(upsets.by.season$n.upsets)
abline(h = avg.n.upsets)

low.seed.win.prob <- 0.7014602

## Validate model with seed-win probability in-sample (i.e. on 1985-2013 data)
X.train$pred <- .5
log.loss(X.train$y, X.train$pred)

X.train$pred <- ifelse(X.train$seed1 < X.train$seed2, low.seed.win.prob, 
                       1-low.seed.win.prob)
log.loss(X.train$y, X.train$pred)

###############################################################################
## Test model with seed-win probability on [2014-2017] data
## load test data
load('data/working/testing.RData')

X.test$pred <- ifelse(X.test$seed1 < X.test$seed2, low.seed.win.prob, 
  1-low.seed.win.prob)
write.csv(X.test[,c('id', 'pred')], file = "data/working/seed_win_predictions.csv")

source('code/log-loss-evaluation.R')
logloss.evaluate("data/working/seed_win_predictions.csv")
