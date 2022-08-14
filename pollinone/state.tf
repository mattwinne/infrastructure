terraform {
  backend "s3" {
    bucket         = "terraform-state-pollinone-prod"
    encrypt        = true
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    profile        = "pollinone"
    kms_key_id     = "alias/terraform-bucket-key"
    dynamodb_table = "terraform-state-locker"
  }
}

resource "aws_s3_bucket" "terraform-state-pollinone-prod" {
  bucket = "terraform-state-pollinone-prod"

}

resource "aws_s3_bucket_acl" "terraform-state-acl" {
  bucket = aws_s3_bucket.terraform-state-pollinone-prod.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "terraform-state-versioning" {
  bucket = aws_s3_bucket.terraform-state-pollinone-prod.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource aws_s3_bucket_server_side_encryption_configuration "terraform-state-encryption" {
  bucket = aws_s3_bucket.terraform-state-pollinone-prod.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.terraform-bucket-key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.terraform-state-pollinone-prod.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_kms_key" "terraform-bucket-key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_kms_alias" "key-alias" {
  name          = "alias/terraform-bucket-key"
  target_key_id = aws_kms_key.terraform-bucket-key.key_id
}

resource "aws_dynamodb_table" "terraform-state-lock" {
  name           = "terraform-state-locker"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Pollinone Remote Terraform State Locking"
  }
}