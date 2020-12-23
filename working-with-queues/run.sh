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
echo; echo "##############################################################################################################"
echo

source ./.lib/run.project-env.sh

##############################################################################################################################
# Settings

    # logging & debug: ansible
    ansibleLogFile="./tmp/ansible.log"
    export ANSIBLE_LOG_PATH="$ansibleLogFile"
    export ANSIBLE_DEBUG=False
    # logging: ansible-solace
    export ANSIBLE_SOLACE_LOG_PATH="./tmp/ansible-solace.log"
    export ANSIBLE_SOLACE_ENABLE_LOGGING=True
    # select inventory
    AS_SAMPLES_BROKER_INVENTORY=$(assertFile "broker.inventory.yml") || exit
    # select broker(s) inside inventory
    export AS_SAMPLES_BROKERS="all"
  # END SELECT


x=$(showEnv)
x=$(wait4Key)
##############################################################################################################################
# Prepare

export WORKING_DIR="$scriptDir/tmp"
mkdir -p $WORKING_DIR
if [ -z "$CLEAN_WORKING_DIR" ]; then rm -rf $WORKING_DIR/*; fi

mkdir ./tmp > /dev/null 2>&1
rm -f ./tmp/*.log
rm -f ./tmp/*hostvars*.json

##############################################################################################################################
# Run

playbook="./playbook.yml"

# --step --check -vvv
ansible-playbook -i $AS_SAMPLES_BROKER_INVENTORY \
                  $playbook \
                  --extra-vars "brokers=$AS_SAMPLES_BROKERS" \
                  -vvv

echo
echo "log files:"
ls -la ./tmp/*.log
echo; echo


###
# The End.
