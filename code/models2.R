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
write.csv(test.set[,c('id','pred')], file = 'data/results/predictions-03092018-a.csv', row.names = FALSE, quote = FALSE)
logloss.evaluate('data/results/predictions-03092018-a.csv')

###############################################################################
## models with scoring statistics
load("data/working/train_set.RData")
load("data/working/test_set.RData")

m4 <- glm(y ~ seed1.lower + win.pct1 + win.pct2 + wins1 + games1 + wins2 + 
            games2 + seed1.lower*win.pct1 + seed1.lower*win.pct2 + seed1.lower*wins1 + 
            seed1.lower*games1 + seed1.lower*wins2 + seed1.lower*games2 + 
            avg.ppg + avg.opp.ppg, data = train.set, 
          family = "binomial"); summary(m4)
train.set$pred <- predict(m4, train.set, type = "response")
train.set$pred <- pmax(pmin(0.999, train.set$pred), 0.001)
log.loss(train.set$y, train.set$pred)

test.set$pred <- predict(m4, test.set, type = "response")
test.set$pred <- pmax(pmin(0.999, test.set$pred), 0.001)
write.csv(test.set[,c('id','pred')], file = 'data/results/predictions-03102018-a.csv', row.names = FALSE, quote = FALSE)
logloss.evaluate('data/results/predictions-03102018-a.csv')

## swap ppg for point diff
m5 <- glm(y ~ seed1.lower + win.pct1 + win.pct2 + wins1 + games1 + wins2 + 
            games2 + seed1.lower*win.pct1 + seed1.lower*win.pct2 + seed1.lower*wins1 + 
            seed1.lower*games1 + seed1.lower*wins2 + seed1.lower*games2 + 
            close.games + point.diff, data = train.set, 
          family = "binomial"); summary(m5)
train.set$pred <- predict(m5, train.set, type = "response")
train.set$pred <- pmax(pmin(0.999, train.set$pred), 0.001)
log.loss(train.set$y, train.set$pred)

test.set$pred <- predict(m5, test.set, type = "response")
test.set$pred <- pmax(pmin(0.999, test.set$pred), 0.001)
write.csv(test.set[,c('id','pred')], file = 'data/results/predictions-03102018-c.csv', row.names = FALSE, quote = FALSE)
logloss.evaluate('data/results/predictions-03102018-c.csv')

## keep ppg
m6 <- glm(y ~ seed1.lower + win.pct1 + win.pct2 + wins1 + games1 + wins2 + 
            games2 + seed1.lower*win.pct1 + seed1.lower*win.pct2 + seed1.lower*wins1 + 
            seed1.lower*games1 + seed1.lower*wins2 + seed1.lower*games2 + 
            avg.ppg + avg.opp.ppg + close.games, data = train.set, 
          family = "binomial"); summary(m6)
train.set$pred <- predict(m6, train.set, type = "response")
train.set$pred <- pmax(pmin(0.999, train.set$pred), 0.001)
log.loss(train.set$y, train.set$pred)

test.set$pred <- predict(m6, test.set, type = "response")
test.set$pred <- pmax(pmin(0.999, test.set$pred), 0.001)
write.csv(test.set[,c('id','pred')], file = 'data/results/predictions-03102018-d.csv', row.names = FALSE, quote = FALSE)
logloss.evaluate('data/results/predictions-03102018-d.csv')

## excl SoS
train.set <- na.omit(train.set)
m7 <- glm(y ~ seed1.lower + win.pct1 + win.pct2 + wins1 + games1 + wins2 + 
            games2 + seed1.lower*win.pct1 + seed1.lower*win.pct2 + seed1.lower*wins1 + 
            seed1.lower*games1 + seed1.lower*wins2 + seed1.lower*games2 + 
            sos.rank1 + sos.rank2 + avg.ppg + avg.opp.ppg, data = train.set, 
          family = "binomial"); summary(m7)
train.set$pred <- predict(m7, train.set, type = "response")
train.set$pred <- pmax(pmin(0.999, train.set$pred), 0.001)
log.loss(train.set$y, train.set$pred)

test.set$pred <- predict(m7, test.set, type = "response")
test.set$pred <- pmax(pmin(0.999, test.set$pred), 0.001)
write.csv(test.set[,c('id','pred')], file = 'data/results/predictions-03102018-b.csv', row.names = FALSE, quote = FALSE)
logloss.evaluate('data/results/predictions-03102018-b.csv')

m8 <- glm(y ~ seed1.lower + win.pct1 + win.pct2 + wins1 + games1 + wins2 + 
            games2 + seed1.lower*win.pct1 + seed1.lower*win.pct2 + seed1.lower*wins1 + 
            seed1.lower*games1 + seed1.lower*wins2 + seed1.lower*games2 + 
            sos.rank1 + sos.rank2 + avg.ppg + avg.opp.ppg + close.games, data = train.set, 
          family = "binomial"); summary(m8)
train.set$pred <- predict(m8, train.set, type = "response")
train.set$pred <- pmax(pmin(0.999, train.set$pred), 0.001)
log.loss(train.set$y, train.set$pred)

test.set$pred <- predict(m8, test.set, type = "response")
test.set$pred <- pmax(pmin(0.999, test.set$pred), 0.001)
write.csv(test.set[,c('id','pred')], file = 'data/results/predictions-03102018-e.csv', row.names = FALSE, quote = FALSE)
logloss.evaluate('data/results/predictions-03102018-e.csv')

## basic dumb ensemble
rm(list=ls())
source('code/log-loss-evaluation.R')
load(file = 'data/working/test_set.RData')

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

test.set$pred <- rowMeans(models.mat[,c("m1", "m5")])
test.set$pred <- pmax(pmin(0.999, test.set$pred), 0.001)
write.csv(test.set[,c('id','pred')], file = 'data/results/predictions-03102018-f.csv', row.names = FALSE, quote = FALSE)
logloss.evaluate('data/results/predictions-03102018-f.csv')

