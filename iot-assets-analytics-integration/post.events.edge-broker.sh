#!/usr/bin/env bash

scriptDir=$(cd $(dirname "$0") && pwd);

#####################################################################################
# settings
#
    WORKING_DIR="$scriptDir/tmp"
    resultsOutputFile="$WORKING_DIR/events-sent.edge-broker.json"
    connectionDetailsFile="$WORKING_DIR/edge-broker.client_connection_details.json"
    connectionDetailsJSON=$(cat $connectionDetailsFile | jq . )
    isRestEnabled=$( echo $connectionDetailsJSON | jq -r '.clientConnectionDetails.REST.enabled' )
    if [ "$isRestEnabled" == "false" ]; then echo ">>> ERR: REST is not enabled on the edge broker"; exit 1; fi
    restUsername=$( echo $connectionDetailsJSON | jq -r '.vpnClientConnectionDetails.REST.authentication.username' )
    restPassword=$( echo $connectionDetailsJSON | jq -r '.vpnClientConnectionDetails.REST.authentication.password' )
    restPlainUri=$( echo $connectionDetailsJSON | jq -r '.vpnClientConnectionDetails.REST.plain.uri')

#####################################################################################
# Prepare Dirs
mkdir $WORKING_DIR > /dev/null 2>&1
rm -f $resultsOutputFile

#####################################################################################
# Prepare Events

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
    _brokerUrl="$restPlainUri/$topic"
    echo $payload | curl \
      -u $restUsername:$restPassword \
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
echo $resultJSON | jq . > $resultsOutputFile
cat $resultsOutputFile | jq .
