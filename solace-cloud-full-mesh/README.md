# Tutorial: Working with DMR Cluster

Creates a full mesh using DMR external links between all the services specified.

requires at least 2 services, either pre-existing or created here.


## Run the Tutorial

### Environment
Create an API Token for the Solace Cloud account.

````bash
export SOLACE_CLOUD_API_TOKEN={the api token}
````

* **WORKING_DIR:** default: `./tmp`

### Get List of Solace Cloud Service Data Centers

````bash
./run.get.solace-cloud.datacenters.sh
# output:
cat tmp/solace-cloud.data_centers.yml
````

### Create Solace Cloud Services

Note: if you already have services, update the host entries in the inventory.
example: TODO

List of services & service settings:
````bash
cat solace-cloud.services.inventory.yml
# change settings, service names, data centers
# as per your requirements
````

Create the services:
````bash
./run.create.solace-cloud.services.sh
# output:
$WORKING_DIR/solace-cloud.{service-name}.inventory.yml
$WORKING_DIR/solace-cloud.{service-name}.info.yml
````

### Create the DMR Cluster

- creates a full mesh between all services as defined in: TODO

````bash
# input:

# run:
./run.create.full-mesh-dmr-cluster.sh

# output:
````

### Delete Solace Cloud Services

````bash
./run.create.solace-cloud.services.sh
````

TODO



------------------------------------



Creates VPN, queues and subscriptions based on a variables file.

## Details

When running the tutorial, the following sequence is executed:

- start a local broker service in docker: `service.playbook.yml`
  - uses the latest Solace PubSub+ Standard Edition image
- create a VPN called `foo`
- configure the queues & subscriptions: `configure.playbook.yml`
  - queue definitions: `vars/queues.vars.yml`
  - loops over queues using task: `tasks/queues.tasks.yml`
- prompt to inspect queues in broker console
  ````bash
  - browser: open a new incognito window
  - http://localhost:8080
  - login: admin / admin
  - vpn: foo
  ````
- delete queues
- delete vpn

## Run the tutorial

### Prerequisites
````bash
pip install docker-compose
````
### Run
````bash
./run.sh
````
---
