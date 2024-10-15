resource "aws_vpc" "vpc_1" {
  cidr_block = var.vpc_1_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC_1"
  }
}

resource "aws_vpc" "vpc_2" {
  cidr_block = var.vpc_2_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC_2"
  }
}

resource "aws_vpc" "vpc_3" {
  cidr_block = var.vpc_3_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC_3"
  }
}


output "vpc_1_id" {
  value = aws_vpc.vpc_1.id
}

output "vpc_2_id" {
  value = aws_vpc.vpc_2.id
}

output "vpc_3_id" {
  value = aws_vpc.vpc_3.id
}