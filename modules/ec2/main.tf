# Security Group for EC2 Instances
resource "aws_security_group" "ec2_sg_3" {
  name        = "ec2_security_group_3"
  vpc_id = var.vpc_3_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_sg"
  }
}


# Security Group for EC2 Instances
resource "aws_security_group" "ec2_sg_2" {
  name        = "ec2_security_group_2"
  vpc_id = var.vpc_2_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_sg"
  }
}


# EC2 instance in VPC 3
resource "aws_instance" "ec2" {
  ami                    = "ami-0ebfd941bbafe70c6"
  instance_type          = "t2.micro"
  subnet_id              = var.vpc_3_subnet_id
  associate_public_ip_address = true
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg_3.id]

  tags = {
    Name = "VPC_3_Test_Instance"
  }
}

# EC2 instance in VPC 2
resource "aws_instance" "vpc_2_test" {
  ami                    = "ami-0ebfd941bbafe70c6"
  instance_type          = "t2.micro"
  subnet_id              = var.vpc_2_subnet_id
  associate_public_ip_address = false
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg_2.id]

  tags = {
    Name = "VPC_2_Test_Instance"
  }
}


resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)

  tags = {
    Name = "my-key-pair"
  }
}


output "key_name" {
  value       = aws_key_pair.key.public_key
  sensitive   = true  
}
