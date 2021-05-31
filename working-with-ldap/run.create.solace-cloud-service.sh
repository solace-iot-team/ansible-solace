#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);
scriptName=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));

# check env vars
  if [ -z "$WORKING_WITH_LDAP_SOLACE_CLOUD_API_TOKEN" ]; then echo ">>> XT_ERROR: - $scriptName - missing env var: WORKING_WITH_LDAP_SOLACE_CLOUD_API_TOKEN"; exit 1; fi

# set the python interpreter
  export ANSIBLE_PYTHON_INTERPRETER=$(python3 -c "import sys; print(sys.executable)")

# set verbosity
  export ANSIBLE_VERBOSITY=3

# set the working dir
  WORKING_DIR="$scriptDir/tmp"; mkdir -p $WORKING_DIR

# enable logging
  export ANSIBLE_SOLACE_ENABLE_LOGGING=True
  if [ -z "$ANSIBLE_SOLACE_LOG_PATH" ]; then export ANSIBLE_SOLACE_LOG_PATH="$WORKING_DIR/$scriptName.ansible-solace.log"; fi

# clean-up log file
  rm -f $ANSIBLE_SOLACE_LOG_PATH

# run playbook
  ansible-playbook \
    "$scriptDir/playbook.create.solace-cloud-service.yml" \
    --extra-vars "WORKING_DIR=$WORKING_DIR" \
    --extra-vars "SOLACE_CLOUD_API_TOKEN=$WORKING_WITH_LDAP_SOLACE_CLOUD_API_TOKEN"
  code=$?; if [[ $code != 0 ]]; then echo ">>> XT_ERROR - $code"; exit 1; fi
