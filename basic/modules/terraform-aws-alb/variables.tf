variable "environment" {
  description = "Deployment Environment"
}

variable "aws-subnet-id" {}

variable "aws-vpc-id" {}

variable "alb-health-check-path" {
   type = string
}

variable "alb-health-check-port" {
    type = string
}

variable "alb-target-group-port" {
  type = number
}

variable "alb-target-group-protocol" {
  type = string
}


variable "alb-security-group-ids" {
   type = list
  description = "Security group id"
}


variable "alb-internal" {
  type = bool
  default = false
}


variable "alb-type" {
  type = string
  default = "application"
}

variable "alb-target-type" {
  type = string
  default = "instance"
}

variable "alb-instance-ids" {
   type = list
   description = "List instance ids"
}
