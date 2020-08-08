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

SCRIPT_NAME=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));
SCRIPT_PATH=$(cd $(dirname "$0") && pwd);

export brokerDockerContainerName="pubSubStandardSingleNode"
dockerComposeYmlFile="./.lib/PubSubStandard_singleNode.yml"
brokerDockerImageLatest="solace/solace-pubsub-standard:latest"
export brokerDockerImage=$brokerDockerImageLatest

echo; echo "##############################################################################################################"
echo "creating container: $brokerDockerContainerName"
echo "image: $brokerDockerImage"
echo

# remove container first
docker rm -f "$brokerDockerContainerName" > /dev/null 2>&1
if [ "$brokerDockerImage" == "$brokerDockerImageLatest" ]; then
  # make sure we are pulling the latest
  docker rmi -f $brokerDockerImageLatest > /dev/null 2>&1
fi

docker-compose -f $dockerComposeYmlFile up -d
if [[ $? != 0 ]]; then echo ">>> ERR: $SCRIPT_PATH/$SCRIPT_NAME. aborting."; echo; exit 1; fi

echo

docker ps -a

echo; echo "Done."; echo

###
# The End.
