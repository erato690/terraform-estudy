terraform {
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

# Configure the AWS Provider
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
