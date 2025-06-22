resource "aws_vpc" "main" {
  cidr_block           = var.vpc_main_cidr
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = {
    Name    = "MainVPC",
    Project = var.project
  }
}

resource "aws_subnet" "public_subnets_main" {
  count = length(local.subnets_public_cidr_block)

  vpc_id            = aws_vpc.main.id
  cidr_block        = element(local.subnets_public_cidr_block, count.index)
  availability_zone = element(local.azs, count.index)

  tags = {
    Name    = "MainPublicSubnet ${count.index + 1}",
    Project = var.project
  }
}

resource "aws_subnet" "private_subnets_main" {
  count = length(local.subnets_private_cidr_block)

  vpc_id            = aws_vpc.main.id
  cidr_block        = element(local.subnets_private_cidr_block, count.index)
  availability_zone = element(local.azs, count.index)

  tags = {
    Name    = "MainPrivateSubnet ${count.index + 1}",
    Project = var.project
  }
}
