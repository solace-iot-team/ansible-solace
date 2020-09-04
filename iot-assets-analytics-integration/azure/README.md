# Configure Azure & Deploy RDP 2 Blob Function

## Pre-Requisites

* bash
* [jq](https://stedolan.github.io/jq/download/)
* Azure CLI

## Login to Azure
````bash
az login

az account set --subscription YOUR-SUBSCRIPTION-NAME-OR-ID
````

## Get the Release Asset for Function

````bash
./1.get-function-release.sh
````

## Create Azure Resources

#### Settings
````bash
cp template.settings.json settings.json

vi settings.json
  # change values
  # note: ensure you choose a unique name for the project

# Note: to find out the Azure locations supported in your subscription:
az appservice list-locations --sku F1
````
#### Create Resources
````bash
./2.create.deployment.sh
````

## Delete Resources
````bash
./3.delete.deployment.sh
````

---
The End.
