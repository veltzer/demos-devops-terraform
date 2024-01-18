Using workspaces

1. Turn off everything you built so far.
2. Read the "workspaces" web page in terraform documentation.
3. Take the tf you used to launch a machine.
4. We want to launch this same resources twice:
	once for development and once for production.
5. Create two workspaces - "development", "production".
6. Modify your tf file to support two workspace.
   Make development deploy t3.micro machines while production
	will deploy t3.small.
7. Demonstrate how you deploy "development" vs "production".

## References
[workspaces](https://developer.hashicorp.com/terraform/language/state/workspaces)
