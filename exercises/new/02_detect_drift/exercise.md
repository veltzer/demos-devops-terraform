Detecting drift

1. Bring up a machine on aws using a .tf file
2. Using the console change something on that machine
	(add a tag, change a tag, change the type of the machine).
3. Run
	$ terraform apply
4. Was the drift detected?
