# Solace Cloud Full Mesh

Creates a full mesh between Solace Cloud services using DMR external links.

Requires at least 2 services, either pre-existing or created automatically.


## Run the Tutorial

### Environment
Create an API Token for the Solace Cloud account.

````bash
export SOLACE_CLOUD_API_TOKEN={the api token}
````

* **WORKING_DIR:** default: `./tmp`

### Inventory File

The inventory file only requires entries for the Solace Cloud services (their names) and their settings.
Add or adjust hosts (service names) and their location as required.

If you have existing services, enter their names in the inventory file.

Note that the ansible playbooks will combine the `settings` of the host with the `common_settings` in the vars to create the final set of settings for each service. The host `settings` override the `common_settings`.

Note the enabled services:
- SMF for the DMR links
- REST for automated testing

Example:
````yaml
---
all:
  # the services created in Solace Cloud
  # with specific settings
  # add / remove services as required
  hosts:
    ansible_solace_mesh_node_1:
      ansible_connection: local
      settings:
        datacenterId: "aws-ca-central-1a"
    ansible_solace_mesh_node_2:
      ansible_connection: local
      settings:
        datacenterId: "aws-eu-central-1a"
    ansible_solace_mesh_node_3:
      ansible_connection: local
      settings:
        datacenterId: "aws-ap-southeast-1a"
  vars:
    # common settings for creation of Solace Cloud services
    common_settings:
      serviceTypeId: "enterprise"
      serviceClassId: "enterprise-250-nano"
      attributes:
        customizedMessagingPorts:
          serviceSmfPlainTextListenPort: 55555
          serviceSmfCompressedListenPort: 55003
          serviceSmfTlsListenPort: 55443
          serviceAmqpPlainTextListenPort: 0
          serviceAmqpTlsListenPort: 0
          serviceMqttPlainTextListenPort: 0
          serviceMqttTlsListenPort: 0
          serviceMqttTlsWebSocketListenPort: 0
          serviceMqttWebSocketListenPort: 0
          serviceRestIncomingPlainTextListenPort: 9000
          serviceRestIncomingTlsListenPort: 9443
          serviceWebPlainTextListenPort: 0
          serviceWebTlsListenPort: 0
````

### Get List of Solace Cloud Service Data Centers

Retrieves a list of available data centers in your Solace Cloud subscription.

````bash
./run.get.solace-cloud.datacenters.sh
# output:
cat tmp/solace-cloud.data_centers.yml
````

### Create Solace Cloud Services

Change service names and settings as per requirements.
````bash
cat solace-cloud.services.inventory.yml
# change settings, service names, data centers as per requirements
vi solace-cloud.services.inventory.yml
````

Create the services:
````bash
./run.create.solace-cloud.services.sh
# output:
$WORKING_DIR/solace-cloud.{service-name}.inventory.yml
$WORKING_DIR/solace-cloud.{service-name}.info.yml
````

### Create the DMR Cluster

Create the full mesh between all services as defined in the inventory.

````bash
./run.create.full-mesh-dmr-cluster.sh
````

### Test the Full Mesh

TODO

### Delete Solace Cloud Services

````bash
./run.delete.solace-cloud.services.sh
````

---
