data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical

}


resource "aws_instance" "exemple_ec2" {
  
  count = local.instance_count <= 0 ?  0: local.instance_count

  ami = data.aws_ami.ubuntu.id
  
  instance_type = lookup(var.instance_type, var.env)

  tags = merge(local.common_tags, 
  {
    Name = format("Instance %d",count.index+1)
    ENV  = format("%s", var.env)
  })
}



output "id" {
  value = aws_instance.exemple_ec2.*.id
  
}

output "ami" {
  value = aws_instance.exemple_ec2.*.ami
  
}

output "arn" {
  value = aws_instance.exemple_ec2.*.arn
  
}