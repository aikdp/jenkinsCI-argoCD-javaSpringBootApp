terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "vpc-module-rs"
    key            = "jenkins-argo-ec2-terraform"
    region         = "us-east-1"
    dynamodb_table = "vpc-module-locking"
  }
}

provider "aws" {
  region = "us-east-1"
}