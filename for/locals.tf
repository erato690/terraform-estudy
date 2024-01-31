locals {

  instance_count = lookup(var.instance_count, var.env)

  common_tags = {
    "owner"       = "Rafael dias"
    "date_create" = timestamp()
  }

  subnet_ids = [for subnet in data.aws_subnet.example : subnet.id] //values(data.aws_subnet.example).*.id
}