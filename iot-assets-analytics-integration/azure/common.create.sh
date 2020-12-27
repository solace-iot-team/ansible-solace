#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);

#####################################################################################
# settings
#
    WORKING_DIR="$scriptDir/../tmp"

    settingsFile="$scriptDir/settings.json"
    settings=$(cat $settingsFile | jq .)

        projectName=$( echo $settings | jq -r '.projectName' )
        azLocation=$( echo $settings | jq -r '.azLocation' )
        resourceGroup=$projectName

    templateFile="$scriptDir/common.create.template.json"
    parametersFile="$scriptDir/common.create.parameters.json"
    outputDir="$WORKING_DIR/azure-deployment"
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
