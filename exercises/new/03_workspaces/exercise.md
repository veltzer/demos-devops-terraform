# Using workspaces

## Stages
* Turn off everything you built so far.
* Read the "workspaces" web page in terraform documentation.
* Take the tf you used to launch a machine.
* We want to launch this same resources twice:
    once for development and once for production.
* Create two workspaces - "development", "production".
* Modify your tf file to support two workspace.
    Make development deploy t3.micro machines while production
    will deploy t3.small.
* Demonstrate how you deploy "development" vs "production".

## References
[workspaces](https://developer.hashicorp.com/terraform/language/state/workspaces)
