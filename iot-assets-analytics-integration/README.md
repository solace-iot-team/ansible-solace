# Project: Configuring a Hybrid IoT Event Mesh for Streaming Asset Sensor Data into a Data Lake

## Links

  - [Overview of the project](./ProjectOverview.md).

## Pre-requisites

### Solace Cloud Account

- admin access
- at least 1 spare service

#### Create an API Token

- create an API Token with the rights to create and delete services
- copy the token

## Configure the Project

#### Create the Ansible Inventory for the Solace Cloud Account

````bash
  cp template.inventory.sc-accounts.yml inventory.sc-accounts.yml

  vi inventory.sc-accounts.yml
    # choose a name for your account
    # add the api-token

````

## Run the Project

#### Create Solace Cloud Service

````bash
  ./run.create-sc-service.sh
````

Check the new Service facts:
````bash
less ./tmp/facts.solace_cloud_service.*.json
````

- download the Certificate from the new service and copy the file into the project's root folder.
- the pre-configured filename for the certificate is: `./DigiCert_Global_Root_CA.pem`
- if your certificate's name is different:

````bash

  vi playbook.create-bridge.yml

  # search and replace
  # ./DigiCert_Global_Root_CA.pem

````

#### Start the local broker

````bash
  ./start.local.broker.sh
````

#### Create & Configure the Bridge

````bash
  ./run.create-bridge.sh
````

#### Create & Configure the RDP

````bash
  ./run.create-rdp.sh
````

#### Create & Configure Asset Connection / MQTT

````bash
  ./run.create-mqtt.sh
````

#### Get Client Connection Details

````bash
  ./run.get.sh
````

#### Remove All Configurations

````bash
  ./run.remove-mqtt.sh
  ./run.remove-rdp.sh
  ./run.remove-bridge.sh
  ./run.remove-sc-service.sh
````

---
The End.
