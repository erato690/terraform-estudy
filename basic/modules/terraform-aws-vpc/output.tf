output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}
output "vpc_cidr" {
  value = "${aws_vpc.vpc.cidr_block}"
}

output "subnet-ids" {
  value = values(aws_subnet.subnet).*.id
}