# Bring up an Instance

The purpose of the exercise is to bring up a small machine on aws of type `t2.micro`

## notes
* our region is: `eu-north-1`
* a good AMI id is: `ami-0014ce3e52359afbd`

## stages
* write a main.tf files according to the slides.
    give your machine a name that you could recognize.
* add a provider section that states that you are using aws.
* use terraform init and terraform apply
* see that your machine is indeed up via the console.
* destroy your machine via
    `$ terraform destroy`
