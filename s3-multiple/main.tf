provider "aws" {
  region=var.region
}

resource "aws_s3_bucket" "multiple_buckets" {
  for_each = toset((var.bucket_list))
  bucket = each.key
}
