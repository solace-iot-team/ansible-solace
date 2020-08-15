# Project: Configuring a Hybrid IoT Event Mesh for Streaming Asset Sensor Data into a Data Lake

See this blog post to understand the background of this project.

## Configure the Project

TODO:
* Broker Inventory: `broker.inventory.yml`
* Playbook: `playbook.yml`
* README: `README.md`
* ...

## Run the Project

### Create Solace Cloud Service

````bash
  ./run.create-sc-service.sh
````

Check the new Service facts:
````bash
less ./tmp/facts.solace_cloud_service.*.json
````

### Start the local broker

````bash
  ./start.local.broker.sh
````

### Create & Configure the Bridge

run.create-bridge.sh
  - bridge between them
    - 1 solace cloud instance
    - 1 local broker


# Continue
run.delete-sc-service.sh
  - delete cloud service
run.remove-bridge.sh
  - remove bridge
run.add-update-config-central-broker.sh
  - this is the local broker
  - RDP, etc
run.remove-config-central-broker.sh
  - deletes it all




---
The End.
