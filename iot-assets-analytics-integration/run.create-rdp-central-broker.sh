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

# create bridge
  ansible-playbook \
    -i "$WORKING_DIR/central-broker.inventory.yml" \
    "$scriptDir/playbook.create-rdp.yml" \
    --extra-vars "WORKING_DIR=$WORKING_DIR" \
    --extra-vars "SOLACE_CLOUD_API_TOKEN=$SOLACE_CLOUD_API_TOKEN"

exit 1

##############################################################################################################################
# Select the RDP Function Settings

  rdpFunctionSettingsFile="$scriptDir/azure/deployment/broker-settings.az-func.json"
  if [[ ! -f "$rdpFunctionSettingsFile" ]]; then
    rdpFunctionSettingsFile=$(assertFile "$scriptDir/lib/settings.az-func.json")
  fi
  # copy it to deployment dir
  cp $rdpFunctionSettingsFile "$deploymentDir/settings.az-func.json"
  rdpFunctionSettingsFile="$deploymentDir/settings.az-func.json"

##############################################################################################################################
# Run
# select inventory
centralBrokerInventory=$(assertFile "./inventory.central-broker.yml") || exit
playbook="./playbook.create-rdp.yml"

# --step --check -vvv
ansible-playbook \
                  -i $centralBrokerInventory \
                  $playbook \
                  --extra-vars "SETTINGS_FILE=$rdpFunctionSettingsFile"

if [[ $? != 0 ]]; then echo ">>> ERROR ..."; echo; exit 1; fi

echo; echo "##############################################################################################################"
echo; echo "Deployment:"; echo;
ls -la $deploymentDir/*
echo; echo "tmp files:"
ls -la ./tmp/*.*
echo; echo



###
# The End.
