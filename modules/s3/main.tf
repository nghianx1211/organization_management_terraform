resource "aws_s3_bucket" "organization_management" {
  bucket = var.s3.bucket_name

  tags = {
    "Name" = var.s3.bucket_name
  }
}