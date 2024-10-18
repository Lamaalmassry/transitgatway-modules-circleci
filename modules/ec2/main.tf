# Generate SSH Key Pair
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096

}

# AWS Key Pair using the dynamically generated key
resource "aws_key_pair" "key" {
  key_name   = "my-key-pair"
  public_key = tls_private_key.key.public_key_openssh  # Directly use generated key

  tags = {
    Name = "my-key-pair"
  }
}

# Security Group for EC2 Instances in VPC 3
resource "aws_security_group" "ec2_sg_3" {
  name   = "ec2_security_group_3"
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
    Name = "ec2_sg_3"
  }
}

# Security Group for EC2 Instances in VPC 2
resource "aws_security_group" "ec2_sg_2" {
  name   = "ec2_security_group_2"
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
    Name = "ec2_sg_2"
  }
}

# EC2 instance in VPC 3# EC2 instance in VPC 3
resource "aws_instance" "ec2" {
  ami                          = "ami-0ebfd941bbafe70c6"
  instance_type                = "t2.micro"
  subnet_id                    = var.vpc_3_subnet_id
  associate_public_ip_address   = true
  key_name                     = aws_key_pair.key.key_name  # Reference the created key pair
  vpc_security_group_ids       = [aws_security_group.ec2_sg_3.id]

  # Inject public key into the EC2 instance via user data
  user_data = <<-EOF
              #!/bin/bash
              mkdir -p /home/ec2-user/.ssh
              echo "${tls_private_key.key.public_key_openssh}" > /home/ec2-user/
              chown ec2-user:ec2-user /home/ec2-user/
              chmod 600 /home/ec2-user/
              EOF

  tags = {
    Name = "VPC_3_Test_Instance"
  }
}

# EC2 instance in VPC 2
resource "aws_instance" "vpc_2_test" {
  ami                          = "ami-0ebfd941bbafe70c6"
  instance_type                = "t2.micro"
  subnet_id                    = var.vpc_2_subnet_id
  associate_public_ip_address   = false
  key_name                     = aws_key_pair.key.key_name  # Reference the created key pair
  vpc_security_group_ids       = [aws_security_group.ec2_sg_2.id]

  # Inject public key into the EC2 instance via user data
  user_data = <<-EOF
              #!/bin/bash
              mkdir -p /home/ec2-user/
              echo "${tls_private_key.key.public_key_openssh}" > /home/ec2-user/
              chown ec2-user:ec2-user /home/ec2-user/
              chmod 600 /home/ec2-user/
              EOF

  tags = {
    Name = "VPC_2_Test_Instance"
  }
}


# Output the private key (handle with care)
output "private_key" {
  value     = tls_private_key.key.private_key_pem
  sensitive = true
}

# Output the public key
output "public_key" {
  value = tls_private_key.key.public_key_openssh
}

resource "local_file" "private_key" {
  filename = "${path.module}/id_rsa"
  content  = tls_private_key.key.private_key_pem
  file_permission = "0600"
}

resource "local_file" "public_key" {
  filename = "${path.module}/id_rsa.pub"
  content  = tls_private_key.key.public_key_openssh
  file_permission = "0644"
}
