
variable "vpc_cidr" {
	type = string
}

variable "subnets" {
	
	type = map(object({
		cidr_block = string
		availability_zone = string
		is_public = bool
		name = string
		route_table = list(object({
			routes = list(object({
				cidr_block = string                                                                                                                                                                                                                                                                                                                                                                                    
			}))
		}))
	}))

}

variable "environment" {
  description = "Deployment Environment"
}


