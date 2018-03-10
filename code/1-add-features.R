## Reginald Edwards
## CREATED: 01 March 2018
## MODIFIED: 09 March 2018
## DESCRIPTION: Add modeling features:
##  - team seeds
##  - upset indicator
##  - NCAA strength of schedule (SoS) ranking
###############################################################################

## Clear workspace
rm(list=ls())
gc()


###############################################################################
## Add features to training dataset
###############################################################################

## load training data (actual compact Tournament results)
load('data/working/compact_results.RData')
## compact.results

## Add team seeds and upset indicator variable
## Extract seed ranking (excluding division) 
seeds <- read.csv("data/raw/NCAATourneySeeds.csv")
names(seeds) <- tolower(names(seeds))
seeds$nseed <- as.numeric(substr(seeds$seed,2,3))
save(seeds, file = "data/working/seeds.RData")

## merge winning team seed
compact.results <- merge(compact.results, seeds, by.x = c('wteamid', 'season'), 
               by.y = c('teamid', 'season'))
compact.results$wseed <- compact.results$seed
compact.results$wnseed <- compact.results$nseed

## remove unused variables
compact.results$seed <- NULL
compact.results$nseed <- NULL

## merge losing team seed
compact.results <- merge(compact.results, seeds, by.x = c('lteamid', 'season'), 
               by.y = c('teamid', 'season'))
compact.results$lseed <- compact.results$seed
compact.results$lnseed <- compact.results$nseed
## remove unused variables
compact.results$seed <- NULL
compact.results$nseed <- NULL

o <- order(compact.results$season, compact.results$wteamid)
compact.results <- compact.results[o, ]
compact.results$upset <- ifelse(compact.results$wnseed > compact.results$lnseed, 1, 0)


## Limit training dataset to [1985-2013]
train.set <- compact.results[which(compact.results$season <= 2013), ]

# compute y
f <- function(x, i) unlist(strsplit(x, "_"))[i]
train.set$team1 <- unlist(lapply(train.set$id, f, i = 2))
train.set$team2 <- unlist(lapply(train.set$id, f, i = 3))
train.set$y <- ifelse(train.set$team1 == train.set$wteamid, 1, 0)
train.set$y <- ifelse(train.set$team1 == train.set$wteamid, 1, 0)

## Add team seeds and upset indicator variable
## merge team seeds
train.set <- merge(train.set, seeds, by.x = c('team1', 'season'), 
                 by.y = c('teamid', 'season'))
train.set$seed1 <- train.set$seed
train.set$nseed1 <- train.set$nseed
## remove unused variables
train.set$seed <- NULL
train.set$nseed <- NULL
X <- train.set
## merge team 2 seeds
train.set <- merge(train.set, seeds, by.x = c('team2', 'season'), 
                 by.y = c('teamid', 'season'))
train.set$seed2 <- train.set$seed
train.set$nseed2 <- train.set$nseed

## remove unused variables
train.set$seed <- NULL
train.set$nseed <- NULL

train.set$seed1.lower <- ifelse(train.set$nseed1 < train.set$nseed2, 1, 0)

save(train.set, file = 'data/working/train_set.RData')

###############################################################################
## Add features to testing dataset
###############################################################################
## load test data
load('data/working/test_set.RData')

## Add team 1 seeds and upset indicator variable
test.set <- merge(test.set, seeds, by.x = c('team1', 'season'), 
                by.y = c('teamid', 'season'))
test.set$seed1 <- test.set$seed
test.set$nseed1 <- test.set$nseed

## delete unused variables
test.set$seed <- NULL
test.set$nseed <- NULL

## Add team 2 seeds and upset indicator variable
test.set <- merge(test.set, seeds, by.x = c('team2', 'season'), 
                by.y = c('teamid', 'season'))
test.set$seed2 <- test.set$seed
test.set$nseed2 <- test.set$nseed

## delete unused variables
test.set$seed <- NULL
test.set$nseed <- NULL

## create indicator for team 1 being lower seeded (i.e., better ranked) than team 2
test.set$seed1.lower <- ifelse(test.set$nseed1 < test.set$nseed2, 1, 0)

## rank teams by teamid
test.set <- test.set[order(test.set$id), ]

## save testing set data
save(test.set, file = 'data/working/test_set.RData')

## Regular season win-loss record
source('code/reg-season-win-probability.R')

###############################################################################
## NCAA strength of schedule (SoS) rankings
load('data/working/ncaa_sos.RData')
# ncaa.sos data frame

## Add to test set
#load("data/working/test_set.RData")
## Team 1 SOS
test.set <- merge(test.set, ncaa.sos, by.x = c('season', 'team1'), by.y = c('season', 'teamid'), all.x = TRUE)
test.set$sos.rank1 <- test.set$sos.rank

## delete unused variables
test.set$sos.rank <- NULL
test.set$record <- NULL
test.set$teamname <- NULL

## Team 2 SOS
test.set <- merge(test.set, ncaa.sos, by.x = c('season', 'team2'), by.y = c('season', 'teamid'), all.x = TRUE)
test.set$sos.rank2 <- test.set$sos.rank

## delete unused variables
test.set$sos.rank <- NULL
test.set$record <- NULL
test.set$teamname <- NULL
save(test.set, file="data/working/test_set.RData")

## Add to training set
#load("data/working/train_set.RData")

train.set <- merge(train.set, ncaa.sos, by.x = c('season', 'team1'), by.y = c('season', 'teamid'), all.x = TRUE)
train.set$sos.rank1 <- train.set$sos.rank

## delete unused variables
train.set$sos.rank <- NULL
train.set$record <- NULL
train.set$teamname <- NULL

## Team 2 SOS
train.set <- merge(train.set, ncaa.sos, by.x = c('season', 'team2'), by.y = c('season', 'teamid'), all.x = TRUE)
train.set$sos.rank2 <- train.set$sos.rank

## delete unused variables
train.set$sos.rank <- NULL
train.set$record <- NULL
train.set$teamname <- NULL

save(train.set, file="data/working/train_set.RData")
