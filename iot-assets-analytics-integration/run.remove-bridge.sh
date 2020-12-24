#!/usr/bin/env bash

scriptDir=$(cd $(dirname "$0") && pwd);

# set the python interpreter
  export ANSIBLE_PYTHON_INTERPRETER=$(python3 -c "import sys; print(sys.executable)")

# set verbosity
  export ANSIBLE_VERBOSITY=3

# set the working dir
  WORKING_DIR="$scriptDir/tmp"

# enable logging
  export ANSIBLE_SOLACE_ENABLE_LOGGING=True
  export ANSIBLE_SOLACE_LOG_PATH="$WORKING_DIR/ansible-solace.log"

# playbook
ansible-playbook \
  --forks 1 \
  -i "$WORKING_DIR/central-broker.inventory.yml" \
  -i "$WORKING_DIR/edge-broker.inventory.yml" \
  "$scriptDir/playbook.remove-bridge.yml" \
  --extra-vars "WORKING_DIR=$WORKING_DIR" \
  --extra-vars "SOLACE_CLOUD_API_TOKEN=$SOLACE_CLOUD_API_TOKEN"


exit 1

clear
scriptDir=$(cd $(dirname "$0") && pwd);
echo; echo "##############################################################################################################"
echo "# Script: "$(basename $(test -L "$0" && readlink "$0" || echo "$0"));

source $scriptDir/.lib/run.project-env.sh

##############################################################################################################################
# Settings

    # logging & debug: ansible
    ansibleLogFile="./tmp/ansible.log"
    export ANSIBLE_LOG_PATH="$ansibleLogFile"
    export ANSIBLE_DEBUG=False
    export ANSIBLE_VERBOSITY=3
    # logging: ansible-solace
    export ANSIBLE_SOLACE_LOG_PATH="./tmp/ansible-solace.log"
    export ANSIBLE_SOLACE_ENABLE_LOGGING=True

x=$(showEnv)
x=$(wait4Key)
##############################################################################################################################
# Prepare

tmpDir="$scriptDir/tmp"
deploymentDir="$scriptDir/deployment"
mkdir $tmpDir > /dev/null 2>&1
rm -rf $tmpDir/*
mkdir $deploymentDir > /dev/null 2>&1

##############################################################################################################################
# Run
# select inventory
centralBrokerInventory=$(assertFile "$scriptDir/inventory.central-broker.yml") || exit
edgeBrokerInventory=$(assertFile "$deploymentDir/inventory.edge-broker.json") || exit
playbook="$scriptDir/playbook.remove-bridge.yml"

# --step --check -vvv
ansible-playbook \
                  -i $centralBrokerInventory \
                  -i $edgeBrokerInventory \
                  $playbook

if [[ $? != 0 ]]; then echo ">>> ERROR ..."; echo; exit 1; fi

echo; echo "##############################################################################################################"
echo; echo "tmp files:"
ls -la ./tmp/*.*
echo; echo



###
# The End.
