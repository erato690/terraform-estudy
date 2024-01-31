terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    archive = {
      source = "hashicorp/archive"
      version = "2.4.1"
    }

    random = {
      source = "hashicorp/random"
      version = "3.6.0"
    }
    
     template = {
      source = "hashicorp/template"
      version = "2.2.0"
    }
  }

  backend "s3" {
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "${var.aws_region}"
  profile = "${var.aws_profile}"
}
