# Install Examples

Installation examples for Ansible.

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

# Ansible
pip3 install --upgrade ansible
ansible --version
ansible-playbook --version
````

[Install Docker Desktop](https://www.docker.com/products/docker-desktop).


#### Example Installations: Windows 10

##### Cygwin:
Sequence:
- [cygwin (with python)](https://cygwin.com/install.html)
  - run setup{..}.exe
  - select python
- Ansible

````bash
# In cygwin bash shell:

python3 -V
pip3 -V

# Ansible
pip3 install --upgrade ansible
ansible --version
ansible-playbook --version
````
---
The End.
