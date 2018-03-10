## Reginald Edwards
## CREATED: 01 March 2018
## MODIFIED: 09 March 2018
## DESCRIPTION: Prepare data for modeling. Some datasets have to be created at 
## many points in the project, this script generates these datasets up front.
###############################################################################

rm(list=ls())
gc()
## load actual Tournament compact results
compact.results <- read.csv('data/raw/NCAATourneyCompactResults.csv', 
                            stringsAsFactors = FALSE)
names(compact.results) <- tolower(names(compact.results))
## transform actual results table into one comparable to the submissions table
compact.results$id <- ifelse(compact.results$wteamid < compact.results$lteamid, 
                             paste(compact.results$season, compact.results$wteamid, 
                                   compact.results$lteamid, sep = '_'), 
                             paste(compact.results$season, compact.results$lteamid, 
                                   compact.results$wteamid, sep = '_'))
save(compact.results, file = 'data/working/compact_results.RData')

## create submissions template dataset from sample submissions file
pred_template <- read.csv('data/results/SampleSubmissionStage1.csv', stringsAsFactors = FALSE)
names(pred_template) <- tolower(names(pred_template))
save(pred_template, file = 'data/working/predictions_template.RData')

## create test dataset from list of competing teams
test.set <- read.csv('data/results/SampleSubmissionStage1.csv', stringsAsFactors = FALSE)
names(test.set) <- tolower(names(test.set))
f <- function(x, i) unlist(strsplit(x, "_"))[i]
test.set$season <- unlist(lapply(test.set$id, f, i = 1))
test.set$team1 <- unlist(lapply(test.set$id, f, i = 2))
test.set$team2 <- unlist(lapply(test.set$id, f, i = 3))
save(test.set, file = 'data/working/test_set.RData')
