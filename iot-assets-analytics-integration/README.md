# Project: Configuring a Hybrid IoT Event Mesh for Streaming Asset Sensor Data into a Data Lake

This project was tested with `ansible-solace` version: **0.7.3**.
To install this specific version:
````bash
  pip3 install --force-reinstall ansible-solace==0.7.3
````

#### See also
[Overview of the project](./ProjectOverview.md).


## Pre-requisites

* bash
* [jq](https://stedolan.github.io/jq/download/)

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
#### Define Solace Cloud Service Parameters

````bash
  vi ./lib/vars.sc-service.yml

  # change these for your set-up:
  datacenterId: aws-eu-west-2a
  serviceTypeId: enterprise
  serviceClassId: enterprise-250-nano

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

#### Deploy Azure Function
This step is optional. If you don't use an Azure function, the RDP will still be configured with _dummy_ values but not be able to connect.

````bash
  cd azure
````
[Follow these steps to setup Azure](./azure).
````bash
  cd ..
````


#### Create & Configure the RDP

````bash
  ./run.create-rdp-central-broker.sh
````

#### Create & Configure Asset Connection / MQTT

````bash
  ./run.create-mqtt-edge-broker.sh
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

## Remove All Configurations

````bash
  ./run.remove-mqtt-edge-broker.sh
  ./run.remove-rdp-central-broker.sh
  ./run.remove-bridge.sh
  ./run.remove-sc-service.sh
  ./stop.local.broker.sh
````

### Remove Azure Deployment

````bash
  cd azure
````

[Follow steps here](./azure).

---
The End.
