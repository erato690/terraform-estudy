variable "environment" {
    type = string
}

variable "vpc_cidr" {
	type = string
}


variable "subnet_cidr" {
    type = map(object({
        name = string
        cidr_block = string
    }))
}

variable "my_cidr" {
    type = string
}