# Sample Projects using `ansible-solace`

## Pre-requisites

* python >= 3.6
* ansible >= 2.10
* ansible-solace >= 0.6.1


## Install

````bash
# install / upgrade to latest version of ansible-solace
pip3 install --upgrade ansible-solace
````

## Configure Environment

_Note: By default, ansible-solace will use `/usr/bin/python`._

````bash
export ANSIBLE_PYTHON_INTERPRETER={path-to-python-3}
````

## Configuration Options for `ansible-solace`
````bash
# set the log file path + name
export ANSIBLE_SOLACE_LOG_PATH="./tmp/ansible-solace.log"
# set debug logging to true / false
export ANSIBLE_SOLACE_ENABLE_LOGGING=True
````

## Run the Sample Projects

The projects use Solace PubSub+ Standard - the free version - and pull it from docker hub.


````bash
cd {project}

./start.local.broker.sh

./run.sh

./stop.local.broker.sh

ls ./tmp/*.log
````
---
The End.
