output "security-group-ids" {
  description = "Ids dos security groups criados"
  value =  values(aws_security_group.security_group).*.id
}

