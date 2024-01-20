# Detecting drift

## Stages
* Bring up a machine on aws using a .tf file
* Using the console change something on that machine
    (add a tag, change a tag, change the type of the machine).
* Run
    `$ terraform apply`
* Was the drift detected?
