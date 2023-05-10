provider "aws" {
  region = "eu-central-1"
}

#------------------------------
resource "aws_s3_bucket" "terraform_state" {
    bucket = "terraform-onmodul"

    # Prevent accidental deletion of this s3 bucket

    lifecycle {
       prevent_destroy = true
    }
}

#--------------------------------
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

#---------------------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "default-encrytpion" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#-----------------------------------
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.terraform_state.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

#-------------------------------------
resource "aws_dynamodb_table" "terraform_locks" {
  name = "onmodul-dynamodb"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  
  attribute {
    name = "LockID"
    type = "S"
  }
}

#---------------BACKEND------------------
terraform {
  backend "s3" {
   bucket = "terraform-onmodul"
   key = "global/s3/terraform.tfstate"
   region = "eu-central-1"
  
  dynamodb_table = "onmodul-dynamodb"
  encrypt = true
}
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the s3 bucket"

}

output "dynamodb_table_name"{
    value = aws_dynamodb_table.terraform_locks.name
    description = "The name of the DynamoDB  Table"
  
}


