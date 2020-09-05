#!/bin/bash
# ---------------------------------------------------------------------------------------------
# MIT License
#
# Copyright (c) 2020, Solace Corporation, Ricardo Gomez-Ulmke (ricardo.gomez-ulmke@solace.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ---------------------------------------------------------------------------------------------

#####################################################################################
# settings
#
    scriptDir=$(cd $(dirname "$0") && pwd);
    scriptName=$(basename $(test -L "$0" && readlink "$0" || echo "$0"))
    resultsDir="$scriptDir/tmp"
    resultsOutputFile="$resultsDir/events-sent.central-broker.json"

#####################################################################################
# Prepare Dirs
mkdir $resultsDir > /dev/null 2>&1
rm -f $resultsOutputFile

clear
echo; echo "##############################################################################################################"
echo "# Script: $scriptName"

brokerRestHost="localhost"
brokerRestPort=9000

# topic pattern: {domain}/{asset-type-id}/{asset-id}/{region-id}/{data-type-id}
domain="as-iot-assets"
assetTypeId="asset-type-a"
assetId="asset-id-1"
regionId="region-id-1"
dataTypeId_0="stream-metrics"
dataTypeId_1="stream-metrics-1"
dataTypeId_2="stream-metrics-2"

topics=(
  "$domain/$assetTypeId/$assetId/$regionId/$dataTypeId_0"
  "$domain/$assetTypeId/$assetId/$regionId/$dataTypeId_1"
  "$domain/$assetTypeId/$assetId/$regionId/$dataTypeId_2"
)

msgSentCounter=0

for i in {1..10}; do
  echo " >>> sending event batch number: $i"
  for topic in ${topics[@]}; do
    ((msgSentCounter++))
    echo "   >> ($msgSentCounter)-topic: $topic"
    timestamp=$(date +"%Y-%m-%dT%T.%3NZ")
    payload='
    {
      "meta": {
        "topic": "'"$topic"'",
        "timestamp": "'"$timestamp"'",
        "eventBatchNum": "'"$i"'"
      },
      "event": {
        "metric-1": 100,
        "metric-2": 200
      }
    }
    '
    _brokerUrl="http://$brokerRestHost:$brokerRestPort/$topic"
    echo $payload | curl \
      -H "Content-Type: application/json" \
      -H "Solace-delivery-mode: direct" \
      -X POST \
      $_brokerUrl \
      -d @- \
      # -v \
    if [[ $? != 0 ]]; then echo ">>> ERROR ..."; echo; exit 1; fi
  done
done

timestamp=$(date +"%Y-%m-%dT%T.%3NZ")
resultJSON='
{
    "timestamp": "'"$timestamp"'",
    "numberMsgsSent": "'"$msgSentCounter"'"
}
'
echo $resultJSON | jq > $resultsOutputFile
cat $resultsOutputFile | jq
echo
echo
# The End.
