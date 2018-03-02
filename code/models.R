## Reginald Edwards
## CREATED: 1 March 2018
## MODIFIED:
## DESCRIPTION: Compute the probability regular season win percentages and use
## ase probability of tournament win
###############################################################################

source('code/prep-data.R')
source('code/add-features.R')

rm(list=ls())

load(file = 'data/working/training.RData')
load(file = 'data/working/testing.RData')

source('code/log-loss-evaluation.R')

## Seed-win probabilities

## Regular season record
m <- glm(y ~ seed1.lower + win.pct1 + win.pct2 + wins1 + games1 + wins2 + games2, data = X.train, family = "binomial"); summary(m)
X.train$pred <- predict(m, X.train, type = "response")
X.train$pred <- pmax(pmin(0.999, X.train$pred), 0.001)
log.loss(X.train$y, X.train$pred)

X.test$pred <- predict(m, X.test, type = "response")
X.test$pred <- pmax(pmin(0.999, X.test$pred), 0.001)
write.csv(X.test[,c('id','pred')], file = 'data/working/record_win_predictions.csv', row.names = FALSE, quote = FALSE)
logloss.evaluate('data/working/record_win_predictions.csv')
