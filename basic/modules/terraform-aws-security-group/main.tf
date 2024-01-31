resource "aws_security_group" "security_group" {
    
    for_each = var.security_group

    vpc_id =  var.vpc_id
    
    dynamic "egress" {
        for_each = each.value.egress
        content {
            from_port   = egress.value.from_port
            to_port     = egress.value.to_port
            protocol    = egress.value.protocol
            cidr_blocks = egress.value.cidr_blocks
        }
      
    }

    dynamic "ingress" {
        for_each = each.value.ingress
        content {
            from_port   = ingress.value.from_port
            to_port     = ingress.value.to_port
            protocol    = ingress.value.protocol
            cidr_blocks = ingress.value.cidr_blocks
        }
    }
    
     tags =  {  
         Name = "${var.environment}-security-group-${each.value.name}" 
         description = each.value.description
    }
}
