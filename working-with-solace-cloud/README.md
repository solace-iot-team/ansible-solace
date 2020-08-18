# Tutorial: Working with Solace Cloud

Creating and deleting services in Solace Cloud accounts.

## Pre-requisites

### Solace Cloud Account

- admin access
- at least 1 spare service

#### Create an API Token

- create an API Token with the rights to create and delete services
- copy the token - needed during set-up of this tutorial

## Configure the Project

#### Create the Ansible Inventory for the Solace Cloud Account

````bash
  cp template.inventory.sc-accounts.yml inventory.sc-accounts.yml

  vi inventory.sc-accounts.yml
    # choose a name for your account
    # add the api-token

````

#### Configure the Service Parameters

````bash
vi ./lib/vars.sc-service.yml
  # change / adapt the service settings
````

## Run the Project

### Create Solace Cloud Service

````bash
  ./run.create-sc-service.sh
````

Go to the Solace Cloud admin console and check the service has been created.

#### Check the new Service Facts

````bash
less ./tmp/facts.solace_cloud_service.{the-service-name}.json
````

#### Check the generated Service Inventory File

You can use this as an inventory for subsequent playbooks.

````bash
less ./tmp/generated/inventory.{the-service-name}.json
````
### Retrieve Connection Details of the new Solace Cloud Service

_Note: The get playbook also retrieves a list of all Solace Cloud Account services and their service info._

````bash
  ./run.get.sh
````

#### Check the generated Connection Details
````bash
less ./tmp/generated/*.client_connection_details.json
````

### Delete the Solace Cloud Service

````bash
  ./run.delete-sc-service.sh
````


---
The End.
