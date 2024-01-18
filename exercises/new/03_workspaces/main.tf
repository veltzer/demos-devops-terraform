provider "aws" {
  region	= "eu-north-1"
}

resource "aws_instance" "fubar" {
  subnet_id     = "subnet-07be8adbfd31a75b5"
  ami           = "ami-0014ce3e52359afbd"
  instance_type = "${terraform.workspace == "dev" ? "t3.micro" : "t3.small"}" 
}
