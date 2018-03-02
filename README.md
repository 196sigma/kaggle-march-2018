
CODE ORGANIZATION
code/
- prep-data.R: run at the beginning of the project, this script generates 
datasets that will have to be used at many different points in the project. 
Transforms a lot of the raw datasets into useful formats.
	- Outputs: results.RData

- seed-win-probability: Exploratory in nature. Calculates the historical 
frequency of a favored team winning its match-up.

- log-loss-evaluation.R: evaluate a set of predictions

DATA
Working
	- seed_win_prediction.csv: predictions using the prior probabiliyy of the favored team wining
	- record_win_prediction.csv: predictions using a logistic regression model of win-loss record