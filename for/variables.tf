variable "env" {

  default = "dev"
}

variable "vpc_id" {

  type    = list(string)
  default = ["vpc-0a0a0a0a0a0a0a0a0"]

}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_profile" {
  default = "default"
}

variable "instance_type" {

  type = object({
    dev  = string
    prod = string
  })

  description = "type of instance to create"

  default = {
    dev  = "t2.micro"
    prod = "t2.medium"
  }
}

variable "instance_count" {

  type = object({
    dev  = number
    prod = number
  })

  description = "Number of instances to create"

  default = {
    dev  = 1
    prod = 3
  }
}

variable "project_name" {

  type        = string
  description = "Name of the project"
  default     = "terraform-for-exemple"

}