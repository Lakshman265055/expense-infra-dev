terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.13.0"
    }
  }

  backend "s3" {
    bucket         = "expense-lakshman-dev"
    key            = "expense-rds-dev-1"
    region         = "us-east-1"
    dynamodb_table = "expense-dev-locking"
  }
}


provider "aws" {
  region = "us-east-1"
}