#!/usr/bin/env bash

testProject="working-with-users-and-acls"
scriptDir=$(cd $(dirname "$0") && pwd);
scriptName=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));
scriptLogName="$testProject.$scriptName"

############################################################################################################################
# Prepare

  if [ -z "$LOG_DIR" ]; then
    export LOG_DIR="$scriptDir/logs";
    mkdir -p $LOG_DIR;
    rm -rf $LOG_DIR/*
  fi

##############################################################################################################################
# Run
  export AUTO_RUN=True
  export ANSIBLE_SOLACE_LOG_PATH="$LOG_DIR/$scriptLogName.ansible-solace.log"
  export ANSIBLE_LOG_PATH="$LOG_DIR/$scriptLogName.ansible.log"

  runScript="$scriptDir/../run.sh"
  $runScript
  code=$?; if [[ $code != 0 ]]; then echo ">>> XT_ERROR - $code - script:$scriptLogName, script:$runScript"; exit 1; fi

##############################################################################################################################
# teardown
  export WORKING_DIR="$scriptDir/../tmp"
  playbook="$scriptDir/teardown.playbook.yml"
  ansible-playbook $playbook --extra-vars "WORKING_DIR=$WORKING_DIR"
  code=$?; if [[ $code != 0 ]]; then echo ">>> XT_ERROR - $code - script:$scriptLogName, playbook:$playbook"; exit 1; fi

echo ">>> SUCCESS: $scriptLogName"

###
# The End.
