#!/usr/bin/env bash
scriptDir=$(cd $(dirname "$0") && pwd);

##############################################################################################################################
# Settings

  WORKING_DIR="$scriptDir/../tmp"

  deploymentDir="$WORKING_DIR/azure-deployment"
  settingsTemplateFile="$scriptDir/../vars/settings.az-func.json"
  settingsFile="$deploymentDir/settings.az-func.json"
  funcAppInfoFile="$deploymentDir/rdp2blob.func-app-info.output.json"
  certName="BaltimoreCyberTrustRoot.crt.pem"

##############################################################################################################################
# Run

# download certificate
curl --silent -L "https://cacerts.digicert.com/$certName" > $deploymentDir/$certName
if [[ $? != 0 ]]; then echo ">>> ERR:$runScript"; echo; exit 1; fi
# create settings file
funcAppInfoJSON=$(cat $funcAppInfoFile | jq . )
settingsJSON=$(cat $settingsTemplateFile | jq . )
export rdp2Blob_azFuncCode=$( echo $funcAppInfoJSON | jq -r '.functions."solace-rdp-2-blob".code' )
settingsJSON=$(echo $settingsJSON | jq ".az_rdp_2_blob_func.az_func_code=env.rdp2Blob_azFuncCode")
export rdp2Blob_azFuncHost=$( echo $funcAppInfoJSON | jq -r '.defaultHostName' )
settingsJSON=$(echo $settingsJSON | jq ".az_rdp_2_blob_func.az_func_host=env.rdp2Blob_azFuncHost")
export hostDomain="*."${rdp2Blob_azFuncHost#*.}
settingsJSON=$(echo $settingsJSON | jq ".az_rdp_2_blob_func.az_func_trusted_common_name=env.hostDomain")
export certFile="$deploymentDir/$certName"
settingsJSON=$(echo $settingsJSON | jq ".az_cert_auth.certificate_pem_file=env.certFile")
settingsJSON=$(echo $settingsJSON | jq ".az_rdp_2_blob_func.az_func_tls_enabled=true")
settingsJSON=$(echo $settingsJSON | jq ".az_rdp_2_blob_func.az_func_port=443")
echo $settingsJSON > $settingsFile

echo
echo "##########################################################################################"
echo "# Certificate: $deploymentDir/$certName"
echo "# Broker Settings: $settingsFile"
cat $settingsFile | jq .

###
# The End.
