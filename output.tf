//Output values
output "vpc_" {
  value = aws_default_vpc.default.id
}
output "subnet_" {
  value = aws_default_subnet.default_az1.id
}
output "publicip_" {
  value = aws_instance.web_ec2.public_ip
}
output "ec2_" {
  value = aws_instance.web_ec2.id
}
output "domainname_" {
  value = aws_s3_bucket.bucket1.bucket_domain_name
}