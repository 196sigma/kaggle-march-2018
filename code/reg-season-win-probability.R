## Reginald Edwards
## CREATED: 01 March 2018
## MODIFIED: 09 March 2018
## DESCRIPTION: Compute the regular season win percentages and use
## as probability of tournament win
###############################################################################


###############################################################################
## Training data
###############################################################################

## load regular season results
season.compact.results <- read.csv('data/raw/RegularSeasonCompactResults.csv',
  stringsAsFactors = FALSE)
names(season.compact.results) <- tolower(names(season.compact.results))
season.compact.results$game <- 1
wins <- aggregate(season.compact.results$game, by = list(season.compact.results$season, season.compact.results$wteamid), FUN = sum)
names(wins) <- c('season', 'teamid', 'n.wins')

losses <- aggregate(season.compact.results$game, by = list(season.compact.results$season, season.compact.results$lteamid), FUN = sum)
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
load('data/working/train_set.RData')
train.set <- merge(train.set, team.record, by.x = c('season', 'team1'), by.y = c('season', 'teamid'))
train.set$wins1 <- train.set$n.wins
train.set$losses1 <- train.set$n.losses
train.set$games1 <- train.set$games
train.set$win.pct1 <- train.set$win.pct

## delete unused variables
train.set$n.wins <- NULL
train.set$n.losses <- NULL
train.set$games <- NULL
train.set$win.pct <- NULL

train.set <- merge(train.set, team.record, by.x = c('season', 'team2'), by.y = c('season', 'teamid'))
train.set$wins2 <- train.set$n.wins
train.set$losses2 <- train.set$n.losses
train.set$games2 <- train.set$games
train.set$win.pct2 <- train.set$win.pct

## delete unused variables
train.set$n.wins <- NULL
train.set$n.losses <- NULL
train.set$games <- NULL
train.set$win.pct <- NULL

o <- order(train.set$season, train.set$daynum, train.set$wteamid)
train.set <- train.set[o, ]

save(train.set, file = 'data/working/train_set.RData')

## Michigan's 2012-2013 season
#train.set[train.set$season == 2013 & (train.set$wteamid == 1276 | train.set$lteamid == 1276), ]

###############################################################################
## Test data
###############################################################################
load('data/working/test_set.RData')

test.set <- merge(test.set, team.record, by.x = c('season', 'team1'), by.y = c('season', 'teamid'))
test.set$wins1 <- test.set$n.wins
test.set$losses1 <- test.set$n.losses
test.set$games1 <- test.set$games
test.set$win.pct1 <- test.set$win.pct

## delete unused variables
test.set$n.wins <- NULL
test.set$n.losses <- NULL
test.set$games <- NULL
test.set$win.pct <- NULL

test.set <- merge(test.set, team.record, by.x = c('season', 'team2'), by.y = c('season', 'teamid'))
test.set$wins2 <- test.set$n.wins
test.set$losses2 <- test.set$n.losses
test.set$games2 <- test.set$games
test.set$win.pct2 <- test.set$win.pct

## delete unused variables
test.set$n.wins <- NULL
test.set$n.losses <- NULL
test.set$games <- NULL
test.set$win.pct <- NULL

## sory by season year and teamid of team 1
test.set <- test.set[order(test.set$season, test.set$team1), ]

save(test.set, file = 'data/working/test_set.RData')
rm("team.record")
rm("o")
gc()