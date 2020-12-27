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
        functionAppAccountName=$( echo $settings | jq -r '.functionAppAccountName' )
        # function specific
        export functionElement="rdp2blobFunction"
        functionName=$( echo $settings | jq -r '."'$functionElement'".functionName' )
        dataLakeStorageContainerName=$( echo $settings | jq -r '."'$functionElement'".dataLakeStorageContainerName' )
        dataLakeFixedPathPrefix=$( echo $settings | jq -r '."'$functionElement'".dataLakeFixedPathPrefix' )

    releaseDir="$WORKING_DIR/release"
    zipDeployFile=$(ls $releaseDir/*.zip)
    templateFile="rdp2blob.create.template.json"
    parametersFile="rdp2blob.create.parameters.json"
    outputDir="$WORKING_DIR/azure-deployment"
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
    templateAppSettingsFile="$releaseDir/template.app.settings.json"
    templateAppSettingsJSON=$(cat $templateAppSettingsFile | jq .)
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
