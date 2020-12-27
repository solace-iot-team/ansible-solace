# Tutorial: Working with Queues

Creates VPN, queues and subscriptions based on a variables file.

## Details

When running the tutorial, the following sequence is executed:

- start a local broker service in docker: `service.playbook.yml`
  - uses the latest Solace PubSub+ Standard Edition image
- create a VPN called `foo`
- configure the queues & subscriptions: `configure.playbook.yml`
  - queue definitions: `vars/queues.vars.yml`
  - loops over queues using task: `tasks/queues.tasks.yml`
- prompt to inspect queues in broker console
  ````bash
  - browser: open a new incognito window
  - http://localhost:8080
  - login: admin / admin
  - vpn: foo
  ````
- delete queues
- delete vpn

## Run the tutorial

### Prerequisites
````bash
pip install docker-compose
````
### Run
````bash
./run.sh
````
---
The End.
