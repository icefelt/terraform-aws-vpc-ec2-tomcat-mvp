# terraform-aws-vpc-ec2-tomcat-mvp
terraform-aws-vpc-ec2-tomcat-mvp

This code creates a VPC with a single subnet, an Internet Gateway, and a Security Group The Scurity Group allows incoming traffic on ports 22 and 80. This code also creates an EC2 instance in the subnet, using a user data script to install Tomcat and start the service.

Note: This code installs in us-west-2 for testing. 

ToDo: make variables for region, AMI, instance_type, tags
ToDo: Test with .war file
ToDO: update README with usage, other parts
