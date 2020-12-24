# Project: Configuring a Hybrid IoT Event Mesh for Streaming Asset Sensor Data into a Data Lake

This project creates an Event Mesh to stream sensor data into a central data lake in Azure.

For details, see [this overview of the project](./ProjectOverview.md).

## Prerequisites

* bash
* [jq](https://stedolan.github.io/jq/download/)

### Solace Cloud Account

- admin access
- at least 1 spare service
  - _note: settings for the Solace Cloud service in `./vars/solace-cloud-service.vars.yml`. Adjust them to your needs._

#### Create an API Token

- create an API Token with the rights to create and delete services
- copy the token - needed during set-up of this tutorial

## Run: Create Broker Services


Playbook: `playbook.create-services.yml`

Create the Solace Cloud Service: **Ansible-Solace-IoT-Assets-Edge-Broker-1**.

- start a local broker service in docker: `service.playbook.yml`
  - uses the latest Solace PubSub+ Standard Edition image
-
````bash
  export SOLACE_CLOUD_API_TOKEN={the api token}
  ./run.create-services.sh
````

The inventory and full info for the new Solace Cloud service are created in the $WORKING_DIR:
````bash
  less ./tmp/solace-cloud.ansible_solace_tutorial.inventory.yml
  less ./tmp/solace-cloud.ansible_solace_tutorial.info.yml

edge-broker.pem

````

Go to the Solace Cloud admin console and check the service has been created.

need for TLS bridge central to edge broker
TODO: download into working dir
  - into WORKING_DIR
  - download the Certificate from the new service and copy the file into the project's root folder.
  - the pre-configured filename for the certificate is: `./DigiCert_Global_Root_CA.pem`

#### Create & Configure the Bridge

Sets up the secure bridge between the local (central) broker and the Solace Cloud (edge) broker.
Uses the certificate from the Solace Cloud service.

Playbook: `playbook.create-bridge.yml`


````bash
  ./run.create-bridge.sh
````

#### Create & Configure Asset Connection / MQTT

TODO: explain

Playbook: `playbook.create-mqtt.yml`

````bash
  ./run.create-mqtt-edge-broker.sh
````

#### Create & Configure the RDP

TODO: explain

Playbook: `playbook.create-rdp.yml`

````bash
  ./run.create-rdp-central-broker.sh
````

## Remove All Configurations

````bash
  ./run.remove-mqtt-edge-broker.sh
  ./run.remove-rdp-central-broker.sh
  ./run.remove-bridge.sh
  ./run.remove-services.sh
````

---
---
---

## Run the Project

#### Deploy Azure Function
This step is optional. If you don't use an Azure function, the RDP will still be configured with _dummy_ values but not be able to connect.

````bash
  cd azure
````
[Follow these steps to setup Azure](./azure).
````bash
  cd ..
````



#### Get Client Connection Details

````bash
  ./run.get.sh
````

## Test the Setup

Edge Broker Connection Details:
````bash
  less ./deployment/edge-broker.client_connection_details.json
````

Central Broker Connection Details:
````bash
  less ./deployment/central-broker.client_connection_details.json
````

#### Use MQTT client to send events to the edge broker:
  - use the Edge Broker MQTT connection details
  - send messages using these sample topics:
    ````bash
    as-iot-assets/asset-type-a/asset-id-1/region-id-1/stream-metrics
    as-iot-assets/asset-type-a/asset-id-1/region-id-1/stream-metrics-1
    as-iot-assets/asset-type-a/asset-id-1/region-id-1/stream-metrics-2
    ````

#### HTTP POST

For a quick end-to-end test using HTTP POST instead:

- HTTP POST events to the central broker:
````bash
  ./post.events.central-broker.sh
````
- HTTP POST events to the edge broker:
````bash
  ./post.events.edge-broker.sh
````

#### Check Result

  - Check Azure portal to see the events in the blob storage

  - Run script to count the number of files in the blob storage:
    ````bash
    azure/rdp2blob.count.sh
    ````


### Remove Azure Deployment

````bash
  cd azure
````

[Follow steps here](./azure).

---
The End.
