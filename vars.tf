variable "region" { default = "us-east-1" }
variable "profile" { default = "default" }
variable "availability_zone" { default = "us-east-1a" }
variable "stack" { default = "wordpress" }

variable "access_key" {
  default = ""
}
variable "secret_key" {
  default = ""
}
variable "instance_type" {
  default = "t2.micro"
}
variable "ami_id" {
  default = "ami-0742b4e673072066f"
}
variable "instance_name" {
  type    = string
  default = "SRV_WEB01"
}
variable "key_name" {
  default = "webserver"
}