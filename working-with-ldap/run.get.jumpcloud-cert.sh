#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);
scriptName=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));


# set the working dir
  if [ -z "$WORKING_DIR" ]; then WORKING_DIR="$scriptDir/tmp"; mkdir -p $WORKING_DIR; fi
# set env
  pemFile="$WORKING_DIR/jumpcloud.ldap.pem"
# get cert
echo -n | openssl s_client -connect ldap.jumpcloud.com:636 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > $pemFile
# show
echo ">>> pem file: $pemFile"
cat $pemFile
