# Terraform v1.2.7 on darwin_arm64
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9"
    }
  }
}

provider "aws" {
  shared_credentials_files = ["$HOME/.aws/credentials"]
  profile                  = "pollinone"
  region                   = var.aws_region
}