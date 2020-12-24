#!/usr/bin/env bash

testProject="working-with-queues"
testProject="quickstart"
scriptDir=$(cd $(dirname "$0") && pwd);
scriptName=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));
scriptLogName="$testProject.$scriptName"

############################################################################################################################
# Prepare

  if [ -z "$LOG_DIR" ]; then export LOG_DIR="$scriptDir/logs"; fi
  mkdir -p $LOG_DIR; rm -rf $LOG_DIR/*

##############################################################################################################################
# Run
  export AUTO_RUN=True
  export ANSIBLE_SOLACE_LOG_PATH="$LOG_DIR/$scriptLogName.ansible-solace.log"
  export ANSIBLE_LOG_PATH="$LOG_DIR/$scriptLogName.ansible.log"

  runScript="$scriptDir/../run.create.sh"
  $runScript
  code=$?; if [[ $code != 0 ]]; then echo ">>> ERROR - $code - script:$scriptLogName, script:$runScript"; exit 1; fi

  runScript="$scriptDir/../run.facts.sh"
  $runScript
  code=$?; if [[ $code != 0 ]]; then echo ">>> ERROR - $code - script:$scriptLogName, script:$runScript"; exit 1; fi

  runScript="$scriptDir/../run.delete.sh"
  $runScript
  code=$?; if [[ $code != 0 ]]; then echo ">>> ERROR - $code - script:$scriptLogName, script:$runScript"; exit 1; fi

###
# The End.
