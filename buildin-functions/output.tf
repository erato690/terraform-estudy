output "instance_public_ip" {
    value = aws_instance.exemple_ec2.*.public_ip
}

output "instance_name" {
  value = join(",", aws_instance.exemple_ec2.*.tags.Name)
}