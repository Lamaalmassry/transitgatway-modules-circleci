resource "aws_subnet" "vpc_1_private" {
  vpc_id            = var.vpc_1_id
  cidr_block        = var.vpc_1_private_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "VPC_1_Private"
  }
}

resource "aws_subnet" "vpc_2_private" {
  vpc_id            = var.vpc_2_id
  cidr_block        = var.vpc_2_private_cidr
  availability_zone = "us-east-1b"

  tags = {
    Name = "VPC_2_Private"
  }
}

resource "aws_subnet" "vpc_3_public" {
  vpc_id            = var.vpc_3_id
  cidr_block        = var.vpc_3_public_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "VPC_3_Public"
  }
}

output "vpc_1_private_id" {
  value = aws_subnet.vpc_1_private.id
}

output "vpc_2_private_id" {
  value = aws_subnet.vpc_2_private.id
}
output "vpc_3_public_id" {
  value = aws_subnet.vpc_3_public.id
}