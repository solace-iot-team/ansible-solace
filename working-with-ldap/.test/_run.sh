#!/usr/bin/env bash

testProject="working-with-ldap"
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
  export WORKING_DIR="$LOG_DIR/tmp"; mkdir -p $WORKING_DIR
  export ANSIBLE_LOG_PATH="$LOG_DIR/$scriptLogName.ansible.log"

##############################################################################################################################
# Run

  # careful with workflow install -> probably won't work, install in workflow manually
  # runScript="pip install -r $scriptDir/../requirements.txt"
  # $runScript
  # code=$?; if [[ $code != 0 ]]; then echo ">>> XT_ERROR - $code - script:$scriptLogName, script:$runScript"; exit 1; fi

  runScript="$scriptDir/../run.check.jumpcloud-config.sh"
  $runScript
  code=$?; if [[ $code != 0 ]]; then echo ">>> XT_ERROR - $code - script:$scriptLogName, script:$runScript"; exit 1; fi

  runScript="$scriptDir/../run.get.jumpcloud-cert.sh"
  $runScript
  code=$?; if [[ $code != 0 ]]; then echo ">>> XT_ERROR - $code - script:$scriptLogName, script:$runScript"; exit 1; fi

  runScript="$scriptDir/../run.create.local-service.sh"
  $runScript
  code=$?; if [[ $code != 0 ]]; then echo ">>> XT_ERROR - $code - script:$scriptLogName, script:$runScript"; exit 1; fi

  runScript="$scriptDir/../run.create.solace-cloud-service.sh"
  $runScript
  code=$?; if [[ $code != 0 ]]; then echo ">>> XT_ERROR - $code - script:$scriptLogName, script:$runScript"; exit 1; fi

  runScript="$scriptDir/../run.configure.brokers.sh"
  $runScript
  code=$?; if [[ $code != 0 ]]; then echo ">>> XT_ERROR - $code - script:$scriptLogName, script:$runScript"; exit 1; fi

  runScript="$scriptDir/../run.test.brokers.sh"
  $runScript
  code=$?; if [[ $code != 0 ]]; then echo ">>> XT_ERROR - $code - script:$scriptLogName, script:$runScript"; exit 1; fi

  runScript="$scriptDir/../run.teardown.brokers.sh"
  $runScript
  code=$?; if [[ $code != 0 ]]; then echo ">>> XT_ERROR - $code - script:$scriptLogName, script:$runScript"; exit 1; fi

echo ">>> SUCCESS: $scriptLogName"


###
# The End.
