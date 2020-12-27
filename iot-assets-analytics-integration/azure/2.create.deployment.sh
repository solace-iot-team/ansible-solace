#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);

#####################################################################################
# settings
#

  WORKING_DIR="$scriptDir/../tmp"

  settingsFile="$scriptDir/settings.json"
  settings=$(cat $settingsFile | jq .)
  projectName=$( echo $settings | jq -r '.projectName' )

echo
echo "##########################################################################################"
echo "# Deploy Project to Azure"
echo "# Project Name   : '$projectName'"
echo "# Settings:"
echo $settings | jq

  echo; read -n 1 -p "- Press key to continue, CTRL-C to exit ..." x; echo; echo

runScript="$scriptDir/common.create.sh"; echo ">>> $runScript";
  $runScript; if [[ $? != 0 ]]; then echo ">>> ERR:$runScript"; echo; exit 1; fi
  cd $scriptDir

runScript="$scriptDir/rdp2blob.create.sh"; echo ">>> $runScript";
  $runScript; if [[ $? != 0 ]]; then echo ">>> ERR:$runScript"; echo; exit 1; fi
  cd $scriptDir

runScript="$scriptDir/rdp2blob.create.broker-settings.sh"; echo ">>> $runScript";
  $runScript; if [[ $? != 0 ]]; then echo ">>> ERR:$runScript"; echo; exit 1; fi
  cd $scriptDir
