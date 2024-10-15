resource "aws_ec2_transit_gateway" "tgw" {

  tags = {
    Name = "TGW"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_1_attachment" {
  vpc_id                = var.vpc_1_id
  subnet_ids            = [var.vpc_1_subnet_id]  
  transit_gateway_id    = aws_ec2_transit_gateway.tgw.id
  tags = { 
    Name = "VPC1"
     }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_2_attachment" {
  vpc_id                = var.vpc_2_id
  subnet_ids            = [var.vpc_2_subnet_id]  
  transit_gateway_id    = aws_ec2_transit_gateway.tgw.id
  tags = { 
    Name = "VPC2"
     }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_3_attachment" {
  vpc_id                = var.vpc_3_id
  subnet_ids            = [var.vpc_3_subnet_id] 
  transit_gateway_id    = aws_ec2_transit_gateway.tgw.id
  tags = {
     Name = "VPC3" 
     }
}

resource "aws_ec2_transit_gateway_route_table" "tgw_route_table" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = { 
    Name = "TGW Route Table"
     }
}

resource "aws_ec2_transit_gateway_route" "route_tgw" {
  destination_cidr_block = "0.0.0.0/0"  
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_route_table.id
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.vpc_3_attachment.id
}



output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.tgw.id
}

output "tgw_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.tgw_route_table.id
}


################################################################

resource "aws_route_table" "rt-vpc3" {
  vpc_id = var.vpc_3_id
  tags   = { 
    Name = "Public Route Table VPC 3" 
    }
 route {
    cidr_block = var.vpc_1_cidr 
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  route {
    cidr_block = var.vpc_2_cidr 
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }
}



resource "aws_route_table_association" "private_rt_association_vpc3" {
  subnet_id      = var.vpc_3_subnet_id  
  route_table_id = aws_route_table.rt-vpc3.id
}

#################################################################


resource "aws_route_table" "rt-vpc2" {
  vpc_id = var.vpc_2_id
  tags   = { 
    Name = "Private Route Table VPC 2" 
    }
 
 route {
    cidr_block = var.vpc_1_cidr
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  route {
    cidr_block =var.vpc_3_cidr
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
 
}



resource "aws_route_table_association" "private_rt_association_vpc2" {
  subnet_id      = var.vpc_2_subnet_id  
  route_table_id = aws_route_table.rt-vpc2.id
}


#############################

resource "aws_route_table" "rt-vpc1" {
  vpc_id = var.vpc_1_id
  tags   = { 
    Name = "Private Route Table VPC 1"
    
     }
 route {
    cidr_block = var.vpc_3_cidr
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  route {
    cidr_block = var.vpc_2_cidr
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
}



resource "aws_route_table_association" "private_rt_association_vpc1" {
  subnet_id      = var.vpc_1_subnet_id  
  route_table_id = aws_route_table.rt-vpc1.id
}