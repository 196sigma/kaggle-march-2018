## Reginald Edwards
## CREATED: 09 March 2018
## MODIFIED:
## DESCRIPTION: Add Strength of Schedule (SoS) data
###############################################################################

ncaa.sos <- read.delim('data/working/ncaa_sos_cleaned.txt', sep = '|', 
  stringsAsFactors = FALSE, header = FALSE)
names(ncaa.sos) <- c('season', 'teamname', 'sos.rank', 'record')
n.observations <- nrow(ncaa.sos)
#summary(ncaa.sos)
#table(ncaa.sos$team.name)
#table(ncaa.sos$season)

## map team names to team IDs
team.names <- read.csv('data/raw/TeamSpellings.csv', stringsAsFactors = FALSE)
names(team.names) <- tolower(names(team.names))
team.names$match <- 1
ncaa.sos <- merge(ncaa.sos, team.names[,c("teamnamespelling", "match"), 
  drop = FALSE], all.x = TRUE, by.x = "teamname", by.y = "teamnamespelling")

## find which team names are in the SOS set but didn't get mapped to one in the

## teams set
unmatched.teamnames <- unique(ncaa.sos[which(is.na(ncaa.sos$match)), "teamname"])
nonames <- data.frame(teamname = unmatched.teamnames, stringsAsFactors = FALSE)

## try fuzzy matching
fuzzy.match.team <- function(x) team.names[which.min(adist(x, 
  team.names$teamnamespelling)), 'teamnamespelling']
teamnamematch <- unlist(lapply(nonames$teamname, fuzzy.match.team))
nonames$teamnamematch <- teamnamematch

ncaa.sos <- merge(ncaa.sos, nonames, all.x = TRUE)

## delete unused variable
ncaa.sos$match <- NULL

## set team name to match if one was found, otherwise keep it as is
ncaa.sos$teamname <- ifelse(is.na(ncaa.sos$teamnamematch), ncaa.sos$teamname, 
  ncaa.sos$teamnamematch)

ncaa.sos <- merge(ncaa.sos, team.names, by.x = "teamname", 
  by.y = "teamnamespelling")

## Clean up (delete unused variables)
ncaa.sos$teamnamematch <- NULL
ncaa.sos$match <- NULL

## sanity check
#ncaa.sos[which(is.na(ncaa.sos$teamid)),"teamname"]
nrow(ncaa.sos) == n.observations
## should be TRUE

## make team id a character
ncaa.sos$teamid <- as.character(ncaa.sos$teamid)

## save 
save(ncaa.sos, file = "data/working/ncaa_sos.RData")

## Clean up
rm("team.names", "unmatched.teamnames", "nonames", "fuzzy.match.team")
gc()