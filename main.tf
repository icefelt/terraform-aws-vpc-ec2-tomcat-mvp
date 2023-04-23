provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  name = "my-vpc"
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.0/16"
  availability_zone = var.availability_zone
}

resource "aws_security_group" "tomcat" {
  name = "tomcat-security-group"
  description = "Security group for Tomcat instances"

  ingress {
    protocol = "tcp"
    port = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ec2_instance" "tomcat" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.public.id
  security_groups = [aws_security_group.tomcat.id]

  tags = {
    Name = "Tomcat"
  }

  provisioner "file" {
    sources = ["./tomcat.war"]
    destination = "/opt/tomcat/webapps/ROOT.war"
  }

  provisioner "remote-exec" {
    inline = ["sudo service tomcat restart"]
  }
}
