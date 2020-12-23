#!/usr/bin/env bash

scriptDir=$(cd $(dirname "$0") && pwd);
scriptName=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));
scriptLogName="$scriptDir.$scriptName"
if [ -z "$TEST_PROJECT" ]; then echo ">>> ERROR: - $scriptLogName - missing env var: TEST_PROJECT"; exit 1; fi
scriptLogName="$TEST_PROJECT.$scriptName"
if [ -z "$PROJECT_HOME" ]; then echo ">>> ERROR: - $scriptLogName - missing env var: PROJECT_HOME"; exit 1; fi
source "$PROJECT_HOME/.lib/functions.sh"

############################################################################################################################
# Environment Variables

  if [ -z "$LOG_DIR" ]; then echo ">>> ERROR: - $scriptLogName - missing env var: LOG_DIR"; exit 1; fi

##############################################################################################################################
# Prepare

  export ANSIBLE_SOLACE_LOG_PATH="$LOG_DIR/$scriptLogName.ansible-solace.log"
  export ANSIBLE_LOG_PATH="$LOG_DIR/$scriptLogName.ansible.log"

##############################################################################################################################
# Settings

echo ">>> ERROR: call the test for $TEST_PROJECT"

exit 1

runScript="$scriptDir/run.sh"
$runScript
code=$?; if [[ $code != 0 ]]; then echo ">>> ERROR - $code - script:$scriptLogName, script:$runScript"; exit 1; fi

echo ">>> SUCCESS: $scriptLogName"

###
# The End.
