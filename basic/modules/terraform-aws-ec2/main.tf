resource "aws_instance" "default" {
  instance_type = "t2.micro"
  key_name = var.aws-ecs-key-name-acess

  subnet_id = var.aws-subnet-id
  vpc_security_group_ids = var.vpc-security-group-ids
  associate_public_ip_address = var.is-public
  ami = "ami-04a5bc23012bfc6ce"

  tags = {
    Name = var.name
  }
}

