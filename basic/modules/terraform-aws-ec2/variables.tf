variable "environment" {
  description = "Deployment Environment"
}

variable "name" {}

variable "aws-ecs-key-name-acess" {}

variable "aws-subnet-id" {}

variable "vpc-security-group-ids" {
   type = list
  description = "Security group id"
}

variable "is-public" {
  type = bool
  description = "Create ip public"
  default = false
}
