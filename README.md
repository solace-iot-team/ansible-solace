# Tutorials & Sample Projects Using `ansible-solace`

Sample tutorials and projects that show the use of `ansible-solace` to configure [Solace PubSub+ Event Brokers](https://solace.com/products/event-broker/) using Ansible via REST [SEMP v2](https://docs.solace.com/SEMP/Using-SEMP.htm) (and SEMP v1 if required).

**Tutorials** are examples to show the use of a particular module or set of modules.
They typically follow the naming convention: `working-with-{tutorial-name}`.

**Projects** are more complex examples usually derived from real-life use cases / projects and
implement one or more specific, repeatable integration patterns.

Most of the tutorials use Solace PubSub+ Standard - the free version - and pull it from docker hub.

Some of the projects / use case examples also require a Solace Cloud account to run fully.

Refer to the README in the project / tutorial for details.

#### Links

[Concepts of `ansible-solace`](./Concepts.md).

[Guide to Creating your own Project](./project-template).

[Report Issues here](https://github.com/solace-iot-team/ansible-solace/issues).

## Pre-requisites

* python >= 3.6
* ansible >= 2.10
* ansible-solace >= 0.6.1
* docker (e.g. Docker Desktop)

#### Example Installations: Mac

Sequence:
- Homebrew
- Python
- Ansible

````bash
# Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew help

# Python
brew install python
brew info python
brew update && brew upgrade python

python3 -V
pip3 -V

# Ansible
pip3 install --upgrade ansible
ansible --version
ansible-playbook --version
````

## Install `ansible-solace`

````bash
# install / upgrade to latest version of ansible-solace
pip3 install --upgrade ansible-solace

pip3 show ansible-solace
````

````bash
# install a specific version of ansible-solace
  pip3 install --force-reinstall ansible-solace==0.7.1
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

---
The End.
