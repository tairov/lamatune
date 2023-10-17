#!/bin/bash
source ./config.sh

RESULTS="$1"
FILE="$2"

if [ -z "$RESULTS" ]; then
    echo "Usage: $0 <results_json> <data_file>"
    exit 1
fi
# check files exists
if [ ! -f "$RESULTS" ]; then
    echo "File not found: $RESULTS"
    exit 1
fi

if [ ! -f "$FILE" ]; then
    echo "File not found: $FILE"
    exit 1
fi

echo Append results to data file $FILE
RUNS=$(cat $RESULTS | jq ".results[0].times | length")
COMMANDS=$(cat $RESULTS | jq ".results | length")
# get first 4 symbols of md5sum
RESID=`md5 -r $RESULTS | cut -c1-4`
CONSTNAME="data_${RESID}_cmds_${COMMANDS}_runs_${RUNS}"

echo "const $CONSTNAME = " >> $FILE
cat $RESULTS >> $FILE
echo ";" >> $FILE

echo Added data points $CONSTNAME to $FILE