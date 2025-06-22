resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name    = "MainPublicRouteTable",
    Project = var.project
  }
}


resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name    = "MainPrivateRouteTable",
    Project = var.project
  }
}

resource "aws_route_table_association" "rt_associate_public" {
  count = length(local.subnets_public_cidr_block)

  subnet_id      = aws_subnet.public_subnets_main[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "rt_associate_private" {
  count = length(local.subnets_private_cidr_block)

  subnet_id      = aws_subnet.private_subnets_main[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}
