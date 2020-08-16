# Concepts

- idempotency
- hosts are not hosts
- facts

A few notes on ansible-solace:
-	The modules support configuration of a broker in an idempotent manner. That means, running the same playbook twice will leave the system in exactly the same state.
-	Ansible has the concept of hosts (obviously) , configure in the inventory file. We have hijacked the host concept – here a host is either:
o	a Solace Event Broker, or

o	a Solace Cloud Account

-	This also means, none of the normal setup and fact gathering Ansible provides work. Hence, we need to tell Ansible this and set "ansible_connection": "local" so it doesn’t try to login. To gather Solace Event Broker facts, special modules exists, solace_gather_facts and solace_cloud_account_gather_facts.
-	The ansible-solace modules structure follows the convention of the Solace SEMP V2 API, for example:
o	solace_client_username maps to https://docs.solace.com/API-Developer-Online-Ref-Documentation/swagger-ui/config/index.html#/clientUsername
o	solace_queue maps to https://docs.solace.com/API-Developer-Online-Ref-Documentation/swagger-ui/config/index.html#/queue
o	and so on.

TODO:
- settings are not documented, use the corresponding SEMP V2 API description
- facts - how to work with them
  - solace cloud:
    - create service - inventory, connection params, etc.
  - broker:
    - connection params
  - semp version

## Using the API Version in Playbooks

The `settings` fieldnames can differ from version to version.
Here are some examples of how to deal with it.

````yaml
# main playbook

tasks:

- name: Get Solace Facts
  solace_get_facts:

- include_vars:
    file: "./lib/mqtt.vars.json"
    name: target_list

- name: Adding Mqtt Sessions
  include_tasks: mqtt.tasks.yml
  loop: "{{ target_list.mqttSessions }}"
  loop_control:
    loop_var: mqtt_session_item
````

````yaml

# mqtt.tasks.yml

- name: Update Mqtt Session
  # switch settings from vars
  solace_mqtt_session:
    mqtt_session_client_id: "{{ mqtt_session_item.mqttSessionClientId }}"
    settings: "{{ mqtt_session_item.settings._gt_eq_2_14 if ansible_facts.solace.about.api.sempVersion | float >= 2.14 else omit }}"
    state: present

- name: Update Mqtt Session
  # skip task if version not correct
  solace_mqtt_session:
    mqtt_session_client_id: "{{ mqtt_session_item.mqttSessionClientId }}"
    settings:
      queueMaxMsgSize: 200000
      queueMaxBindCount: 10
    state: present
  when: ansible_facts['solace']['about']['api']['sempVersion'] | float >= 2.14

````

The include file:

````json
{
  "mqttSessions": [
    {
      "mqttSessionClientId": "ansible-solace_test_mqtt__1__",
      "settings": {
        "_gt_eq_2_14": {
          "queueMaxMsgSize": 200000,
          "queueMaxBindCount": 10
        }
      },
      "subscriptions": [
        "ansible-solace/test/__1__/topic/subscription/1/>",
        "ansible-solace/test/__1__/topic/subscription/2/>",
        "ansible-solace/test/__1__/topic/subscription/3/>"
        ]
    },
    {
      "mqttSessionClientId": "ansible-solace_test_mqtt__2__",
      "subscriptions": [
        "ansible-solace/test/__2__/topic/subscription/1/>",
        "ansible-solace/test/__2__/topic/subscription/2/>",
        "ansible-solace/test/__2__/topic/subscription/3/>"
        ]
    }
  ]
}

````

## Specifying Solace Cloud Parameters in Playbooks

Example inventory template including Solace Cloud API token and service id:

````json
{
  "all": {
    "hosts": {
      "solace-cloud-1": {
        "meta": {
          "account": "{account-name}",
          "service": "{service-name}"
        },
        "ansible_connection": "local",
        "solace_cloud_api_token": "{api-token}",
        "solace_cloud_service_id": "{service-id}",
        "sempv2_host": "{host}.messaging.solace.cloud",
        "sempv2_port": 943,
        "sempv2_is_secure_connection": true,
        "sempv2_username": "{username}",
        "sempv2_password": "{password}",
        "sempv2_timeout": "60",
        "vpn": "{vpn}",
        "virtual_router": "primary"
      }
    }
  }
}

````

Example playbook:
See [Client Profile examples/tests](test-test/solace_get_client_profiles/playbook.yml).

---
The End.
