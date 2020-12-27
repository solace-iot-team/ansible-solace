# Tutorial: Working with Solace Cloud

Creating and deleting services in Solace Cloud accounts.

## Details

When running the tutorial, the following sequence is executed:

- create a Solace Cloud service
- get the client connection details from the new service
- delete the Solace Cloud service

## Prerequisites

### Solace Cloud Account

- admin access
- at least 1 spare service
  - _note: settings for the Solace Cloud service in `./vars/solace-cloud-service.vars.yml`. Adjust them to your needs._

#### Create an API Token

- create an API Token with the rights to create and delete services
- copy the token - needed during set-up of this tutorial


## Run: Create Solace Cloud Service

Create the Solace Cloud Service: **ansible_solace_tutorial**.

````bash
  export SOLACE_CLOUD_API_TOKEN={the api token}
  ./run.create.sh
````

The inventory and full info for the new Solace Cloud service are created in the $WORKING_DIR:
````bash
  less ./tmp/solace-cloud.ansible_solace_tutorial.inventory.yml
  less ./tmp/solace-cloud.ansible_solace_tutorial.info.yml
````

Go to the Solace Cloud admin console and check the service has been created.

## Run: Get Solace Cloud Service Facts

Retrieve facts about the Solace Cloud Service: **ansible_solace_tutorial**.

Note: Uses the generated inventory: **./tmp/solace-cloud.ansible_solace_tutorial.inventory.yml**.

````bash
  export SOLACE_CLOUD_API_TOKEN={the api token}
  ./run.facts.sh
````

The _client connection details_ for the new Solace Cloud service are created in the $WORKING_DIR:
````bash
  less ./tmp/solace-cloud.ansible_solace_tutorial.client_connection_details.yml
````

## Run: Delete Solace Cloud Service

Delete the Solace Cloud Service: **ansible_solace_tutorial**.

````bash
  export SOLACE_CLOUD_API_TOKEN={the api token}
  ./run.sc-delete.sh
````

The _client connection details_ for the new Solace Cloud service are created in the $WORKING_DIR:
````bash
  less ./tmp/solace-cloud.ansible_solace_tutorial.client_connection_details.yml
````

---
