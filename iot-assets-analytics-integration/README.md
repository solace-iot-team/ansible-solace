# Project: Configuring a Hybrid IoT Event Mesh for Streaming Asset Sensor Data into a Data Lake

This project creates an Event Mesh to stream sensor data into a central data lake in Azure.

For details,
see [Overview of the Project](./ProjectOverview.md)
and the blog post [Configuring a Hybrid IoT Event Mesh for Streaming Asset Sensor Data into an Azure Data Lake with Ansible](https://solace.com/blog/streaming-asset-sensor-data-azure-datalake-ansible/).

## Prerequisites

### Solace Cloud Account

- admin access
- at least 1 spare service
  - _note: settings for the Solace Cloud service in `./vars/solace-cloud-service.vars.yml`. Adjust them to your needs._

#### Create an API Token

- create an API Token with the rights to create and delete services
- copy the token - needed during set-up of this tutorial

### Optional: Azure Account

You need an Azure account to deploy the pre-packaged Azure function that writes incoming IoT Asset data to a Blob Storage.

**_Note: You can still run the project without the Azure function but the RDP will not be able to connect._**

## Create Broker Services

Playbook: `playbook.create-services.yml`

Variables: `vars/solace-cloud-service.vars.yml`

  - creates the Solace Cloud Service: **Ansible-Solace-IoT-Assets-Edge-Broker-1**
  - starts a local broker service in a docker container: **pubSubStandardSingleNode**
    - uses the latest Solace PubSub+ Standard Edition image in docker hub
  - generates the following output files in the `$WORKING_DIR=./tmp`:
    - `central-broker.inventory.yml` - the Ansible inventory for the local / central broker
    - `edge-broker.inventory.yml` - the Ansible inventory for the Solace Cloud service / edge broker
    - `edge-broker.pem` - the certificate downloaded from the edge broker. used later to create a TLS bridge between central & edge brokers

````bash
  export SOLACE_CLOUD_API_TOKEN={the api token}
  ./run.create-services.sh
````

Check:
  - go to the Solace Cloud admin console and check the service has been created
  - open a private browser window, go to: http://localhost:8080 (admin/admin)


_**Note: ansible-solace modules log requests & responses in `./tmp/ansible-solace.log`.**_


## Create & Configure the Bridge: Edge <-> Central

Playbook: `playbook.create-bridge.yml`

Variables: `vars/bridge.vars.yml`

  - the playbook is called with both inventories, `central-broker.inventory.yml` and `edge-broker.inventory.yml`
  - creates a new Client Profile on both brokers, `as-iot-bridge-e-2-c`
  - creates a new ACL profile on both brokers, `as-iot-bridge-e-2-c`
  - creates a new Client Username on both brokers, `as-iot-assets-bridge-edge-to-central`, using the new Client Profile and ACL Profile
  - creates a new Queue on both brokers, `as-iot-assets-bridge-edge-to-central`, with a subscription to `as-iot-assets/asset-type-a/>`
  - uploads the Solace Cloud certificate, `edge-broker.pem`, to the central broker
  - sets up a secure bridge, `as-iot-assets-bridge-edge-to-central`, between the local (central) broker and the Solace Cloud (edge)

````bash
  ./run.create-bridge.sh
````
Check:
  - on both brokers: Client Profile, ACL Profile, Client Username, Queue, Bridge

## Create & Configure Asset Connection / MQTT

Configures the MQTT access for IoT assets on the edge broker.

Playbook: `playbook.create-mqtt.yml`

Variables: `vars/mqtt.vars.yml`

  - creates a Client Profile, `as-iot-assets-mqtt-edge`
  - creates a ACL Profile, `as-iot-assets-mqtt-edge`, with publish & subscription topic exceptions using the `$client-id` substitution variable
  - creates 1 Client Username for each asset, `asset-id-1`, `asset-id-2`, `asset-id-3`, as defined in the variables
  - creates 1 MQTT Session for each asset, `asset-id-1`, `asset-id-2`, `asset-id-3`
  - adds MQTT subscriptions to the MQTT Sessions, example: `as-iot-assets/asset-id-1/config/+`, as defined in the variables

````bash
  ./run.create-mqtt-edge-broker.sh
````

Check on Solace Cloud service (edge-broker):
  - Client Profile, ACL Profile, Client Username
  - Client Connections -> MQTT, MQTT Sessions and MQTT Clients


## Optional: Deploy Azure Function

If you don't use an Azure function, the RDP will still be configured with _dummy_ values but not be able to connect.

````bash
  cd azure
````
[Follow these steps to setup Azure](./azure).
````bash
  cd ..
````

## Create & Configure the RDP

Creates the Rest Delivery Point configuration to connect the IoT Assets streaming data with the Azure function that writes the data into the blob storage.

Playbook: `playbook.create-rdp.yml`

Variables: `vars/rdp.vars.yml`

Settings: either the real or dummy settings
  - real Azure function: `./tmp/azure-deployment/settings.az-func.json`
  - dummy settings: `./vars/settings.az-func.json`

````bash
  ./run.create-rdp-central-broker.sh
````

Check on `central-broker`:
- Client Connections -> REST
- `as-iot-assets-rdp-central`
  - REST Consumers
  - Queue Bindings

## Test the Setup

Edge Broker Connection Details:
````bash
  less ./tmp/edge-broker.client_connection_details.json
````

### Use MQTT client to send events to the edge broker:
  - use the Edge Broker MQTT connection details
  - send messages using these sample topics:
    ````bash
    as-iot-assets/asset-type-a/asset-id-1/region-id-1/stream-metrics
    as-iot-assets/asset-type-a/asset-id-1/region-id-1/stream-metrics-1
    as-iot-assets/asset-type-a/asset-id-1/region-id-1/stream-metrics-2
    ````

### HTTP POST

For a quick end-to-end test using HTTP POST instead:
````bash
  ./post.events.edge-broker.sh
````

### Check Result

Check Azure portal to see the events in the blob storage.


## Remove All Configurations

````bash
  ./run.remove-mqtt-edge-broker.sh
  ./run.remove-rdp-central-broker.sh
  ./run.remove-bridge.sh
  ./run.remove-services.sh
````

### Remove Azure Deployment

````bash
  cd azure
````

[Follow steps here](./azure).

---
