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
  rm -rf $ANSIBLE_SOLACE_LOG_PATH

# get the list of inventory files, at least two
  inventoryFilesPattern="$WORKING_DIR/solace-cloud.*.inventory.yml"
  inventoryFiles=$(ls $inventoryFilesPattern)
  inventoryArg=""
  counter=0
  for inventoryFile in ${inventoryFiles[@]}; do
    ((counter++))
    inventoryArg+="-i $inventoryFile "
  done
  if [ "$counter" -lt 2 ]; then echo ">>> ERROR: found $counter inventory file(s). full mesh requires at least 2. ls $inventoryFilesPattern"; exit 1; fi

# test full mesh dmr cluster
  ansible-playbook \
    --forks 1 \
    $inventoryArg \
    "$scriptDir/playbook.test.full-mesh-dmr-cluster.yml" \
    --extra-vars "WORKING_DIR=$WORKING_DIR" \
    --extra-vars "SOLACE_CLOUD_API_TOKEN=$SOLACE_CLOUD_API_TOKEN"
