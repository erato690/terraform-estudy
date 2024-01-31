resource "aws_instance" "exemple_ec2" {
  
  count = local.instance_count <= 0 ?  0: local.instance_count

  ami = var.instance_ami

  instance_type = lookup(var.instance_type, var.env)

  tags = merge(local.common_tags, 
  {
    Name = format("Instance %d",count.index+1)
    ENV  = format("%s", var.env)
  })
}


