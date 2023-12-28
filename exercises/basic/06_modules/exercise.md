# Exercise #6: Modules

Terraform is *ALL* about modules.  Every terraform working directory is really just a module that could be reused by others. This is one of the key capabilities and organizational precepts of Terraform.

In this exercise, we are going to modularize the code that we have been playing with during this whole workshop, but instead of constantly redeclaring everything, we are just going to reference the module that we've created and see if it works.

First, create a main.tf file in the main directory for this 6th exercise.  Inside this `main.tf`, please add the following:

```hcl
provider "aws" {
  version = "~> 2.0"
}

module "key_pair_1" {
  source        = "./modules/key_pair/"
  region        = "us-west-1"
  student_alias = "${var.student_alias}"
}

# We're not defining region in this module call, so it will use the default as defined in the module
# What happens when you remove the default from the module and don't pass here? Feel free to try it out.
module "key_pair_2" {
  source        = "./modules/key_pair/"
  student_alias = "${var.student_alias}"
}
```

Next, create a `variables.tf` file so we can capture `student_alias` to pass it through to our module:

```hcl
variable "student_alias" {
  description = "Your student alias"
}
```

What we've done here is create a `main.tf` config file that references a module stored in a local directory, twice.  This allows us to encapsulate any complexity contained by the module's code while still allowing us to pass variables or parameters into the module that will handle creating and managing the parameterized resources.

After doing this, you can then begin the init and apply process.

```bash
terraform init
terraform plan
terraform apply
```

Can you explain why these aren't conflicting key pair resources? Why can we create both of these resources successfully?

You'll notice that terraform manages each resource as if there is no module division, meaning the resources are bucketed into one big change list, but under the covers Terraform's dependency graph will show some separation.  It's very difficult, for example, to create dependencies between two resources that are in different modules.  You can, however, use interpolation to create a variable dependency between two modules at the root level, ensuring one is created before the other. Specific applications where direct resource dependency is required really necessitate the grouping of those resources into a single module or project.

### Finishing this exercise

Let's run the following to finish:

```
terraform destroy
```
