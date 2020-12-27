# Tutorial: Working with Users and Access Control Profiles

This tutorial shows how you can set up Access Control Lists (ACLs) and Client Usernames so application clients are able to connect.

It sets up ACL profiles and users for a shipment tracking use case:
* Tracking publisher profile and example user
* ACL profiles and sample user for internal monitoring applications
* An example of a partner ACL and user that is allowed to subscribe to tracking events for a specific region.

## Details

When running the tutorial, the following sequence is executed:

- start a local broker service in docker: `service.playbook.yml`
  - uses the latest Solace PubSub+ Standard Edition image
- configure the users & acl profiles: `configure.playbook.yml`
  - users & acl definitions: `vars/acl-users.vars.yml`

## Run the tutorial

### Prerequisites
````bash
pip install docker-compose
````

### Run
````bash
./run.sh
````

### Check

- login to the admin console: `http:localhost:8080`, `admin/admin`
- VPN: default
- Access Control:
  - ACL Profiles
  - Client Usernames


---
