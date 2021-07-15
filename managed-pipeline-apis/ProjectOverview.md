# Project Overview

This project configures a set of message VPNs on a single broker which separate the **_providers_** of **_API Event Services_** from the **_consumers_** of _**APIs**_, both logically and physically.

The concepts described here are derived from Async API Management basics.

The goal is to:
- describe each API Event Services in a configuration file and use a standardized playbook for the creation or removal
- describe each App in a configuration file and use a set of standardized playbooks to either create or remove the App
  - each App can be configured to only subscribe / publish to a subset of available events for an API Event Service
  - each App can subscribe / publish to 1 or many API Event Services
- keep a set of files that reflect the current state of all configured API Event Services and Apps

In particular:
- ensure each API Event Service and each App can be managed separately
- ensure access and flow of events are controlled
- create an audit log trace for each SEMP call by timestamp, playbook, broker, and vpn

The configured objects on the message VPNs:

<p align="center"><img src="./doc/images/overview.png" width=1200 /></p>


---
