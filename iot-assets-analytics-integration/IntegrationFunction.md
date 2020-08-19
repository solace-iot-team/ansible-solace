# Integration Function

## Example: Azure

Azure Function that receives the events from the broker and populates a Data Lake.

- create a resource group
- create a function app
- create a function:
  - HTTP POST trigger
  - receive the data in the POST request
  - parse the URL
  - determine the Data Lake path from it
  - use the appropriate data lake API to populate the data lake
- Create a Storage
  - Gen2 Storage
  - use Blob or Table storage


Once you have the function live, add it's configuration here:

````bash
vi ./lib/vars.rdp.yml

  # add the code to the post request target
  post_request_target_params: "code=xxx-yyy-zzz"
  # add the remote host of the function
  remote_host: "host.domain.com"
  # add the domain of the host here
  trusted_common_name: "*.domain.com"

````

---
The End.
