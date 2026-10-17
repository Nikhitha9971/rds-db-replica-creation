provider "aws" {
  region = "us-east-1"
}

# Primary RDS Database
resource "aws_db_instance" "rdsdb" {
  identifier             = "terraform-rdsdb"
  allocated_storage      = 20
  storage_type           = "gp3"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"

  db_name  = "mydatabase"
  username = "adminuser"
  password = 123456789

  backup_retention_period = 1
  publicly_accessible     = false
  skip_final_snapshot     = true

  tags = {
    Name = "RDS-Primary"
  }
}

# Read Replica Database
resource "aws_db_instance" "rds_replica" {
  identifier          = "terraform-rds-replica"
  replicate_source_db = aws_db_instance.rdsdb.identifier
  instance_class      = "db.t3.micro"

  publicly_accessible = false
  skip_final_snapshot = true

  tags = {
    Name = "RDS-Read-Replica"
  }
}

variable "db_password" {
  description = "Password for the primary RDS database"
  type        = string
  sensitive   = true
}