#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);
scriptName=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));

# check env vars
  if [ -z "$WORKING_WITH_LDAP_JUMPCLOUD_ORG_ID" ]; then echo ">>> XT_ERROR: - $scriptName - missing env var: WORKING_WITH_LDAP_JUMPCLOUD_ORG_ID"; exit 1; fi

# set the python interpreter
  export ANSIBLE_PYTHON_INTERPRETER=$(python3 -c "import sys; print(sys.executable)")

# set verbosity
  export ANSIBLE_VERBOSITY=3

# set the working dir
if [ -z "$WORKING_DIR" ]; then WORKING_DIR="$scriptDir/tmp"; mkdir -p $WORKING_DIR; fi

# run playbook
  ansible-playbook \
    "$scriptDir/playbook.jumpcloud-check.yml" \
    --extra-vars "WORKING_DIR=$WORKING_DIR" \
    --extra-vars "JUMP_CLOUD_ORG_ID=$WORKING_WITH_LDAP_JUMPCLOUD_ORG_ID"
  code=$?; if [[ $code != 0 ]]; then echo ">>> XT_ERROR - $code"; exit 1; fi
