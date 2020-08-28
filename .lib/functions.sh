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

function getDeployments() {
    local deployments
    if [[ $# != 1 ]]; then
      echo "ERR>>> Usage: deployments='\$(getDeployments "deployment-file-pattern")'" 1>&2
      return 1
    fi
    local deploymentFilePattern=$1

    deployments=$(ls $deploymentFilePattern | grep -v "template.deployment.json$")

    if [[ $? != 0 ]]; then
        echo "ERR>>> cannot find files with pattern=$deploymentFilePattern." 1>&2
        return 1
    fi
    echo $deployments
    return 0
}

function chooseDeployment() {
  if [[ $# != 1 ]]; then
      echo "ERR>>> Usage: deploymentFile='\$(chooseDeployment "deployment-file-pattern")'" 1>&2
      return 1
  fi
  deploymentFilePattern=$1
  deployments=$(getDeployments "$deploymentFilePattern")
  if [[ $? != 0 ]]; then exit 1; fi
  echo 1>&2
  echo "Choose a deployment: " 1>&2
  echo 1>&2
  counter=0
  for deployment in $deployments ; do
    local d="${deployment##$1/}"
    echo "($counter): $d" 1>&2
    let counter=$counter+1
  done
  echo 1>&2
  let numDeployments=$counter-1

  if [ $counter -lt 1 ]; then echo "ERR >>> no deployments found." 1>&2; exit 1; fi

  read -p "Enter 0-$numDeployments: " choice

  if [[ ! "$choice" =~ ^[0-9]+$ ]] || [ ! "$choice" -ge 0 ] || [ ! "$choice" -le "$numDeployments" ]; then
    echo "Choose 0-$numDeployments, your choice:$choice is not valid" 1>&2
    return 2
  fi

  # doesn't look like deployments is an array
  #echo "your choice=${deployments[$choice]}" 1>&2

  counter=0;
  for chosenDeployment in $deployments ; do
    if [ "$counter" -eq "$choice" ]; then break; fi
    let counter=$counter+1
  done

  echo $chosenDeployment
  return 0

}

function showEnv() {
  echo > /dev/tty
  echo "# Project Environment:" > /dev/tty
  echo > /dev/tty
  env | grep AS_SAMPLES > /dev/tty
  echo > /dev/tty
  echo "# Ansible Environment:" > /dev/tty
  echo > /dev/tty
  env | grep ANSIBLE > /dev/tty
  echo > /dev/tty
  echo "# Docker Containers:" > /dev/tty
  echo > /dev/tty
  docker ps -a > /dev/tty
  echo > /dev/tty
  return 0
}

function wait4Key() {
  read -n 1 -p "Press key to continue, CTRL-C to exit ..." x
  echo > /dev/tty
  return 0
}

function assertFile() {
  if [[ $# -lt 1 ]]; then
      echo "Usage: fileVar='\$(assertFile {full-path/filename})'" 1>&2
      return 1
  fi
  local file=$1
  if [[ ! -f "$file" ]]; then
    echo ">>> ERR: file='$file' does not exist. aborting." > /dev/tty
    echo > /dev/tty
    return 1;
  fi
  echo $file
  return 0
}




###
# The End.
