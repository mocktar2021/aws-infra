# # Define the AWS provider and region
# provider "aws" {
#   region = "us-east-1" # Replace with your desired region
# }

# # Create a VPC (Virtual Private Cloud)
# resource "aws_vpc" "asmita_vpc" {
#   cidr_block = "10.0.0.0/16"
# }

# # Create a public subnet within the VPC
# resource "aws_subnet" "asmita_subnet" {
#   vpc_id                  = aws_vpc.asmita_vpc.id
#   cidr_block              = "10.0.1.0/24"
#   availability_zone       = "us-east-1a" # Replace with your desired availability zone
#   map_public_ip_on_launch = true
# }

# # Create a security group for EC2 instances
# resource "aws_security_group" "asmita_security_group" {
#   name        = "asmita-security-group"
#   description = "asmita security group for web servers"
#   vpc_id      = aws_vpc.asmita_vpc.id
  
#   # Define inbound rules to allow incoming traffic
#   # Rule 1: HTTP (Port 80)
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # Rule 2: HTTPS (Port 443)
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # Rule 3: SSH (Port 22) - Only for administration (restrict the source IP if possible)
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/32"] # Replace with your public IP
#   }
  
#   # Rule 4: Custom Rules (Add more as needed)
#   # asmita: Allow custom port 8080
#   ingress {
#     from_port   = 8080
#     to_port     = 8080
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
  
#   # Rule 5: ICMP (Ping) - Optional
#   ingress {
#     from_port   = -1
#     to_port     = -1
#     protocol    = "icmp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
  
#   # ... Add more rules as necessary
# }

# # Create an EC2 instance for hosting the Asmita application
# resource "aws_instance" "asmita_instance" {
#   ami           = "ami-04cb4ca688797756f" # Replace with a valid AMI ID
#   instance_type = "t2.micro"           # Replace with your desired instance type
#   subnet_id     = aws_subnet.asmita_subnet.id
#   key_name      = "vprofile-bean-key" # Replace with your SSH key pair name
#   security_groups = [aws_security_group.asmita_security_group.id]
  
#   # Define user data to install Apache or any other web server and deploy your app
#   user_data = <<-EOF
#               #!/bin/bash
#               sudo yum update -y
#               sudo yum install -y httpd
#               sudo systemctl start httpd
#               sudo systemctl enable httpd
#               # Deploy your app here
#               EOF
# }

# # Output the public IP address of the EC2 instance
# output "instance_public_ip" {
#   value = aws_instance.asmita_instance.public_ip
# }