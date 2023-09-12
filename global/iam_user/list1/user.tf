# Define the IAM User
provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}

resource "aws_iam_user" "ashley_gross" {
  name = "ashley.gross@mocktar.com"
}


# Create an IAM Access Key for the User
# resource "aws_iam_access_key" "karl_noble_access_key" {
#   user = aws_iam_user.karl_noble.name
# }

# Attach the Existing Infinity-RW Policy to the User
# resource "aws_iam_user_policy_attachment" "s3_policy_attachment" {
#   user       = aws_iam_user.ashley_gross.name
#   policy_arn = "arn:aws:iam::338492938289:policy/mcdonalds-rw"
# }

# Output the Access Key and Secret Key
# output "access_key" {
#   value = aws_iam_access_key.karl_noble_access_key.id
# }

# output "secret_key" {
#   value = aws_iam_access_key.karl_noble_access_key.secret
#   sensitive = true
# }