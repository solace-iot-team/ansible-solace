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
echo "# Script: "$(basename $(test -L "$0" && readlink "$0" || echo "$0"));

source ./.lib/run.project-env.sh

##############################################################################################################################
# Settings

  #   # logging & debug: ansible
  #   ansibleLogFile="./tmp/ansible.log"
  #   export ANSIBLE_LOG_PATH="$ansibleLogFile"
  #   export ANSIBLE_DEBUG=False
  #   # logging: ansible-solace
  #   export ANSIBLE_SOLACE_LOG_PATH="./tmp/ansible-solace.log"
  #   export ANSIBLE_SOLACE_ENABLE_LOGGING=True
  #   # select inventory
  #   export AS_SAMPLES_BROKER_INVENTORY=$(assertFile "broker.inventory.yml") || exit
  #   # select broker(s) inside inventory
  #   export AS_SAMPLES_BROKERS="all"
  # # END SELECT


x=$(showEnv)
x=$(wait4Key)
##############################################################################################################################
# Prepare
rm ./tmp/*
##############################################################################################################################
# Run

runScripts=(
  # create
  "./run.create-sc-service.sh"
  "./run.create-bridge.sh"
  "./run.create-rdp-central-broker.sh"
  "./run.create-mqtt-edge-broker.sh"
  # get details
  "./run.get.sh"
  # remove again
  "./run.remove-mqtt-edge-broker.sh"
  "./run.remove-rdp-central-broker.sh"
  "./run.remove-bridge.sh"
  "./run.remove-sc-service.sh"

)

for runScript in ${runScripts[@]}; do

  echo; echo "##############################################################################################################"
  echo "# calling: $runScript"

  $runScript

  if [[ $? != 0 ]]; then echo ">>> ERR:$runScript. aborting."; echo; exit 1; fi

done
###
# The End.
