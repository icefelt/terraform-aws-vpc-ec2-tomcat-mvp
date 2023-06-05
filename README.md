# terraform-aws-vpc-ec2-tomcat-mvp
terraform-aws-vpc-ec2-tomcat-mvp

This code creates a VPC with a single subnet, an Internet Gateway, and a Security Group The Scurity Group allows incoming traffic on ports 22 and 80. This code also creates an EC2 instance in the subnet, using a user data script to install Tomcat and start the service.

Note: This code installs in us-west-2 for testing. 

ToDo: make variables for region, AMI, instance_type, tags
ToDo: Test with .war file
ToDO: update README with usage, other parts
ToDo: better testing
ToDo: convert #2 add route table to terraform
ToDo: convert #3 add outbound rule to security group in terraform

1. 
chmod 400 ~/tomcat-test.pem

2. 
In AWS Cnosole, VPC > Route Tables > rtb-01f58fafd40b0e5f7
open route tables, add route
Destination - 0.0.0.0/0
Target - igw-071413f4c5eed1854


In AWS Cnosole, EC2 > Security Groups > sg-06972569bdc582ac0
open outbound rules, edit outbond rules add rule
Type - All TCP
Destination - 0.0.0.0/0

3. 
ssh -i ~/tomcat-test.pem ec2-user@52.38.211.163