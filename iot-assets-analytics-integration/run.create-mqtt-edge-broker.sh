#!/bin/bash
# ---------------------------------------------------------------------------------------------
# MIT License
#
# Copyright (c) 2020, Solace Corporation, Ricardo Gomez-Ulmke (ricardo.gomez-ulmke@solace.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ---------------------------------------------------------------------------------------------

clear
scriptDir=$(cd $(dirname "$0") && pwd);
echo; echo "##############################################################################################################"
echo
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
  # END SELECT


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
# select inventory: switch between edge-broker and central-broker
edgeBrokerInventory=$(assertFile "./inventory.central-broker.yml") || exit
edgeBrokerInventory=$(assertFile "$deploymentDir/inventory.edge-broker.json") || exit
playbook="./playbook.create-mqtt.yml"

# --step --check -vvv
ansible-playbook \
                  -i $edgeBrokerInventory \
                  $playbook

if [[ $? != 0 ]]; then echo ">>> ERROR ..."; echo; exit 1; fi

echo; echo "##############################################################################################################"
echo; echo "tmp files:"
ls -la ./tmp/*.*
echo; echo



###
# The End.
