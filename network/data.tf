locals {

  azs = ["us-east-1a", "us-east-1b", "us-east-1c"]

  subnets_public_cidr_block = [
    cidrsubnet(var.vpc_main_cidr, 3, 0),
    cidrsubnet(var.vpc_main_cidr, 3, 1),
    cidrsubnet(var.vpc_main_cidr, 3, 2)
  ]

  subnets_private_cidr_block = [
    cidrsubnet(var.vpc_main_cidr, 3, 3),
    cidrsubnet(var.vpc_main_cidr, 3, 4),
    cidrsubnet(var.vpc_main_cidr, 3, 5)
  ]

}
