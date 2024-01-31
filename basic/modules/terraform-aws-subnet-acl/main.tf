resource "aws_network_acl" "acl" {

  for_each = var.subnet_acl

  vpc_id = var.vpc_id

  dynamic "ingress" {

    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      rule_no     = ingress.value.rule_no
      action      = ingress.value.action
      cidr_block  = ingress.value.cidr_block
    }
  }

  dynamic "egress" {
    
    for_each = each.value.egress

    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      rule_no     = egress.value.rule_no
      action      = egress.value.action
      cidr_block  = egress.value.cidr_block
    }
  }

  tags = {
    Name = "example"
  }
}