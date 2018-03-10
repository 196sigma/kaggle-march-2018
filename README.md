## Reginald Edwards
## CREATED: 01 March 2018
## MODIFIED: 09 March 2018
## DESCRIPTION: Overview of code, data, etc for Kaggle March Madness 2018 
## Competition
## 

CODE ORGANIZATION

code/

- **0-prep-data.R**: run at the beginning of the project, this script generates 
datasets that will have to be used at many different points in the project. 
Transforms a lot of the raw datasets into useful formats.
    - depends: *data/raw/NCAATourneyCompactResults.csv*;
    *data/results/SampleSubmissionStage1.csv*
    - outputs: *data/results/predictions_template.RData*;
      *data/working/test_set.RData*;
      *data/working/compact_results.RData*

- **1-add-features.R**: Add various features that will be used later for modeling: team seeds, upset indicator, NCAA strength of schedule (SoS) ranking. Adds features to both the training set and the testing set.
    - depends: *data/working/compact_results.RData*; *data/raw/NCAATourneySeeds.csv*; *data/working/test_set.RData*;
    
    *reg-season-win-probability.R*
    - outputs: *data/working/seeds.RData*; *data/working/train_set.RData*

- **reg-season-win-probability.R**: Called by *add-features.R*. Adds the regular season win percentage for each team in each season.
    - depends: *data/raw/RegularSeasonCompactResults.csv*; *data/working/train_set.RData*; *data/working/test_set.RData*
    - outputs: *data/working/test_set.RData*

- **seed-win-probability.R**: Exploratory in nature. Calculates the historical 
frequency of a favored team winning its match-up.
    - depends:
    - outputs:

- **log-loss-evaluation.R**: evaluate a set of predictions
    - depends:
    - outputs:

- **get_ncaa_sos.py**: Extract data on NCAA strength of schedule from pdf file and output it into a nice delimited file.
    - depends: *college_basketball_strength_of_schedule_database.pdf*; 
    *data/working/ncaa_sos.txt*
    - outputs: *data/working/ncaa_sos_cleaned.txt*

- **add_ncaa_sos.R**: prepare for addition data on NCAA strength of schedule
    - depends: *data/working/ncaa_sos_cleaned.txt*
    - outputs: *data/working/ncaa_sos.RData*

data/

- raw/

  - Cities.csv
  
  - college_basketball_strength_of_schedule_database.pdf
  
  - Conferences.csv
  
  - ConferenceTourneyGames.csv
  
  - DataFiles.zip
  - GameCities.csv
  - MasseyOrdinals.zip
  - NCAATourneyCompactResults.csv
  - NCAATourneyDetailedResults.csv
  - NCAATourneySeedRoundSlots.csv
  - NCAATourneySeeds.csv
  - NCAATourneySlots.csv
  - PlayByPlay_2010.zip
  - RegularSeasonCompactResults.csv
  - RegularSeasonDetailedResults.csv
  - Seasons.csv
  - SecondaryTourneyCompactResults.csv
  - SecondaryTourneyTeams.csv
  - TeamCoaches.csv
  - TeamConferences.csv
  - Teams.csv
  - TeamSpellings.csv
- working/
	- **seed_win_prediction.csv**: predictions using the prior probabiliyy of the favored team wining
	- **record_win_prediction.csv**: predictions using a logistic regression model of win-loss record