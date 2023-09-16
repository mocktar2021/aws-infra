resource "aws_db_instance" "example" {
  allocated_storage    = 20  # Specify the storage size
  storage_type         = "gp2"  # Specify the storage type
  engine               = "mysql"  # Specify your desired database engine
  instance_class       = "db.t2.micro"
  identifier           = var.db_instance_identifier
  username             = "dbuser"
  password             = "dbpassword"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true  # Modify as needed
  # Add any additional configuration for your RDS database
}