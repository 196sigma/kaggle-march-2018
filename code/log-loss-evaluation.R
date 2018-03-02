## Reginald Edwards
## CREATED: 1 March 2018
## MODIFIED:
## DESCRIPTION: This script computes the log-loss of the predictions. 
###############################################################################

# log-loss function takes a vector of actual y and a vector of predictions
log.loss <- function(y, x.pred) -mean(y*log(x.pred) + (1-y)*log(1 - x.pred))

logloss.evaluate <- function(predictions_file_loc = "data/results/SampleSubmissionStage1.csv"){
  ## load predictions
  X.pred <- read.csv(predictions_file_loc, stringsAsFactors = FALSE)
  names(X.pred) <- tolower(names(X.pred))
  
  ## load actual results
  X.res <- read.csv('data/raw/NCAATourneyCompactResults.csv', stringsAsFactors = FALSE)
  names(X.res) <- tolower(names(X.res))
  
  ## transform actual results table into one comparable to the submissions table
  X.res$id <- ifelse(X.res$wteamid < X.res$lteamid, paste(X.res$season, 
    X.res$wteamid, X.res$lteamid, sep = '_'), paste(X.res$season, X.res$lteamid,
    X.res$wteamid, sep = '_'))
  
  ## Merge actual results with predictions
  X <- merge(X.pred, X.res[,c('id', 'wteamid', 'lteamid')])
  
  ## compute log-loss
  # compute y
  f <- function(x, i) unlist(strsplit(x, "_"))[i]
  X$team1 <- lapply(X$id, f, i = 2)
  X$team2 <- lapply(X$id, f, i = 3)
  X$y <- ifelse(X$team1 == X$wteamid, 1, 0)
  print("Naive prediction baseline is 0.6931472")
  return(log.loss(X$y, X$pred))
  ## 0.6931472 for naive predictions  
}
