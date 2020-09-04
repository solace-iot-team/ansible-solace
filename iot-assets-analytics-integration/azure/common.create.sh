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

#####################################################################################
# settings
#
    scriptDir=$(cd $(dirname "$0") && pwd);
    settingsFile="$scriptDir/settings.json"
    settings=$(cat $settingsFile | jq .)

        projectName=$( echo $settings | jq -r '.projectName' )
        azLocation=$( echo $settings | jq -r '.azLocation' )
        resourceGroup=$projectName

    templateFile="$scriptDir/common.create.template.json"
    parametersFile="$scriptDir/common.create.parameters.json"
    outputDir="$scriptDir/deployment"
    outputFile="common.create.output.json"

echo
echo "##########################################################################################"
echo "# Create Azure Resources"
echo "# Project Name   : '$projectName'"
echo "# Location       : '$azLocation'"
echo "# Template       : '$templateFile'"
echo "# Parameters     : '$parametersFile'"
echo

#####################################################################################
# Prepare Dirs
mkdir $outputDir > /dev/null 2>&1
rm -f $outputDir/*

#####################################################################################
# Resource Group
echo " >>> Creating Resource Group ..."
resp=$(az group create \
  --name $resourceGroup \
  --location "$azLocation" \
  --tags projectName=$projectName \
  --verbose)
if [[ $? != 0 ]]; then echo " >>> ERR: creating resource group"; exit 1; fi
echo $resp | jq
echo " >>> Success."

#####################################################################################
# Run ARM Template
echo " >>> Creating Common Resources ..."
az deployment group create \
  --name $projectName"_Common_Deployment" \
  --resource-group $resourceGroup \
  --template-file $templateFile \
  --parameters projectName=$projectName \
  --parameters $parametersFile \
  --verbose \
  > "$outputDir/$outputFile"

if [[ $? != 0 ]]; then echo " >>> ERR: creating resources."; exit 1; fi
echo " >>> Success."

###
# The End.
