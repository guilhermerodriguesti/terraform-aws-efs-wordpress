//Default vpc
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}
resource "aws_default_subnet" "default_az1" {
  availability_zone = var.availability_zone

  tags = {
    Name = "Default subnet for us-east-1a"
  }
}