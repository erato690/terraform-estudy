
module "vpc" {
  source               = "./modules/terraform-aws-vpc"
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  subnets              = {
      "public" = {
        cidr_block         = var.subnet_cidr["public"].cidr_block
        availability_zone  = "us-east-1a"
        is_public          = true
        name               = "public",
        route_table = [
            {
            routes = [
                {
                cidr_block =  local.cidr_public
                },

            ]
            }
        ]
        },

    "private" = {
        cidr_block         = var.subnet_cidr["private"].cidr_block
        availability_zone  = "us-east-1b"
        is_public          = false
        name               = "private",
        route_table = [
            {
            routes = [
                {
                    cidr_block = local.cidr_public
                }
            ]
            }
        ]
    },

    "mgmt" = {
        cidr_block         = var.subnet_cidr["mgmt"].cidr_block
        availability_zone  = "us-east-1c"
        is_public          = false
        name               = "mgmt",
        route_table = [
            {
            routes = [
                {
                cidr_block = var.my_cidr
                }
            ]
            }
        ]
    }
  }
}

module "subnet_acl"{
  source               = "./modules/terraform-aws-subnet-acl"
  environment          = var.environment
  vpc_id               = module.vpc.vpc_id
  subnet_acl           ={
    "public" = {
        ingress = [
            {
            from_port   = 80
            to_port     = 80
            protocol    = "tcp"
            rule_no     = 100
            action      = "allow"
            cidr_block  = local.cidr_public
            },
            {
            from_port   = 443
            to_port     = 443
            protocol    = "tcp"
            rule_no     = 101
            action      = "allow"
            cidr_block  = local.cidr_public
            }
        ]
        egress = [
            {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            rule_no     = 100
            action      = "allow"
            cidr_block  = local.cidr_public
            }
        ]
    },

    "private" = {
        ingress = [
            {
            from_port   = 80
            to_port     = 80
            protocol    = "tcp"
            rule_no     = 100
            action      = "allow"
            cidr_block  = var.subnet_cidr["public"].cidr_block
            },
            {
            from_port   = 443
            to_port     = 443
            protocol    = "tcp"
            rule_no     = 101
            action      = "allow"
            cidr_block  = var.subnet_cidr["public"].cidr_block
            },
            {
            from_port   = 22
            to_port     = 22
            protocol    = "tcp"
            rule_no     = 102
            action      = "allow"
            cidr_block  = var.subnet_cidr["mgmt"].cidr_block
            }
        ]
        egress = [
            {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            rule_no     = 100
            action      = "allow"
            cidr_block  = local.cidr_public
            }
        ]
    },

    "mgmt" = {
        ingress = [
            {
            from_port   = 22
            to_port     = 22
            protocol    = "tcp"
            rule_no     = 100,
            action      = "allow"
            cidr_block  = var.my_cidr
            }
        ]
        egress = [
            {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            rule_no     = 100
            action      = "allow"
            cidr_block  = var.my_cidr
            }
        ]
    }
  }   

  depends_on = [ module.vpc ]
}


module security_group {
  source               = "./modules/terraform-aws-security-group"
  environment          = var.environment
  vpc_id               = module.vpc.vpc_id
 
  security_group       = {
    "public" = {
        name = "public"
        description = "security group for public subnet"
        ingress = [
            {
            from_port   = 80
            to_port     = 80
            protocol    = "tcp"
            cidr_blocks =  [local.cidr_public]
            },
            {
            from_port   = 443
            to_port     = 443
            protocol    = "tcp"
            cidr_blocks = [local.cidr_public]
            }
        ]
        egress = [
            {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = [local.cidr_public]
            }
        ]
    },

    "private" = {
        name = "private"
        description = "security group for private subnet"
        ingress = [
            {
            from_port   = 80
            to_port     = 80
            protocol    = "tcp"
            cidr_blocks = [var.subnet_cidr["public"].cidr_block]
            },
            {
            from_port   = 443
            to_port     = 443
            protocol    = "tcp"
            cidr_blocks = [var.subnet_cidr["public"].cidr_block]
            },
            {
            from_port   = 22
            to_port     = 22
            protocol    = "tcp"
            cidr_blocks = [var.subnet_cidr["mgmt"].cidr_block]
            }
        ]
        egress = [
            {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = [local.cidr_public]
            }
        ]
    },

    "mgmt" = {
        name = "mgmt"
        description = "security group for mgmt subnet"
        ingress = [
            {
            from_port   = 443
            to_port     = 443
            protocol    = "udp"
            cidr_blocks = [var.my_cidr]
            },
            {
              from_port   = 1194
              to_port     = 1194
              protocol    = "udp"
              cidr_blocks = [var.my_cidr]
            }
        ]
        egress = [
            {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = [local.cidr_public]
            }
        ]
    }
  }

  depends_on = [ module.vpc ]

}