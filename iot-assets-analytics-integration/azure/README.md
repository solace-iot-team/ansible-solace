# Configure Azure & Deploy RDP 2 Blob Function

Deploy and configure a pre-packaged Azure Function that writes to a Blob Storage.

#### See also
[Azure Function Source Repo](https://github.com/solace-iot-team/solace-int-rdp-az-funcs).

## Pre-Requisites

* Azure Account
* Azure CLI
* bash
* [jq](https://stedolan.github.io/jq/download/)

## Login to Azure
````bash
az login

# if you have more than 1 subscription:
az account set --subscription {YOUR-SUBSCRIPTION-NAME-OR-ID}
````

## Get the Release Asset for Function

````bash
./1.get-function-release.sh
````

Check directory `./release`. Contains the function release assets.

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

Check directory: `deployment`. Contains the output of the deployment.

## Delete Resources
````bash
./3.delete.deployment.sh
````

---
The End.
