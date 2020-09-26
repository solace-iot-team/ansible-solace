# Install Examples

#### Example Installations: Mac

Sequence:
- Homebrew
- Python
- Ansible
- Docker Desktop

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

# Ansible - Note: Best to install Ansible using pip3!
pip3 install --upgrade ansible
ansible --version
ansible-playbook --version
````

[Install Docker Desktop](https://www.docker.com/products/docker-desktop).


#### Example Installations: Ubuntu

Tested with: Ubuntu 18.04.5 LTS.

##### Azure VM
To create a vm in Azure, you can use this ARM template:

https://azure.microsoft.com/en-gb/resources/templates/101-vm-simple-linux/

##### Python3
````bash
sudo apt update
sudo apt -y upgrade
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update

sudo apt install python3
python3 -V

sudo apt install python3-pip
pip3 -V

````

##### Ansible & Ansible-Solace

````bash
sudo -H python3 -m pip install ansible==2.9.11
pip3 show ansible
ansible --version

sudo -H python3 -m pip install ansible-solace
pip3 show ansible-solace
ansible-doc -l | grep solace

vi ~/.bash_profile
  # add:
  export ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3

source .bash_profile
env | grep ANS

````

##### Misc Tools

````bash
sudo apt install jq
````

##### Docker

[For example: See this install guide](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04).

Install docker-compose:
````bash
sudo apt install docker-compose
````

Check all is working:
````bash
docker ps
docker-compose --version
````


---
The End.
