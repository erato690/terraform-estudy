variable "env" {
  
  default = "dev"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  
  type = object({
    dev = string
    prod = string 
  })

  description = "type of instance to create"

    default = {
        dev = "t2.micro"
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
      dev = 1
      prod = 3
    }

}

variable "instance_ami" {
  
  type = string
  description = ""
  default = "ami-079db87dc4c10ac91"

  validation {
    condition = length(var.instance_ami) > 0
    error_message = "You must provide a valid AMI ID."
  }
}