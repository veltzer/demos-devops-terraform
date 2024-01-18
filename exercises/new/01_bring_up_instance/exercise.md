The purpose of the exercise is to
bring up a small machine on aws of type t2.micro

notes
our region is: eu-north-1
a good ami id is: ami-0014ce3e52359afbd

stages
1. write a main.tf files according to the slides.
	give your machine a name that you could recognize.
2. add a provider section that states that you are using aws.
3. use terraform init and terraform apply
4. see that your machine is indeed up via the console.
5. destroy your machine via
	terraform destroy
