terraform {
  required_version = "~> 1.10.2"
  backend "s3" {
    bucket         = "kurage-infrastructures"
    region         = "ap-northeast-1"
    key            = "aws-note-vpc-with-eip/terraform.tfstate"
    dynamodb_table = "aws-note-sample-infra-vpc-with-eip"
  }
  required_providers {
    aws = {
      version = "~> 5.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Project = "aws-note"
      Owner   = "kurage"
    }
  }
}
