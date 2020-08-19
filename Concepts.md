# Concepts

## The Basics

The `ansible-solace` modules mostly use the SEMP v2 Config API of the Broker. In some cases, to be backwards compatible with broker versions, they fall back on SEMP v1.
In order to check the outcome of some of the configurations, some modules also use the SEMP v2 Monitor APIs.

The modules follow the same naming convention as the SEMP v2 API calls so there is an easy mapping between the SEMP documentation and the `ansible-solace` module name.
For example:
SEMP v2 API: [clientUsername](https://docs.solace.com/API-Developer-Online-Ref-Documentation/swagger-ui/config/index.html#/clientUsername) maps to `solace_client_username`.

Some specific Solace Cloud APIs have modules as well, such as creating and deleting a service. They are named `solace_cloud_{module}`.

### Types of Modules

* Configuration modules: `solace_{configuration-object}`.
  - add/update/delete a configuration object
  - support the **state** parameter with **values=['present', 'absent']**
* Get modules: `solace_get_{configuration_object}s`.
  - retrieve a list of configuration objects

### Idempotency
The configuration modules update/add Broker objects in an idempotent manner.

**state='present'**:
  - get the current object from the broker
  - create a delta settings by comparing current object settings with requested settings
  - update or create current object based on delta settings (or leave it if no delta found)

**state='absent'**:
  - check if the object exists
  - if it does, delete it
  - if not, do nothing

### Ansible Hosts are not Hosts

The Ansible concept of a host is that, a machine which Ansible logs into, transfers scripts, executes scripts, etc.

**For `ansible-solace`, hosts are actually Brokers or Solace Cloud Accounts.**

Which means a few things:
  - Ansible cannot login and run it's normal setup / fact gathering routines
  - therefore, always use the following settings in your inventory / playbooks:
````yaml
      ansible_connection: local
      gather_facts: no
````

### Facts for Solace Brokers

In order to still be able to gather facts about the Broker / Service, the module

  `solace_gather_facts`

exists.

Call it at the beginning of your playbook, so all broker facts are available for the rest of the playbook.

`solace_gather_facts` places the facts gathered in `ansible_facts.solace[inventory_hostname]` as a JSON.
You can save it to file, print it out and find where the fact you are interested in is located.
Using jinja2, you can dynamically retrieve facts based on certain settings.

An additional convenience module is also supported: `solace_get_facts`.
It implements a few functions to directly collect a set of facts without the need to understand the JSON structure.
For example, to get the connection details of a newly created Solace Cloud service use the following in your playbook:

````yaml
- name: "Gather Solace Facts"
  solace_gather_facts:

- name: "Get Facts: all client connection details"
  solace_get_facts:
    hostvars: "{{ hostvars }}"
    host: "{{ inventory_hostname }}"
    field_funcs:
      - get_allClientConnectionDetails
  register: result

- set_fact:
    client_connection_details: "{{ result.facts }}"

- name: "Save 'client_connection_details' to File"
  local_action:
    module: copy
    content: "{{ client_connection_details | to_nice_json }}"
    dest: "./tmp/generated/{{ inventory_hostname }}.client_connection_details.json"

````

### SEMP v2 API Version

Across broker releases, the supported SEMP v2 API version evolves.
Where this is the case, the modules affected implement different functionality based on the version and it needs to be passed as a parameter to the module. For example:

````yaml
- name: "Gather Solace Facts"
  solace_gather_facts:

# ... create an ACL profile ...

- name: "ACL Profile Publish Topic Exception"
  solace_acl_publish_topic_exception:
    # jinja2 expression to retrieve the semp version from the gathered facts:
    semp_version: "{{ ansible_facts.solace.about.api.sempVersion }}"
    acl_profile_name: "my-new-profile"
    name: "t/v/a"
    state: present
````

### Settings for ansible-solace modules

The settings are NOT documented in the modules.
Instead, the documentation contains the URLs of the SEMP API call / Solace Cloud API call. Use the official documentation to find the settings for each module.


## Specifying Solace Cloud Parameters in Playbooks

Example inventory template including Solace Cloud API token and service id:

````yaml

---
all:
  hosts:
    edge-broker:
      ansible_connection: local
      meta:
        service_name: Ansible-Solace-IoT-Assets-Edge-Broker-1
      sempv2_host: xxx.messaging.solace.cloud
      sempv2_is_secure_connection: true
      sempv2_password: xxxx
      sempv2_port: 943
      sempv2_timeout: '60'
      sempv2_username: xxxx
      solace_cloud_api_token: xxxx
      solace_cloud_service_id: xxxx
      virtual_router: primary
      vpn: xxxx

````

For example, the module `solace_client_profile` uses a different API for Brokers and Solace Cloud Services.

````yaml

solace_client_profile:
  host: "{{ sempv2_host }}"
  port: "{{ sempv2_port }}"
  secure_connection: "{{ sempv2_is_secure_connection }}"
  username: "{{ sempv2_username }}"
  password: "{{ sempv2_password }}"
  timeout: "{{ sempv2_timeout }}"
  msg_vpn: "{{ vpn }}"
  # if inventory contains solace_cloud_api_token and solace_cloud_service_id, use it,
  # otherwise set the parameter to None.
  solace_cloud_api_token: "{{ solace_cloud_api_token | default(omit) }}"
  solace_cloud_service_id: "{{ solace_cloud_service_id | default(omit) }}"

````

---
The End.
