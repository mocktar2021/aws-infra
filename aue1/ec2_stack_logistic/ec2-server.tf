//This Terraform Template creates a logistic Server using JDK 11 on EC2 Instance.
//Jenkins Server is enabled with Git, Docker and Docker Compose,
//AWS CLI Version 2, Python 3, Ansible, Terraform and Boto3.
//Jenkins Server will run on Amazon Linux 2 EC2 Instance with
//custom security group allowing HTTP(80, 8080) and SSH (22) connections from anywhere.

provider "aws" {
  region = var.region
  //  access_key = ""
  //  secret_key = ""
  //  If you have entered your credentials in AWS CLI before, you do not need to use these arguments.
}

resource "aws_instance" "tf-logistic-server" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.mykey
  vpc_security_group_ids = [aws_security_group.tf-logistic-sec-gr.id]
  iam_instance_profile = aws_iam_instance_profile.tf-logistic-server-profile.name
  ebs_block_device {
    device_name = "/dev/xvda"
    volume_type = "gp2"
    volume_size = 16
  }
  tags = {
    Name = var.logistic-server-tag
    server = "logistic"
  }
  user_data = file("ec2data.sh")
}

resource "aws_security_group" "tf-logistic-sec-gr" {
  name = var.logistic_server_secgr
  tags = {
    Name = var.logistic_server_secgr
  }
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    protocol    = "tcp"
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "tf-logistic-server-role" {
  name               = var.logistic-role
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess", "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess", "arn:aws:iam::aws:policy/AdministratorAccess"]
}

resource "aws_iam_instance_profile" "tf-logistic-server-profile" {
  name = var.logistic-profile
  role = aws_iam_role.tf-logistic-server-role.name
}

output "logistic" {
  value = aws_instance.tf-logistic-server.public_dns
}

output "logisticURL" {
  value = "http://${aws_instance.tf-logistic-server.public_dns}:80"
}