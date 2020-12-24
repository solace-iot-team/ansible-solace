# Tutorial: Working with Queues

Creates queues and subscriptions based on variables file.

- start the local broker service in docker: `service.playbook.yml`
- configure the queues & subscriptions: `configure.playbook.yml`
  - queue definitions: `vars/queues.vars.yml`
  - loops over queues using task: `tasks/queues.tasks.yml`
- prompt to inspect queues in broker console
  ````bash
  - browser: open a new incognito window
  - http://localhost:8080
  - login: admin / admin
  ````
- delete queues again

## Run the tutorial

````bash
./run.sh
````
---
The End.
