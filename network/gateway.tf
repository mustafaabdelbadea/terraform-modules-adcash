resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "MainVPCGW",
    Project = var.project
  }
}

resource "aws_eip" "Maineip" {
  domain = "vpc"
  tags = {
    Name    = "MainEIP",
    Project = var.project
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.Maineip.id
  subnet_id     = aws_subnet.public_subnets_main[0].id

  tags = {
    Name    = "MainNatGW",
    Project = var.project
  }

  depends_on = [aws_internet_gateway.gw]
}
