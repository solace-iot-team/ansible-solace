# Solace Cloud Full Mesh

Create a full mesh between Solace Cloud services using DMR external links.

Requires at least 2 services, either pre-existing or created automatically.


## Run the Tutorial

### Environment
Create an API Token for the Solace Cloud account.

````bash
export SOLACE_CLOUD_API_TOKEN={the api token}
````

* **WORKING_DIR:** default: `./tmp`

### Get List of Solace Cloud Service Data Centers

Retrieves a list of available data centers in your Solace Cloud subscription.

````bash
./run.get.solace-cloud.datacenters.sh
# output:
cat tmp/solace-cloud.data_centers.yml
````

### Inventory File

The inventory file only requires entries for the Solace Cloud services (their names) and their settings.
Add or adjust hosts (service names) and their location as required.

If you have existing services, enter their names in the inventory file and ensure the settings match.

````bash
cp template.solace-cloud.services.inventory.yml solace-cloud.services.inventory.yml
vi solace-cloud.services.inventory.yml
# enter your globally unique services names
# save
````

Note that the ansible playbooks will combine the `settings` of the host with the `common_settings` in the vars to create the final set of settings for each service. The host `settings` override the `common_settings`.

Note for existing services, the following capabilities must be enabled:
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
      service_name: my-service-name-1
      settings:
        datacenterId: "aws-ca-central-1a"
    ansible_solace_mesh_node_2:
      ansible_connection: local
      service_name: my-service-name-2
      settings:
        datacenterId: "aws-eu-central-1a"
    ansible_solace_mesh_node_3:
      ansible_connection: local
      service_name: my-service-name-3
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


### Create Solace Cloud Services

````bash
# input:
./solace-cloud.services.inventory.yml
# run:
./run.create.solace-cloud.services.sh
# output:
$WORKING_DIR/solace-cloud.{service-name}.inventory.yml
$WORKING_DIR/solace-cloud.{service-name}.info.yml
````

### Create the Full Mesh

Create the full mesh between all services as defined in the inventory.

````bash
# input:
$WORKING_DIR/solace-cloud.*.inventory.yml
# run:
./run.create.full-mesh-dmr-cluster.sh
# output:
none
````

### Test the Full Mesh

- creates a queue in every node with 1 subscription
- sends 3 messages to every node
- verifies each queue has received 3 x nodes messages

````bash
# input:
$WORKING_DIR/solace-cloud.*.inventory.yml
# run:
./run.test.full-mesh-dmr-cluster.sh
# output:
none
````

### Remove the Full Mesh

Removes the full mesh (deletes the links) between all services as defined in the inventory.

````bash
# input:
$WORKING_DIR/solace-cloud.*.inventory.yml
# run:
./run.delete.full-mesh-dmr-cluster.sh
# output:
none
````

### Delete Solace Cloud Services

````bash
# input:
./solace-cloud.services.inventory.yml
# run:
./run.delete.solace-cloud.services.sh
# output:
# removes:
$WORKING_DIR/solace-cloud.{service-name}.inventory.yml
$WORKING_DIR/solace-cloud.{service-name}.info.yml
````

---
