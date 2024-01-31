variable "environment" {
  description = "Deployment Environment"
}

variable "vpn-vpc-id" {
  description = "Deployment Environment"
}


variable "vpn-subnet-mgmt-id" {
  type = string
  description = "Deployment Environment"
}

variable "vpn-cdir" {
  default = "10.20.4.0/22" 
}


variable "vpn-server-certificate-arn" {}

variable "vpn-security-group-id" {
  type = list
  default = []
}