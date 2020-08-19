# Tutorial: Working with Queues

Creates queues and subscriptions based on input JSON file.

See ``playbook-include`` for tasks and variables included in the main `playbook.yml`.

## Run the tutorial

### Start the local broker
````bash
./start.local.broker.sh
````

#### Login to broker console
- Chrome: open a new incognito window
- http://localhost:8080
- user: admin
- pwd: admin

### Run the playbook
````bash
./run.sh
````

### Check Broker
When prompted, check out the queues on the broker.

### Stop the local broker
````bash
./stop.local.broker.sh
````

---
The End.
