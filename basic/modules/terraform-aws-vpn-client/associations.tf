resource aws_ec2_client_vpn_network_association private {
   client_vpn_endpoint_id =  aws_ec2_client_vpn_endpoint.vpn_client.id
   subnet_id              =  var.vpn-subnet-mgmt-id
   security_groups        = var.vpn-security-group-id
 }