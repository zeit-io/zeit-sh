#!/bin/bash

# Upload a timesheet to ZEIT.IO, based on a template from https://www.cherokey.de/StundenzettelProjektsteuerung.xlsx
# 
# Only columns headed in line 3 with the fixed PROJECT_HEADER from config.sh will be uploaded (e.g. "Megapart"), 
# the header of the column in line 4 sets the activity, e.g. "1400-21-1::SVP-RLP_Support_pauschal", see https://zeit.io/de/projects 
#
# Note: will simply add all records, existing records will not be deleted or updated (delete.sh can be used to clear a whole month first).
# Note: only 15-minute steps are supported for pause values currently 

if [ $# -lt 1 ]; then
  echo missing parameters
  exit 1
fi
FILE=$1 # saved as .txt/.csv, tab separated

# read PROJECT_HEADER from global configuration
. `dirname $0`/config.sh

YEAR=`cat $FILE | head -1 | cut -f1`
# convert the localized month
MONTH=`cat $FILE | recode windows-1252..utf8 | head -1 | cut -f2 | cut -c1-3 | sed 's/Mä/Mar/;s/Mai/May/;s/Okt/Oct/;s/Dez/Dec/'`
MONTH=`date +'%m' -d"1 $MONTH"`

function unwrap {
  echo "$1" | sed 's/^"//;s/"$//'
}

function parse_minutes_colon {
  H=`echo $1 | sed 's/^0*//;s/:.*$//'`
  MIN=`echo $1 | sed 's/^.*://'`
  echo $[ $H * 60 + $MIN ]
}

function parse_minutes_comma {
  H=`echo $1 | sed 's/,.*$//'`
  DIGIT=`echo $1 | grep ',' | sed 's/^.*,//'`
  if [ -z $DIGIT ]; then
    MIN=0
  elif [ $DIGIT -eq 25 ]; then
    MIN=15
  elif [ $DIGIT -eq 5 ]; then
    MIN=30
  elif [ $DIGIT -eq 75 ]; then
    MIN=45
  fi
  echo $[ $H * 60 + $MIN ]
}

function format_minutes_colon {
  H=$[ $1 / 60 ]
  MIN=$[ $1 - $H * 60 ]
  echo ${H}:${MIN} 
}

for COLUMN in 0 1 2 3 4 5 6 7 8 9 10; do
  # skip empty lines in Excel when counting, so these can be removed from the template
  PROJECT=`cat $FILE | recode windows-1252..utf8 | grep -vP '^\t\t\t' | head -2 | tail -1 | cut -f$[ 8 + $COLUMN * 2 ]`
  if [ "$PROJECT" = "$PROJECT_HEADER" ]; then
    ACTIVITY=`cat $FILE | recode windows-1252..utf8 | grep -vP '^\t\t\t' | head -3 | tail -1 | cut -f$[ 8 + $COLUMN * 2 ]`
    cat $FILE | recode windows-1252..utf8 | grep -E '^Mo\.|^Di\.|^Mi\.|^Do\.|^Fr\.|^Sa\.|^So\.' | sed 's/^.....//' \
        | cut -f1,2,3,$[ 8 + $COLUMN * 2 ],$[ 9 + $COLUMN * 2 ] | while read DAY START STOP TIME COMMENT; do 
      DATE=${YEAR}-${MONTH}-${DAY}
      COMMENT=`unwrap "$COMMENT" | tr -d '"'`
      if ! [ -z $TIME ]; then 
        TOTAL_MIN=$[ `parse_minutes_colon $STOP` - `parse_minutes_colon $START` ]
        TIME_MIN=`parse_minutes_comma $TIME`
        PAUSE_MIN=$[ $TOTAL_MIN - $TIME_MIN ]
        PAUSE=`format_minutes_colon ${PAUSE_MIN}`
        echo $DATE $START $STOP $PAUSE $ACTIVITY "$COMMENT"
        ./put.sh $DATE $START $STOP $PAUSE $ACTIVITY "$COMMENT"
        echo 
      fi
    done
  fi
done
