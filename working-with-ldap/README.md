# Tutorial: Working with LDAP Authorization

- creates a Solace Cloud service or a self-hosted Solace Broker service
- configures the service to use LDAP Authorization

## Prerequisites

- Solace Cloud Account with 1 spare service - if using Solace Cloud service
- JumpCloud service
- test client, e.g. MQTT Box
- install additional python requirements:
  ````bash
  pip install -r requirements.txt
  ````

## Configuring JumpCloud LDAP

Any LDAP Server will work, here we use JumpCloud: https://jumpcloud.com.
Sign up for a free account.

Create an LDAP Directory:
* `JumpCloud LDAP`

Configure the main `service` user:
* `solace_service`
  - password: `Solace123!`
  - bind to LDAP

Configure MQTT client or application users:
* `device_1`
  - password: `device_1_pwd`
* `device_2`
  - password: `device_2_pwd`

Configure a User Group:
* `solace_devices`
  - add `device_1` and `device_2` to the group
  - check the `JumpCloud LDAP` directory is enabled

### Set Environment

````bash
cp template.source.env.sh source.env.sh
vi source.env.sh
  # enter environment values
source source.env.sh
````

### Check JumpCloud Configuration

````bash
source source.env.sh
./run.check.jumpcloud-config.sh
````

You should see the two devices, similar to this:
````
"msg": [
    "device: device_1",
    "memberOf: cn=solace_devices,ou=Users,o=xxxx,dc=jumpcloud,dc=com"
]
"msg": [
    "device: device_2",
    "memberOf: cn=solace_devices,ou=Users,o=xxxx,dc=jumpcloud,dc=com"
]
````

**Output:**
- ``memberOf`` value, this is the name of the LDAP Authorization Group to be configured on the Broker
````bash
cat tmp/memberOf.yml
````

## Create Local Broker Service
````bash
./run.create.local-service.sh
````
**Output:**
- the broker inventory file
````bash
cat tmp/broker.inventory.yml
````

## Create Solace Cloud Broker Service
````bash
./run.create.solace-cloud-service.sh
````
**Output:**
- the service inventory file
````bash
cat tmp/solace-cloud.inventory.yml
````

## Configure the Broker(s)

````bash
./run.configure.brokers.sh
````

**Output:**
- on screen: plain mqtt connection details for the broker(s)
- file: all vpn connection details
````bash
cat tmp/solace_cloud.vpnClientConnectionDetails.yml
cat tmp/local.vpnClientConnectionDetails.yml
````

---
The End.
