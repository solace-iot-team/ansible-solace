#!/usr/bin/env bash
# Copyright (c) 2020, Solace Corporation, Ricardo Gomez-Ulmke, <ricardo.gomez-ulmke@solace.com>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

scriptDir=$(cd $(dirname "$0") && pwd);
scriptName=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));
testRunner="test-runner"
scriptLogName="$testRunner.$scriptName"
if [ -z "$PROJECT_HOME" ]; then echo ">>> XT_ERROR: - $scriptLogName - missing env var: PROJECT_HOME"; exit 1; fi

############################################################################################################################
# Environment Variables

  if [ -z "$SOLACE_CLOUD_API_TOKEN" ]; then echo ">>> XT_ERROR: - $scriptLogName - missing env var: SOLACE_CLOUD_API_TOKEN"; exit 1; fi
  if [ -z "$LOG_DIR" ]; then echo ">>> XT_ERROR: - $scriptName - missing env var: LOG_DIR"; exit 1; fi

##############################################################################################################################
# Settings
baseLogDir=$LOG_DIR
testProjects=(
  "solace-cloud-full-mesh"
  "working-with-queues"
  "working-with-solace-cloud"
  "working-with-users-and-acls"
  "iot-assets-analytics-integration"
)

for testProject in ${testProjects[@]}; do

  export LOG_DIR="$baseLogDir/$testProject"
  mkdir -p $LOG_DIR

  echo ">>> Testing project: $testProject"

  runScript="$PROJECT_HOME/$testProject/.test/_run.sh"

  $runScript > "$LOG_DIR/_run.sh.out" 2>&1

  code=$?; if [[ $code != 0 ]]; then echo ">>> XT_ERROR - code=$code - runScript='$runScript' - $scriptLogName"; exit 1; fi

done


###
# The End.
