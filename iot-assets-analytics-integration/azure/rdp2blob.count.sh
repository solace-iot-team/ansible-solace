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
echo "# Script: "$(basename $(test -L "$0" && readlink "$0" || echo "$0")); echo

source $scriptDir/.lib/run.project-env.sh

#####################################################################################
# settings
#

  funcAppInfoFile=$(assertFile "$scriptDir/deployment/rdp2blob.add-settings.output.json") || exit
  outputDir="$scriptDir/tmp"
  outputFile="$outputDir/rdp2blob.count.output.json"

##############################################################################################################################
# Prepare

  mkdir $outputDir > /dev/null 2>&1

#####################################################################################
# run
#
  funcAppInfoJSON=$(cat $funcAppInfoFile | jq)
  dlConnectionString=$( echo $funcAppInfoJSON | jq -r '.[] | select(.name == "STORAGE_CONNECTION_STRING").value' )
  dlContainerName=$( echo $funcAppInfoJSON | jq -r '.[] | select(.name == "STORAGE_CONTAINER_NAME").value' )
  dlPathPrefix=$( echo $funcAppInfoJSON | jq -r '.[] | select(.name == "STORAGE_PATH_PREFIX").value' )

echo " >>> Retrieving blob file list ..."
  az storage blob list  --container-name $dlContainerName \
                        --prefix $dlPathPrefix \
                        --connection-string $dlConnectionString \
                        --query "[?properties.contentLength > \`0\`].name" \
                        --num-results "*" \
                        > $outputFile
  if [[ $? != 0 ]]; then echo " >>> ERR: retrieving blob file list"; exit 1; fi
echo " >>> Success."

echo " >>> Counting number of lines ..."
  numLines=$(wc -l < $outputFile)
  # subtract first & last line (array brackets)
  ((numFiles = numLines - 2))
echo " >>> Success."

echo
echo "******************************************************************************"
echo "# Container      : $dlContainerName"
echo "# Path           : $dlPathPrefix"
echo "# Number of File : $numFiles"
cat $outputFile | jq
echo


## The End.
#
