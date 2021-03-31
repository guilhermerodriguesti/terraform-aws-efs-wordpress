//S3 bucket
resource "aws_s3_bucket" "bucket1" {
  bucket        = "task22akwp-myimage"
  acl           = "public-read"
  force_destroy = true
}

resource "null_resource" "git_download" {
  provisioner "local-exec" {
    command = "git clone https://github.com/guilhermerodriguesti/login.git login"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rmdir  login /s /q" //rm -rf login --> for linuxos  2>nul
  }

}

resource "aws_s3_bucket_object" "image_upload" {
  key          = "image1.png"
  bucket       = aws_s3_bucket.bucket1.bucket
  source       = "login/cloudFront.png"
  acl          = "public-read"
  content_type = "image/png"
  depends_on   = [aws_s3_bucket.bucket1, null_resource.git_download]
}

//Cloudfront
locals {
  s3_origin_id = "S3-task1-myimage"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  //Origin Settingd
  origin {
    domain_name = aws_s3_bucket.bucket1.bucket_domain_name
    origin_id   = local.s3_origin_id

  }

  enabled         = true
  is_ipv6_enabled = true
  //default_root_object = "index.html"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "allow-all"

  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  depends_on = [aws_s3_bucket.bucket1]

}