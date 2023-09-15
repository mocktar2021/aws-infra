resource "aws_instance" "example" {
  ami           = var.ami  # AMI ID for your desired OS
  instance_type = var.instance_type
  # Add any additional configuration you need for your EC2 instance
}
