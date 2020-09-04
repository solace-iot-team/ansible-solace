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
    releaseDir="$scriptDir/release"
    tmpDir="$scriptDir/tmp"

    releaseProject="solace-int-rdp-az-funcs"
    gitReleaseURL="https://api.github.com/repos/solace-iot-team/$releaseProject/releases"
    assetReleaseName="solace-rdp-2-blob"

    echo
    echo "##########################################################################################"
    echo "# Download RDP 2 Blob Function Release"
    echo "# Download Dir: $releaseDir"
    echo

#####################################################################################
# Prepare Dirs

    mkdir $releaseDir > /dev/null 2>&1
    rm -rf $releaseDir/*
    mkdir $tmpDir > /dev/null 2>&1
    rm -rf $tmpDir/*

#####################################################################################
# Get latest release
#
    echo " >>> Get Latest Release ..."
    resp=$(curl \
        --silent \
        -H "Accept: application/vnd.github.v3+json" \
        "$gitReleaseURL/latest"
         )
         if [[ $? != 0 ]]; then echo " >>> ERR: get latest release info"; exit 1; fi

    releaseAssetInfo=$(echo $resp | jq -r '.assets[] | select(.name | contains("'"$assetReleaseName"'"))')
    # echo $releaseAssetInfo | jq
    tagName=$(echo $resp | jq -r '.tag_name')
    releaseAssetName=$(echo $releaseAssetInfo | jq -r '.name')
    downloadUrl=$(echo $releaseAssetInfo | jq -r '.browser_download_url')
    # echo "downloadUrl=$downloadUrl"
    cd $tmpDir
    resp=$(curl -L $downloadUrl --silent --output $releaseAssetName)
    unzip *.zip -d $releaseDir > /dev/null 2>&1
    echo " >>> done."; echo

    echo "# Release Assets:"
    ls $releaseDir/*
    echo

#####################################################################################
# Cleanup
#
  rm -rf $tmpDir/*
  echo; echo " >>> done."; echo
###
# The End.
