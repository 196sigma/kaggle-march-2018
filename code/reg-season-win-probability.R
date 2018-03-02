## Reginald Edwards
## CREATED: 1 March 2018
## MODIFIED:
## DESCRIPTION: Compute the probability regular season win percentages and use
## ase probability of tournament win
###############################################################################


rm(list=ls())

###############################################################################
## Training data
###############################################################################

## load regular season results
X.season <- read.csv('data/raw/RegularSeasonCompactResults.csv',
  stringsAsFactors = FALSE)
names(X.season) <- tolower(names(X.season))
X.season$game <- 1
wins <- aggregate(X.season$game, by = list(X.season$season, X.season$wteamid), FUN = sum)
names(wins) <- c('season', 'teamid', 'n.wins')

losses <- aggregate(X.season$game, by = list(X.season$season, X.season$lteamid), FUN = sum)
names(losses) <- c('season', 'teamid', 'n.losses')

team.record <- merge(wins, losses, all.x = TRUE, all.y = TRUE)
team.record$n.wins <- ifelse(is.na(team.record$n.wins), 0, team.record$n.wins)
team.record$n.losses <- ifelse(is.na(team.record$n.losses), 0, team.record$n.losses)
team.record$games <- team.record$n.wins + team.record$n.losses
team.record$win.pct <- team.record$n.wins/team.record$games
summary(team.record)

team.record[which(team.record$win.pct == 1),]
## Unbeaten in the regular season
## 1991, UNLV
## 2014 Wichitaw St
## 2015 Kentucky

## Add win pct, wins, losses, and number of game of team 1 as features

## load training data
load('data/working/training.RData')
X.train <- merge(X.train, team.record, by.x = c('season', 'team1'), by.y = c('season', 'teamid'))
X.train$wins1 <- X.train$n.wins
X.train$losses1 <- X.train$n.losses
X.train$games1 <- X.train$games
X.train$win.pct1 <- X.train$win.pct

X.train$n.wins <- NULL
X.train$n.losses <- NULL
X.train$games <- NULL
X.train$win.pct <- NULL

X.train <- merge(X.train, team.record, by.x = c('season', 'team2'), by.y = c('season', 'teamid'))
X.train$wins2 <- X.train$n.wins
X.train$losses2 <- X.train$n.losses
X.train$games2 <- X.train$games
X.train$win.pct2 <- X.train$win.pct

X.train$n.wins <- NULL
X.train$n.losses <- NULL
X.train$games <- NULL
X.train$win.pct <- NULL

o <- order(X.train$season, X.train$daynum, X.train$wteamid)
X.train <- X.train[o, ]

save(X.train, file = 'data/working/training.RData')

## Michigan's 2012-2013 season
#X.train[X.train$season == 2013 & (X.train$wteamid == 1276 | X.train$lteamid == 1276), ]

###############################################################################
## Test data
###############################################################################
load('data/working/testing.RData')

X.test <- merge(X.test, team.record, by.x = c('season', 'team1'), by.y = c('season', 'teamid'))
X.test$wins1 <- X.test$n.wins
X.test$losses1 <- X.test$n.losses
X.test$games1 <- X.test$games
X.test$win.pct1 <- X.test$win.pct

X.test$n.wins <- NULL
X.test$n.losses <- NULL
X.test$games <- NULL
X.test$win.pct <- NULL

X.test <- merge(X.test, team.record, by.x = c('season', 'team2'), by.y = c('season', 'teamid'))
X.test$wins2 <- X.test$n.wins
X.test$losses2 <- X.test$n.losses
X.test$games2 <- X.test$games
X.test$win.pct2 <- X.test$win.pct

X.test$n.wins <- NULL
X.test$n.losses <- NULL
X.test$games <- NULL
X.test$win.pct <- NULL

o <- order(X.test$season, X.test$team1)
X.test <- X.test[o, ]
 
save(X.test, file = 'data/working/testing.RData')
