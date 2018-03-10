## Reginald Edwards
## CREATED: 01 March 2018
## MODIFIED: 09 March 2018
## DESCRIPTION: Compute the probability that a higher seeded team beats a lower
## seeded opopnent from historical data. This is exploratory in nature.
###############################################################################

rm(list=ls())
gc()

## load training data
load('data/working/compact_results.RData')
load('data/working/train_set.RData')

upsets.by.season <- aggregate(upset ~ season, data = train.set, FUN = mean)
names(upsets.by.season) <- c('season', 'pct.upsets')

x <- aggregate(upset ~ season, data = train.set, FUN = sum)
names(x) <- c('season', 'n.upsets')
upsets.by.season <- merge(upsets.by.season, x)

avg.upsets <- mean(train.set$upset)
avg.n.upsets <- mean(upsets.by.season$n.upsets)

barplot(upsets.by.season$n.upsets)
abline(h = avg.n.upsets)

low.seed.win.prob <- 0.7014602

## Validate model with seed-win probability in-sample (i.e. on 1985-2013 data)
train.set$pred <- .5
log.loss(train.set$y, train.set$pred)

train.set$pred <- ifelse(train.set$seed1 < train.set$seed2, low.seed.win.prob, 
                       1-low.seed.win.prob)
log.loss(train.set$y, train.set$pred)

###############################################################################
## Test model with seed-win probability on [2014-2017] data
## load test data
load('data/working/testing.RData')

X.test$pred <- ifelse(X.test$seed1 < X.test$seed2, low.seed.win.prob, 
  1-low.seed.win.prob)
write.csv(X.test[,c('id', 'pred')], file = "data/working/seed_win_predictions.csv")

source('code/log-loss-evaluation.R')
logloss.evaluate("data/working/seed_win_predictions.csv")
