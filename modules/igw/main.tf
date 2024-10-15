resource "aws_internet_gateway" "igw" {
   vpc_id = var.vpc_3_id

  tags = { 
    Name = "Internet Gateway for VPC" 
    }
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}