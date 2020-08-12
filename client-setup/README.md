# Client Setup

This sample shows how you can set up Access Control Lists (ACLs) and Client Usernames so application clients are able to connect.

It sets up ACL profiles and users for a shipment tracking use case:
* Tracking publisher profile and example user
* ACL profiles and sample user for internal monitoring applications
* An example of a partner ACL and user that is allowed to subscribe to tracking events for a specific region.

## Use of solace_gather_facts 

The playbook uses `solace_gather_facts` to extract environment and broker information.

```
      - name: Gather Solace Facts
        solace_gather_facts:

```

This is required as some tasks need to be provided with SEMP v2 API version or similar information 
For example when creating ACL exceptions the `semp_version` must be provided:
```
      - name: Add ACL Subscribe Exception
        solace_acl_subscribe_topic_exception:
          name: "{{ item.1.topic }}"
          acl_profile_name: "{{ item.0.name }}"
          msg_vpn: "{{ msg_vpn }}"
          topic_syntax: "{{ item.1.syntax }}"
          semp_version: "{{ ansible_facts.solace.about.api.sempVersion }}"
        with_subelements: 
          - "{{ acls | default([]) }} "
          - subscribe_topic_exceptions
          - flags:
```

## Run this project

````bash

./run.sh

````

---
The End.
