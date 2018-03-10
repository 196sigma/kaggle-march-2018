## Reginald Edwards
## CREATED: 02 March 2018
## MODIFIED: 09 March 2018
## DESCRIPTION: run various models.
##  Features:
##    - seed
##    - reg season games played
##    - reg season win percentage
##    - NCAA strength of schedule (SoS)
###############################################################################

rm(list=ls())
gc()
load(file = 'data/working/train_set.RData')
load(file = 'data/working/test_set.RData')

source('code/log-loss-evaluation.R')

## Seed-win probabilities

## Regular season record
m <- glm(y ~ seed1.lower + win.pct1 + win.pct2 + wins1 + games1 + wins2 + 
  games2, data = train.set, family = "binomial"); summary(m)
train.set$pred <- predict(m, train.set, type = "response")
train.set$pred <- pmax(pmin(0.999, train.set$pred), 0.001)
log.loss(train.set$y, train.set$pred)

test.set$pred <- predict(m, test.set, type = "response")
test.set$pred <- pmax(pmin(0.999, test.set$pred), 0.001)
write.csv(test.set[,c('id','pred')], 
          file = 'data/working/record_win_predictions.csv', 
          row.names = FALSE, quote = FALSE)
logloss.evaluate('data/working/record_win_predictions.csv')

## Interaction terms 
m2 <- glm(y ~ seed1.lower + win.pct1 + win.pct2 + wins1 + games1 + wins2 + 
            games2 + seed1.lower*win.pct1 + seed1.lower*win.pct2 + seed1.lower*wins1 + 
            seed1.lower*games1 + seed1.lower*wins2 + seed1.lower*games2, data = train.set, 
          family = "binomial"); summary(m2)
train.set$pred <- predict(m2, train.set, type = "response")
train.set$pred <- pmax(pmin(0.999, train.set$pred), 0.001)
log.loss(train.set$y, train.set$pred)

test.set$pred <- predict(m2, test.set, type = "response")
test.set$pred <- pmax(pmin(0.999, test.set$pred), 0.001)
write.csv(test.set[,c('id','pred')], file = 'data/working/record_win_predictions.csv', row.names = FALSE, quote = FALSE)
logloss.evaluate('data/working/record_win_predictions.csv')

## models with strength of schedule
train.set <- na.omit(train.set)
m3 <- glm(y ~ seed1.lower + win.pct1 + win.pct2 + wins1 + games1 + wins2 + 
            games2 + seed1.lower*win.pct1 + seed1.lower*win.pct2 + seed1.lower*wins1 + 
            seed1.lower*games1 + seed1.lower*wins2 + seed1.lower*games2 + 
            sos.rank1 + sos.rank2, data = train.set, 
          family = "binomial"); summary(m3)
train.set$pred <- predict(m3, train.set, type = "response")
train.set$pred <- pmax(pmin(0.999, train.set$pred), 0.001)
log.loss(train.set$y, train.set$pred)

test.set$pred <- predict(m3, test.set, type = "response")
test.set$pred <- pmax(pmin(0.999, test.set$pred), 0.001)
write.csv(test.set[,c('id','pred')], file = 'data/working/predictions-03092018-a.csv', row.names = FALSE, quote = FALSE)
logloss.evaluate('data/working/predictions-03092018-a.csv')

