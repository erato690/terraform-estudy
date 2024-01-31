resource "aws_ec2_client_vpn_endpoint" "vpn_client" {
   client_cidr_block      = var.vpn-cdir
   split_tunnel           = false
   server_certificate_arn = var.vpn-server-certificate-arn

   
   authentication_options {
     type                       = "certificate-authentication"
     root_certificate_chain_arn = var.vpn-server-certificate-arn
   }
   
   connection_log_options {
     enabled = false
   }   
 }

resource "aws_ec2_client_vpn_authorization_rule" "vpn_auth_rule" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn_client.id
  target_network_cidr = "0.0.0.0/0"
  authorize_all_groups = true
}