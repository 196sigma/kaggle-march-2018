## Reginald Edwards
## CREATED: 1 March 2018
## MODIFIED:
## DESCRIPTION: Add modeling features
###############################################################################

rm(list=ls())

###############################################################################
## Add features to training dataset
###############################################################################
## load training data
load('data/working/results.RData')

## Add team seeds and upset indicator variable
## merge team seeds
load('data/working/seeds.RData')
X.res <- merge(X.res, X.seeds, by.x = c('wteamid', 'season'), 
               by.y = c('teamid', 'season'))
X.res$wseed <- X.res$seed
X.res$wnseed <- X.res$nseed
X.res$seed <- NULL
X.res$nseed <- NULL

X.res <- merge(X.res, X.seeds, by.x = c('lteamid', 'season'), 
               by.y = c('teamid', 'season'))
X.res$lseed <- X.res$seed
X.res$lnseed <- X.res$nseed
X.res$seed <- NULL
X.res$nseed <- NULL

o <- order(X.res$season, X.res$wteamid)
X.res <- X.res[o, ]
X.res$upset <- ifelse(X.res$wnseed > X.res$lnseed, 1, 0)


## Limit training dataset to [1985-2013]
o <- which(X.res$season <= 2013)
X.train <- X.res[o, ]

# compute y
f <- function(x, i) unlist(strsplit(x, "_"))[i]
X.train$team1 <- unlist(lapply(X.train$id, f, i = 2))
X.train$team2 <- unlist(lapply(X.train$id, f, i = 3))
X.train$y <- ifelse(X.train$team1 == X.train$wteamid, 1, 0)
X.train$y <- ifelse(X.train$team1 == X.train$wteamid, 1, 0)

## Add team seeds and upset indicator variable
## merge team seeds
load('data/working/seeds.RData')
X.train <- merge(X.train, X.seeds, by.x = c('team1', 'season'), 
                 by.y = c('teamid', 'season'))
X.train$seed1 <- X.train$seed
X.train$nseed1 <- X.train$nseed
X.train$seed <- NULL
X.train$nseed <- NULL

X.train <- merge(X.train, X.seeds, by.x = c('team2', 'season'), 
                 by.y = c('teamid', 'season'))
X.train$seed2 <- X.train$seed
X.train$nseed2 <- X.train$nseed
X.train$seed <- NULL
X.train$nseed <- NULL

X.train$seed1.lower <- ifelse(X.train$nseed1 < X.train$nseed2, 1, 0)

save(X.train, file = 'data/working/training.RData')

###############################################################################
## Add features to testing dataset
###############################################################################
## load test data
load('data/working/testing.RData')

## Add team seeds and upset indicator variable
## merge team seeds
load('data/working/seeds.RData')
X.test <- merge(X.test, X.seeds, by.x = c('team1', 'season'), 
                by.y = c('teamid', 'season'))
X.test$seed1 <- X.test$seed
X.test$nseed1 <- X.test$nseed
X.test$seed <- NULL
X.test$nseed <- NULL

X.test <- merge(X.test, X.seeds, by.x = c('team2', 'season'), 
                by.y = c('teamid', 'season'))
X.test$seed2 <- X.test$seed
X.test$nseed2 <- X.test$nseed
X.test$seed <- NULL
X.test$nseed <- NULL

X.test$seed1.lower <- ifelse(X.test$nseed1 < X.test$nseed2, 1, 0)

o <- order(X.test$id)
X.test <- X.test[o, ]
save(X.test, file = 'data/working/testing.RData')

## Regular season win-loss record
source('code/reg-season-win-probability.R')