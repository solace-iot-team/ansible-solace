
![integration tests](https://github.com/solace-iot-team/ansible-solace/workflows/integration%20tests/badge.svg)

:warning: UNDER CONSTRUCTION

# Tutorials & Sample Projects Using `ansible-solace`

Sample tutorials and projects that show the use of `ansible-solace` to configure [Solace PubSub+ Event Brokers](https://solace.com/products/event-broker/) using Ansible via REST [SEMP v2](https://docs.solace.com/SEMP/Using-SEMP.htm) (and SEMP v1 if required).

**Tutorials** are examples to show the use of a particular module or set of modules.
They typically follow the naming convention: `working-with-{tutorial-name}`.

**Projects** are more complex examples usually derived from real-life use cases / projects and
implement one or more specific, repeatable integration patterns.

Most of the tutorials use Solace PubSub+ Standard - the free version - and pull it from docker hub.

Some of the projects / use case examples also require a Solace Cloud account to run fully.

Refer to the README in the project / tutorial for details.

#### See Also

[Concepts of `ansible-solace`](./Concepts.md) |
[Guide to Creating your own Project](./project-template) |
[Issues](https://github.com/solace-iot-team/ansible-solace/issues).

## Pre-requisites

* Python: python >= 3.6.9
* Ansible: ansible>=2.9.11,<2.10.0
* Docker: docker & docker-compose

_Note: Best to install Ansible using pip3! ansible-solace is only available using pip3. This way you ensure that ansible-solace is installed in the same hierarchy as Ansible._

[**See Installation Examples**](./Install.md).

## Install `ansible-solace`

````bash
# install / upgrade to latest version of ansible-solace
sudo pip3 install --upgrade ansible-solace

sudo pip3 show ansible-solace
````

## Documentation

List all `ansible-solace` modules:
````bash
ansible-doc -l | grep solace
````

Module documentation:

````bash

ansible-doc <module_name>
# e.g.
ansible-doc solace_queue

````

## Configure Environment

_Note: By default, ansible-solace will use `/usr/bin/python`._

**_Note: Ensure that the python interpreter specified is the same as the one running Ansible._**

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

## Test

[Follow the instructions in 'project-template'](./project-template/README.md).

---
The End.
