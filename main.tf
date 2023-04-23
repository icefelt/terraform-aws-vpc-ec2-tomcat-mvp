# AWS Provider Configuration
provider "aws" {
  region = "us-west-2"  # Replace with your desired region
}

# Create VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.example_vpc.id
}

# Create Subnet
resource "aws_subnet" "example_subnet" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.1.0/24"
  depends_on = [aws_internet_gateway.gw]
}

# Create Security Group
resource "aws_security_group" "example_sg" {
  name_prefix = "example_sg_"
  vpc_id      = aws_vpc.example_vpc.id
  depends_on = [aws_internet_gateway.gw]

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 Instance
resource "aws_instance" "example_instance" {
  ami           = "ami-009c5f630e96948cb"  # Replace with your desired AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.example_subnet.id
  vpc_security_group_ids = [aws_security_group.example_sg.id]
  depends_on = [aws_internet_gateway.gw]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum install -y tomcat
              sudo systemctl start tomcat
              sudo systemctl enable tomcat
              EOF

  tags = {
    Name = "example_instance"
  }
}
