#!/usr/bin/env bash

scriptDir=$(cd $(dirname "$0") && pwd);
scriptName=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));
if [ -z "$PROJECT_HOME" ]; then
  projectHome=${scriptDir%/ansible-solace/*}
  if [[ ! $projectHome =~ "ansible-solace" ]]; then
    projectHome=$projectHome/ansible-solace
  fi
  export PROJECT_HOME=$projectHome
fi
testRunner="test-runner"
scriptLogName="$testRunner.$scriptName"

if [ -z "$LOG_DIR" ]; then
  export LOG_DIR=$scriptDir/logs
fi
mkdir -p $LOG_DIR
rm -rf $LOG_DIR/*

export ANSIBLE_DEBUG=False
export ANSIBLE_VERBOSITY=3
export ANSIBLE_SOLACE_ENABLE_LOGGING=True

# add python and ansible version to LOG_DIR
pythonVersion=$(python -c "from platform import python_version; print(python_version())")
firstLine=$(ansible --version | head -1)
ansibleVersion=${firstLine//" "/"_"}
export LOG_DIR="$LOG_DIR/python_$pythonVersion/$ansibleVersion"
mkdir -p $LOG_DIR


FAILED=0
# $scriptDir/_run.sh > $LOG_DIR/$scriptLogName.out 2>&1
$scriptDir/_run.integration.sh
code=$?; if [[ $code != 0 ]]; then echo ">>> ERROR - code=$code - $scriptLogName"; FAILED=1; fi

##############################################################################################################################
# Check for errors

filePattern="$LOG_DIR"
errors=$(grep -n -r -e "ERROR" $filePattern )

if [[ -z "$errors" && "$FAILED" -eq 0 ]]; then
  echo ">>> FINISHED:SUCCESS - $scriptLogName"
  touch "$LOG_DIR/$scriptLogName.SUCCESS.out"
else
  echo ">>> FINISHED:FAILED";
  if [ ! -z "$errors" ]; then
    while IFS= read line; do
      echo $line >> "$LOG_DIR/$scriptLogName.ERROR.out"
    done < <(printf '%s\n' "$errors")
  fi
  exit 1
fi

###
# The End.
