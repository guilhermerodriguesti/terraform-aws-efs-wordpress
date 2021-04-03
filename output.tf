//Output values
output "aws_default_vpc" {
  value = aws_default_vpc.default.id
}
output "aws_default_subnet" {
  value = aws_default_subnet.default_az1.id
}
output "web_ec2_public_ip" {
  value = aws_instance.web_ec2.public_ip
}
output "id_web_ec2" {
  value = aws_instance.web_ec2.id
}
output "domainname" {
  value = aws_s3_bucket.bucket1.bucket_domain_name
}