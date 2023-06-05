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
  ami           = "ami-04f798ca92cc13f74"
  instance_type = "t2.micro"
  key_name      = "tomcat-test"
  associate_public_ip_address = true
  subnet_id     = aws_subnet.example_subnet.id
  vpc_security_group_ids = [aws_security_group.example_sg.id]
  depends_on = [aws_internet_gateway.gw]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum -y update
              sudo amazon-linux-extras install java-openjdk11
              sudo groupadd --system tomcat
              sudo useradd -d /usr/share/tomcat -r -s /bin/false -g tomcat tomcat
              wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.63/bin/apache-tomcat-9.0.63.tar.gz
              sudo tar xvf apache-tomcat-9.0.63.tar.gz -C /usr/share/
              sudo ln -s /usr/share/apache-tomcat-$VER/ /usr/share/tomcat
              sudo chown -R tomcat:tomcat /usr/share/tomcat
              sudo chown -R tomcat:tomcat /usr/share/apache-tomcat-9.0.63/
              sudo systemctl daemon-reload
              sudo systemctl start tomcat
              sudo systemctl enable tomcat
              EOF

  tags = {
    Name = "example_instance"
  }
}
