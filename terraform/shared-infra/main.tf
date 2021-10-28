terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 1.0.9"
}

provider "aws" {
  profile = "default"
  region  = "ap-southeast-2"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.env_prefix}-eshop-tfstate"
  acl    = "private"

  versioning {
    enabled = true
  }
}