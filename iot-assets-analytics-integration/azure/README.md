# Configure Azure & Deploy RDP 2 Blob Function

Deploy and configure a pre-packaged Azure Function that writes incoming messages to a Blob Storage.

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

- downloads the Azure function Zip package from [Solace Integration: RDP to Azure Functions](https://github.com/solace-iot-team/solace-int-rdp-az-funcs)

````bash
./1.get-function-release.sh
````

Check:
  - directory `../tmp/release`. Contains the function release zip file and the template `template.app.settings.json`

## Create Azure Resources

#### Settings
````bash
cp ./template.settings.json settings.json

vi settings.json
  # change values
  # note: ensure you choose a unique name for the project

# Note: to find out the Azure locations supported in your subscription:
az appservice list-locations --sku F1
````

Example `settings.json`:
````json
{
    "projectName": "iot-assets-blob-int-rjgu",
    "azLocation": "UK South",
    "functionAppAccountName": "iot-assets-blob-int-fa",
    "rdp2blobFunction": {
        "functionName":"solace-rdp-2-blob",
        "dataLakeStorageContainerName": "rdp2blob",
        "dataLakeFixedPathPrefix": "fixed/path/prefix"
    }
}
````


#### Create Resources

- creates Azure resource group with:
  - function app with function
  - app service plan
  - storage account

````bash
./2.create.deployment.sh
````

Check
- directory `../tmp/azure-deployment` contains the output of the deployment
- `../tmp/azure-deployment/settings.az-func.json` contains the details of the Azure function required for the RDP setup

## Delete Resources
````bash
./3.delete.deployment.sh
````

---
The End.
