# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "Udacity_T2" {
  count         = "4"
  ami           = "ami-0dbc3d7bc646e8516"
  instance_type = "t2.micro"
  security_groups = ["default"]

  tags = {
    Name = "Udacity T2"
  }
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "Udacity_M4" {
  count         = "2"
  ami           = "ami-0dbc3d7bc646e8516"
  instance_type = "m4.large"
  security_groups = ["default"]

  tags = {
    Name = "Udacity M4"
  }
}
