#!/bin/bash

# delete all records of a month in ZEIT.IO

if [ $# -lt 1 ]; then
  echo missing parameters
  exit 1
fi
MONTH=$1 # yyyy-mm

# read APIKEY from global configuration
. `dirname $0`/config.sh

./get.sh $MONTH | grep '"id"' | sed 's/^{"id":"//;s/",".*//' | while read ID; do
  curl -s -X DELETE "https://zeit.io/api/v1/usr/time_records/$ID" \
    -H "accept: application/json" -H "apiKey: ${APIKEY}"
  echo
done
