
resource "aws_instance" "web_ec2" {

  ami                    = var.ami_id //Linux 2 AMI[Free tier eligible]
  instance_type          = var.instance_type
  key_name               = aws_key_pair.generated_key.key_name
  availability_zone      = var.availability_zone
  subnet_id              = aws_default_subnet.default_az1.id
  vpc_security_group_ids = [aws_security_group.security_group.id]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = aws_instance.web_ec2.public_ip
    private_key = tls_private_key.key.private_key_pem
    timeout     = "10m"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd git -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo yum install amazon-efs-utils -y",
      "sudo yum install nfs-utils -y",
    ]
  }
  tags = {
    Name = var.instance_name
  }
}

resource "null_resource" "update_link" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.key.private_key_pem
    host        = aws_instance.web_ec2.public_ip
    port        = 22
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 777 /var/www/html -R",
      "sudo echo \"<img src='http://${aws_cloudfront_distribution.s3_distribution.domain_name}/${aws_s3_bucket_object.image_upload.key}'>\" >> /var/www/html/index.html",
    ]
  }
  depends_on = [aws_cloudfront_distribution.s3_distribution]
}

//Create EFS
resource "aws_efs_file_system" "efs" {
  creation_token = "w_efs"
  depends_on     = [aws_security_group.security_group]
  tags = {
    Name = "Wordpress-EFS"
  }
}

resource "aws_efs_mount_target" "mount_efs" {
  depends_on = [aws_efs_file_system.efs, aws_instance.web_ec2]

  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = aws_default_subnet.default_az1.id
}

resource "null_resource" "newlocal" {
  depends_on = [
    aws_efs_mount_target.mount_efs,
    aws_instance.web_ec2,
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.key.private_key_pem
    host        = aws_instance.web_ec2.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod ugo+rw /etc/fstab",
      "sudo echo '${aws_efs_file_system.efs.id}:/ /var/www/html efs tls,_netdev' >> /etc/fstab",
      "sudo mount -a -t efs,nfs4 defaults",
      "sudo rm -rf /var/www/html/*",
      "sudo git clone https://github.com/guilhermerodriguesti/login.git /var/www/html",

    ]
  }
}