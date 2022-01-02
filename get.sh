#!/bin/bash

# get all records of a month in ZEIT.IO

if [ $# -lt 1 ]; then
  echo missing parameters
  exit 1
fi
MONTH=$1 # yyyy-mm

# read APIKEY from global configuration
. `dirname $0`/config.sh

# add a newline before opening braces to facilitate parsing of single records
curl -s -X GET "https://zeit.io/api/v1/usr/time_records?from=${MONTH}-01&to=${MONTH}-31" \
  -H "accept: application/json" -H "apiKey: ${APIKEY}" \
  | sed 's/{/§{/g' | tr '§' '\012' | grep -v '^$'
