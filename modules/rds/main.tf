data "aws_secretsmanager_secret_version" "RDS_secret" {
  secret_id = "RDS_secret"
}

locals {
  rds_creds = jsondecode(data.aws_secretsmanager_secret_version.RDS_secret.secret_string)
}

resource "aws_db_subnet_group" "rds_subnet" {
  name       = "main"
  subnet_ids = [var.private_subnet_ids[1], var.private_subnet_ids[0]]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = local.rds_creds.username
  password             = local.rds_creds.password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  multi_az             = true
  db_subnet_group_name = aws_db_subnet_group.rds_subnet.name
}
