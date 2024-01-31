terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "tfstate-remote-state-dev"
    key     = "dev/terraform-for-exemple/terraform.tfstate"
    region  = "us-east-1"
    profile = "default"
  }
}


provider "aws" {
  # Configuration options
   profile = "default"
   region     = "us-east-1"
}