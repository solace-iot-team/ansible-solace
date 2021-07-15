#!/usr/bin/env bash

scriptDir=$(cd $(dirname "$0") && pwd);

# set the python interpreter
  export ANSIBLE_PYTHON_INTERPRETER=$(python3 -c "import sys; print(sys.executable)")

# set verbosity
  export ANSIBLE_VERBOSITY=3

# set the working dir
  if [ -z "$WORKING_DIR" ]; then export WORKING_DIR="$scriptDir/sample-working-dir"; fi

# enable logging
  export ANSIBLE_SOLACE_ENABLE_LOGGING=True

# set the timestamp for the log files
  export DATE_TIME=$(date '+%Y-%m-%d-%H-%M-%S')

# run playbook
  ansible-playbook \
    -i "$WORKING_DIR/config_db/inventories/api_broker.inventory.yml" \
    "$scriptDir/playbook.create-message-vpns.yml" \
    --extra-vars "WORKING_DIR=$WORKING_DIR" \
    --extra-vars "DATE_TIME=$DATE_TIME"
