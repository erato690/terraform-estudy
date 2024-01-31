resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr

    tags =  merge(local.tags_default,{  
        Name = "${var.environment}-vpc"  
    })
  
}

resource "aws_subnet" "subnet" {

    for_each = var.subnets

    vpc_id = aws_vpc.vpc.id
    cidr_block = each.value.cidr_block
    map_public_ip_on_launch = each.value.is_public
    availability_zone = each.value.availability_zone

    tags =  merge(local.tags_default,{  
         Name = "${var.environment}-subnet-${ each.value.name}" 
    })


}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.environment}-internet-gateway"
  }
}



resource "aws_route_table" "public_route_table" {

  for_each = { for k, subnet in var.subnets : k => subnet if subnet.is_public }

  vpc_id = aws_vpc.vpc.id

  dynamic "route" {
    
    for_each = each.value.route_table[0].routes

    content {
      cidr_block = route.value.cidr_block
      gateway_id = aws_internet_gateway.internet_gateway.id
    }
  }

  tags = {
    Name = "${var.environment}-${each.key}-route-table"
  }

  depends_on = [ aws_subnet.subnet,aws_internet_gateway.internet_gateway,aws_nat_gateway.nat_gateway ]
}


resource "aws_route_table" "private_route_table" {
  for_each = { for k, subnet in var.subnets : k => subnet if !subnet.is_public }

  vpc_id = aws_vpc.vpc.id


  dynamic "route" {
    
    for_each = each.value.route_table[0].routes

    content {
      cidr_block = route.value.cidr_block
      gateway_id = aws_nat_gateway.nat_gateway.id
    }
  }
  
  tags = {
    Name = "${var.environment}-${each.key}-route-table"
  }

  depends_on = [ aws_subnet.subnet,aws_internet_gateway.internet_gateway,aws_nat_gateway.nat_gateway ]
}


resource "aws_route_table_association" "route_table_association" {
  for_each = aws_subnet.subnet

  subnet_id      = each.value.id
  route_table_id = var.subnets[each.key].is_public ? aws_route_table.public_route_table[each.key].id : aws_route_table.private_route_table[each.key].id

  
  depends_on = [ aws_route_table.private_route_table,aws_route_table.public_route_table ]
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id     = aws_eip.nat_eip.id
  subnet_id         = aws_subnet.subnet["public"].id

  depends_on = [aws_subnet.subnet, aws_eip.nat_eip]
}

