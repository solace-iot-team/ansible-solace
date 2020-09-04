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

#####################################################################################
# settings
#
    scriptDir=$(cd $(dirname "$0") && pwd);
    deploymentDir="$scriptDir/deployment"
    settingsFile="$scriptDir/settings.json"
    settings=$(cat $settingsFile | jq .)
      projectName=$( echo $settings | jq -r '.projectName' )
      resourceGroup=$projectName

echo
echo "##########################################################################################"
echo "# Delete Project from Azure"
echo "# Project Name   : '$projectName'"
echo
echo " >>> Deleting Resource Group $projectName ..."
echo
  az group delete \
    --name $resourceGroup \
    --verbose
  if [[ $? != 0 ]]; then echo " >>> ERR: deleting resource group"; exit 1; fi
echo " >>> Success."

rm -f $deploymentDir/*

###
# The End.
