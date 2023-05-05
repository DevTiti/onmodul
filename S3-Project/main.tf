provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "onmodul-dev" {
  bucket = "onmodul-dev"

  tags = {
    Name = "OnModul"
  }

}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.onmodul-dev.id
  versioning_configuration {
    status = "Disabled"
  }


}

resource "aws_s3_bucket_policy" "example_policy" {
  bucket = aws_s3_bucket.onmodul-dev.id
  policy = data.aws_iam_policy_document.public-access.json
}

data "aws_iam_policy_document" "public-access" {
  statement {
 
    principals {
      type = "AWS"
      identifiers = [408935668637]
    }
    actions = ["s3:GetObject","s3:ListBucket"]
    resources = [
        aws_s3_bucket.onmodul-dev.arn,
        "${aws_s3_bucket.onmodul-dev.arn}/*"
    ]

  }

}