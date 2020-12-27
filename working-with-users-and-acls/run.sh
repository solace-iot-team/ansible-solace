#!/usr/bin/env bash

scriptDir=$(cd $(dirname "$0") && pwd);

# set the python interpreter
  export ANSIBLE_PYTHON_INTERPRETER=$(python3 -c "import sys; print(sys.executable)")

# set verbosity
  export ANSIBLE_VERBOSITY=3

# set the working dir
  WORKING_DIR="$scriptDir/tmp"

# create broker service
  ansible-playbook "$scriptDir/service.playbook.yml" --extra-vars "WORKING_DIR=$WORKING_DIR"

# configure broker service
  # enable logging
    export ANSIBLE_SOLACE_ENABLE_LOGGING=True
    export ANSIBLE_SOLACE_LOG_PATH="$WORKING_DIR/ansible-solace.log"
  ansible-playbook -i "$WORKING_DIR/broker.inventory.yml" "$scriptDir/configure.playbook.yml"  --extra-vars "AUTO_RUN=$AUTO_RUN"
