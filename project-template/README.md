# Project Template

Use this template to create your own project.

## Run this project

````bash

./start.local.broker.sh

./run.sh

````

## Create your own Project

````bash
cd ..

# note: copy recursively with preserving sym-links
cp -av ./project-template ./{new-project-name}

cd {new-project-name}

````

### Set-up your Project

* Broker Inventory: `broker.inventory.yml`
* Playbook: `playbook.yml`
* README: `README.md`
* ...

### Run your Project

````bash
./run.sh
````


---
The End.
