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

# set the inventory file
  inventoryFile="$WORKING_DIR/actual_db/api_broker/api_broker_vpns.inventory.yml"

# run playbook
  ansible-playbook \
    --forks 1 \
    -i $inventoryFile \
    "$scriptDir/playbook.create-vpn-bridge.yml" \
    --extra-vars "WORKING_DIR=$WORKING_DIR" \
    --extra-vars "DATE_TIME=$DATE_TIME"
