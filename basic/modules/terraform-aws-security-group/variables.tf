variable "environment" {description = "Deployment Environment"}

variable "vpc_id" {type = string}

variable "security_group" {
  type = map(object({
    name = string
    description = string
    ingress = list(object({
      from_port = number
      to_port = number
      protocol = string
      cidr_blocks = list(string)
    }))
    egress = list(object({
      from_port = number
      to_port = number
      protocol = string
      cidr_blocks = list(string)
    }))
  }))
  
}