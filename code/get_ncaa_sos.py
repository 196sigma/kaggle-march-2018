#!/usr/bin/env python
import os
import re

DATA_DIR = '/home/reg/Dropbox/Kaggle - NCAA ML 2018/data'
RAW_DATA_DIR = DATA_DIR + '/' + 'raw'
WORKING_DATA_DIR = DATA_DIR + '/' + 'working'
ncaa_sos_pdf_filename = "college_basketball_strength_of_schedule_database.pdf"

################################################################################
## Convert PDF file with NCAA Strength of Schedule rankings to text file
################################################################################
os_command = "pdftotext -layout '%s' '%s'" % (RAW_DATA_DIR + '/' +
    ncaa_sos_pdf_filename, WORKING_DATA_DIR + '/ncaa_sos.txt')
print os_command, os.system(os_command)


################################################################################
## Convert text file of SOS rankings to clean, delimited file
################################################################################
## read in file
infile = open(WORKING_DATA_DIR + '/ncaa_sos.txt', 'r').readlines()
## skip header
infile = infile[1:]
cleaned_lines = []
## remove odd characters (eg '\x02c')
for current_line in infile:
    if current_line[0] == '\x0c':
        current_line = current_line[1:]
    current_line = current_line.strip()
    cleaned_lines.append(current_line)

## Location of vcariable fields
SEASON_INDEX = 0
TEAM_NAME_INDEX = 1
SOS_INDEX = 2
RECORD_INDEX = 3
    
split_lines = []
## split based on spaces: taking care of multiple spaces, spaces between names
for current_line in cleaned_lines:
    current_line = current_line.split('  ')
    current_line = [c.strip() for c in current_line if c != '']
    
    ## clean team names by normalizing, remove characters, etc
    current_team_name = current_line[TEAM_NAME_INDEX]
    current_team_name = re.sub(r'[\.\(\)]', '', current_team_name)
    current_team_name = re.sub(r' U(\s+|\b)', ' Univ', current_team_name)
    current_team_name = current_team_name.lower()
    current_line[TEAM_NAME_INDEX] = current_team_name
    current_line = '|'.join(current_line)
    split_lines.append(current_line)

## save data
with open(WORKING_DATA_DIR + "/ncaa_sos_cleaned.txt", "w") as outfile:
    outfile.writelines([x + '\n' for x in split_lines])
    
