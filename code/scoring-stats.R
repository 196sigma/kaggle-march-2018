
rm(list=ls())
gc()
rs_compact_results <- read.csv("data/raw/RegularSeasonCompactResults.csv",
  stringsAsFactors = FALSE)
names(rs_compact_results) <- tolower(names(rs_compact_results))

X1 <- rs_compact_results
X1$teamid <- X1$wteamid
X1$opp.teamid <- X1$lteamid
X1$score <- X1$wscore
X1$opp.score <- X1$lscore

X2 <- rs_compact_results
X2$teamid <- X2$lteamid
X2$opp.teamid <- X2$wteamid
X2$score <- X2$lscore
X2$opp.score <- X2$wscore

X <- rbind(X1, X2)

## delete unused variables
X$wloc <- NULL
X$wteamid <- NULL
X$lteamid <- NULL
X$wscore <- NULL
X$lscore <- NULL
X$numot <- NULL

results_by_team <- X

## delete intermediate dataframes
rm(X, X1, X2)

## Points per game
ppg <- aggregate(score ~ season + teamid, data = results_by_team, FUN = mean)
names(ppg) <- c("season", "teamid", "avg.ppg")

## Points allowed per game
opp.ppg <- aggregate(opp.score ~ season + teamid, data = results_by_team, FUN = mean)
names(opp.ppg) <- c("season", "teamid", "avg.opp.ppg")

ppg <- merge(ppg, opp.ppg)
rm(opp.ppg, rs_compact_results)

## Point differential
results_by_team$point.diff <- results_by_team$score - results_by_team$opp.score

avg.point.diff <- aggregate(point.diff ~ season + teamid, data = results_by_team, FUN = mean)
names(avg.point.diff) <- c("season", "teamid", "point.diff")
#summary(avg.point.diff)

scoring.stats <- merge(ppg, avg.point.diff)

## Close games
results_by_team$close.game <- ifelse(abs(results_by_team$point.diff) < 4, 1, 0)
n.close.games <- aggregate(close.game ~ season + teamid, data = results_by_team, FUN = sum)
names(n.close.games) <- c("season", "teamid", "close.games")

scoring.stats <- merge(scoring.stats, n.close.games)
save(ppg, file = "data/working/points_per_game.RData")
save(scoring.stats, file = "data/working/scoring_stats.RData")

summary(scoring.stats)
