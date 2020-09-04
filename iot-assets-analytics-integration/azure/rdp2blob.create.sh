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
    source $scriptDir/.lib/functions.sh; if [[ $? != 0 ]]; then echo " >>> ERR: sourcing functions.sh."; exit 1; fi
    settingsFile="$scriptDir/settings.json"
    settings=$(cat $settingsFile | jq .)

        projectName=$( echo $settings | jq -r '.projectName' )
        azLocation=$( echo $settings | jq -r '.azLocation' )
        resourceGroup=$projectName
        functionAppAccountName=$( echo $settings | jq -r '.functionAppAccountName' )
        # function specific
        export functionElement="rdp2blobFunction"
        functionName=$( echo $settings | jq -r '."'$functionElement'".functionName' )
        dataLakeStorageContainerName=$( echo $settings | jq -r '."'$functionElement'".dataLakeStorageContainerName' )
        dataLakeFixedPathPrefix=$( echo $settings | jq -r '."'$functionElement'".dataLakeFixedPathPrefix' )

    releaseDir="$scriptDir/release"
    zipDeployFile=$(ls $releaseDir/*.zip)
    templateFile="rdp2blob.create.template.json"
    parametersFile="rdp2blob.create.parameters.json"
    outputDir="$scriptDir/deployment"
    outputFileCreateBlob="rdp2blob.create-blob.output.json"
    outputFileAddSettings="rdp2blob.add-settings.output.json"
    outputFileZipDeploy="rdp2blob.zip-deploy.output.json"
    outputFileFuncAppInfo="rdp2blob.func-app-info.output.json"

echo
echo "##########################################################################################"
echo "# Create RDP-2-Blob Resources & Deploy"
echo "# Project Name   : '$projectName'"
echo "# Location       : '$azLocation'"
echo "# Template       : '$templateFile'"
echo "# Parameters     : '$parametersFile'"
echo

#####################################################################################
# Prepare Dirs
mkdir $outputDir > /dev/null 2>&1
rm -f $outputDir/$outputFileCreateBlob
rm -f $outputDir/$outputFileAddSettings
rm -f $outputDir/$outputFileZipDeploy
rm -f $outputDir/$outputFileFuncAppInfo

#####################################################################################
# Run ARM Template
  echo " >>> Creating RDP2Blob Resources ..."
  az deployment group create \
    --name $projectName"_RDP2Blob_Deployment" \
    --resource-group $projectName \
    --template-file $templateFile \
    --parameters projectName=$projectName \
    --parameters $parametersFile \
    --verbose \
    > "$outputDir/$outputFileCreateBlob"

  if [[ $? != 0 ]]; then echo " >>> ERR: creating resources."; exit 1; fi
  echo " >>> Success."

#####################################################################################
# Add Settings to Function App

    jsonPath=".properties.outputs.dataLakeStorageAccountConnectionString.value"
  dataLakeStorageConnectionString=$( cat $outputDir/$outputFileCreateBlob | jq -r $jsonPath )
    if [[ $? != 0 ]]; then echo " >>> ERR: reading $jsonPath from $outputDir/$outputFileCreateBlob"; exit 1; fi
    if [ "$dataLakeStorageConnectionString" == "null" ]; then echo ">>> ERR: reading $jsonPath from $outputDir/$outputFileCreateBlob"; echo; exit 1; fi

    # cross-check appsettings with template.app.settings.json
    templateAppSettingsFile=$(assertFile "$releaseDir/template.app.settings.json") || exit
    templateAppSettingsJSON=$(cat $templateAppSettingsFile | jq)
      if [[ $? != 0 ]]; then echo " >>> ERR: file not found: $templateAppSettingsFile."; exit 1; fi
    jsonPath=".STORAGE_CONTAINER_NAME"
      val=$(echo $templateAppSettingsJSON | jq -r $jsonPath)
      if [ "$val" == "null" ]; then echo ">>> ERR: reading $jsonPath from $templateAppSettingsFile"; echo; exit 1; fi
    jsonPath=".STORAGE_PATH_PREFIX"
      val=$(echo $templateAppSettingsJSON | jq -r $jsonPath)
      if [ "$val" == "null" ]; then echo ">>> ERR: reading $jsonPath from $templateAppSettingsFile"; echo; exit 1; fi
    jsonPath=".STORAGE_CONNECTION_STRING"
      val=$(echo $templateAppSettingsJSON | jq -r $jsonPath)
      if [ "$val" == "null" ]; then echo ">>> ERR: reading $jsonPath from $templateAppSettingsFile"; echo; exit 1; fi

echo " >>> Adding Function App Setttings ..."
  az functionapp config appsettings set \
    --name $functionAppAccountName \
    --resource-group $resourceGroup \
    --settings \
      "STORAGE_CONTAINER_NAME=$dataLakeStorageContainerName" \
      "STORAGE_PATH_PREFIX=$dataLakeFixedPathPrefix" \
      "STORAGE_CONNECTION_STRING=$dataLakeStorageConnectionString" \
      --verbose \
      > "$outputDir/$outputFileAddSettings"

  if [[ $? != 0 ]]; then echo " >>> ERR: adding functionapp settings"; exit 1; fi
echo " >>> Success."

#####################################################################################
# Deploy Function

echo " >>> Deploying Function: $zipDeployFile ..."
  az functionapp deployment source config-zip \
      --resource-group $resourceGroup \
      --name $functionAppAccountName \
      --src $zipDeployFile \
      --verbose \
      > "$outputDir/$outputFileZipDeploy"

  if [[ $? != 0 ]]; then echo " >>> ERR: deploying function"; exit 1; fi
echo " >>> Success."

#####################################################################################
# Retrieve the app info of the function

echo " >>> Retrieving Function Info ..."
  rdpAppInfo=$(az functionapp show --name $functionAppAccountName --resource-group $resourceGroup)
  if [[ $? != 0 ]]; then echo ">>> ERR: retrieving function app info."; exit 1; fi
echo " >>> Success."

echo " >>> Retrieving Function Keys ..."
  rdpAppInfoId=$(echo $rdpAppInfo | jq -r '.id')
  # echo "rdpAppInfoId='$rdpAppInfoId'"
  rdpAppkeys=$(az rest --method post --uri $rdpAppInfoId/functions/$functionName/listKeys?api-version=2018-11-01)
  if [[ $? != 0 ]]; then echo ">>> ERR: retrieving function keys."; exit 1; fi
  # echo $rdpAppkeys | jq .
  rdpAppFuncCode=$( echo $rdpAppkeys | jq -r ".default")
  # echo "rdpAppFuncCode=$rdpAppFuncCode"
# add the code
  export rdpAppFuncCode
  export functionName
  rdpAppInfo=$( echo $rdpAppInfo | jq -r '.functions."'$functionName'".code=env.rdpAppFuncCode' )
  echo $rdpAppInfo | jq . > $outputDir/$outputFileFuncAppInfo
echo " >>> Success."

echo "##########################################################################################"
echo "# Output dir  : $outputDir"
echo "# Output files:"
cd $outputDir
ls -la *.json
cd $scriptDir
echo
echo
###
# The End.
