resource "aws_s3_bucket" "pipeline_bucket" {
  bucket = var.s3_bucket_name
}

