//This Terraform Template creates a asmita Server using JDK 11 on EC2 Instance.
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

resource "aws_instance" "tf-asmita-server" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.mykey
  vpc_security_group_ids = [aws_security_group.tf-asmita-sec-gr.id]
  iam_instance_profile = aws_iam_instance_profile.tf-asmita-server-profile.name
  ebs_block_device {
    device_name = "/dev/xvda"
    volume_type = "gp2"
    volume_size = 16
  }
  tags = {
    Name = var.asmita-server-tag
    server = "asmita"
  }
  user_data = file("ec2data.sh")
}

resource "aws_security_group" "tf-asmita-sec-gr" {
  name = var.asmita_server_secgr
  tags = {
    Name = var.asmita_server_secgr
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

resource "aws_iam_role" "tf-asmita-server-role" {
  name               = var.asmita-role
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

resource "aws_iam_instance_profile" "tf-asmita-server-profile" {
  name = var.asmita-profile
  role = aws_iam_role.tf-asmita-server-role.name
}

output "asmita" {
  value = aws_instance.tf-asmita-server.public_dns
}

output "asmitaURL" {
  value = "http://${aws_instance.tf-asmita-server.public_dns}:80"
}