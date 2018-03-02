## Reginald Edwards
## CREATED: 1 March 2018
## MODIFIED:
## DESCRIPTION: Prepare data for modeling. Some datasets have to be created at 
## many points in the project, this script generates these datasets up front.
###############################################################################

rm(list=ls())
## load actual results
X.res <- read.csv('data/raw/NCAATourneyCompactResults.csv', 
                  stringsAsFactors = FALSE)
names(X.res) <- tolower(names(X.res))
## transform actual results table into one comparable to the submissions table
X.res$id <- ifelse(X.res$wteamid < X.res$lteamid, paste(X.res$season, 
  X.res$wteamid, X.res$lteamid, sep = '_'), paste(X.res$season, X.res$lteamid, 
  X.res$wteamid, sep = '_'))
save(X.res, file = 'data/working/results.RData')

## create submissions template dataset
X.pred <- read.csv('data/results/SampleSubmissionStage1.csv', stringsAsFactors = FALSE)
names(X.pred) <- tolower(names(X.pred))
save(X.pred, file = 'data/working/predictions_template.RData')

## create test dataset from list of competing teams
X.test <- read.csv('data/results/SampleSubmissionStage1.csv', stringsAsFactors = FALSE)
names(X.test) <- tolower(names(X.test))
f <- function(x, i) unlist(strsplit(x, "_"))[i]
X.test$season <- unlist(lapply(X.test$id, f, i = 1))
X.test$team1 <- unlist(lapply(X.test$id, f, i = 2))
X.test$team2 <- unlist(lapply(X.test$id, f, i = 3))
save(X.test, file = 'data/working/testing.RData')
