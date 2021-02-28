#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);
scriptName=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));

# set the python interpreter
  export ANSIBLE_PYTHON_INTERPRETER=$(python3 -c "import sys; print(sys.executable)")

# set verbosity
  export ANSIBLE_VERBOSITY=3

# set the working dir
  WORKING_DIR="$scriptDir/tmp"

# enable logging
  export ANSIBLE_SOLACE_ENABLE_LOGGING=True
  if [ -z "$ANSIBLE_SOLACE_LOG_PATH" ]; then export ANSIBLE_SOLACE_LOG_PATH="$WORKING_DIR/$scriptName.ansible-solace.log"; fi

# clean-up WORKING_DIR
  rm -rf $WORKING_DIR/solace-cloud.data_centers.yml
  rm -rf $ANSIBLE_SOLACE_LOG_PATH

# create solace cloud services
  ansible-playbook \
    "$scriptDir/playbook.sc-get-info.yml" \
    --extra-vars "WORKING_DIR=$WORKING_DIR" \
    --extra-vars "SOLACE_CLOUD_API_TOKEN=$SOLACE_CLOUD_API_TOKEN"
