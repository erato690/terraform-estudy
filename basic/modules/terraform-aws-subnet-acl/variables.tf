variable "vpc_id" {
    description = "VPC ID"
}

variable "subnet_acl" {

    type = map(object({
        egress = list(object({
            protocol   = string
            rule_no    = number
            action     = string
            cidr_block = string
            from_port  = number
            to_port    = number
        }))
        ingress = list(object({
            protocol   = string
            rule_no    = number
            action     = string
            cidr_block = string
            from_port  = number
            to_port    = number
        }))
    })) 
}

variable "environment" {
  description = "Deployment Environment"
}
variable "tags" {
  type = map(string)
  default = {}
}