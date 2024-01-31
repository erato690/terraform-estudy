output "vpn-cdir-output" {
  value = var.vpn-cdir
}


output "vpn-id" {
  value = aws_ec2_client_vpn_endpoint.vpn_client.id
}

