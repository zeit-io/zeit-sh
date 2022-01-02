#!/bin/bash

# add a single time record in ZEIT.IO
# Note: "hourly_wage_category" is currently fixed to "remote".

if [ $# -lt 6 ]; then
  echo missing parameters
  exit 1
fi
DATE=$1 # yyyy-mm-dd
START=$2 # hh:mm
STOP=$3 # hh:mm
PAUSE=$4 # hh:mm 
ACTIVITY=$5 # e.g. "1400-21-1::SVP-RLP_Support_pauschal", see https://zeit.io/de/projects 
COMMENT="$6"

# read PROJECT_ID and APIKEY from global configuration
. `dirname $0`/config.sh

# reformat pause to seconds
PAUSE_H=`echo $PAUSE | sed 's/:.*$//'`
PAUSE_MIN=`echo $PAUSE | sed 's/^.*://'`
PAUSE=$[ $PAUSE_H * 60 * 60 + $PAUSE_MIN * 60 ]

curl -s -X POST "https://zeit.io/api/v1/usr/time_records/start_stop" \
  -H "Content-Type: application/json" -H "accept: application/json" -H "apiKey: $APIKEY" \
  -d "{\"date\":\"${DATE}\",\"start_time\":\"${START}\",\"stop_time\":\"${STOP}\",\"pause\":${PAUSE},\"comment\":\"${COMMENT}\",\"hourly_wage_category\":\"remote\",\"project_id\":\"${PROJECT_ID}\",\"activity\":\"${ACTIVITY}\"}" \
  | sed 's/^{"error":"","message":"The time record was saved successfully.",.*$/OK/'
echo
