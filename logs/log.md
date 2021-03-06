03/01/2018
===============================================================================
-  getting to know the data

-  submitted the naive prediction of a 50-50 chance for both teams. The log-
loss of this prediction is 0.6931472. I will refer to this as the naive 
baseline log-loss.

-  As a first step beyond the naive 50-50 prediction, I computed the overall 
historical percentage in which the favored (i.e. lower seeded team) wins. This 
probability is 70.15%. I applied this probability to the 2014-2017 test sample. 
The Log-loss fell to 0.6064068.

-  added win-loss record as features. Tried an initial logistic regression.
Submitted. The Log-loss fell to 0.58261 on my machine, .561579 on  Kaggle's 
leader board.

PREDICTIONS
1. seed_win_prediction.csv
Prediction is historical average frequency of favored team winning
The Log-loss fell to 0.6064068.

2. record_win_prediction.csv
Predictions using a logistic regression model of win-loss record.
Logistic regression. Includes, for both teams 1 and 2, win percentage, number 
of  wins, number of games played, as well as an indicator variable for whether 
or not team 1 was seeded lower (i.e. team 1 was favored).
Log-loss fell to 0.58261.

03/09/2018
===============================================================================
-  downloaded NCAA strength of schedule rankings. These data are in a pdf file, which I convert to text. The files contains different views of the same data. After converting the pdf to text, I manually extracted the first view of the data, which contained the fields (Year, Team, SOS, Record).
-  cleaned up code (better variables names, comments, etc)
-  submitted *predictions-03092018-a.csv*: Score of 0.557140, improvement of 19 places on leaderboard

03/10/2018
===============================================================================
- added points and opp points per game stats
- submmited *predictions-03102018-a.csv*: Score of 0.548216, improvement of 26 places on leaderboard
- submmited *predictions-03102018-b.csv*: Score of 0.545007, improvement of 8 places on leaderboard
- added point differential and number of close games
- submmited *predictions-03102018-d.csv*: Score of 0.556078, not an improvement of best score
- submmited *predictions-03102018-e.csv*: Score of 0.550967, not an improvement of best score
- considered basic ensemble of five recent models, but expect much worse performance because models are too correlated. After examining plots of predictions, I pick two uncorrelated models. 
- after examining models, there are too many very high win probabilities (ie close to .9)