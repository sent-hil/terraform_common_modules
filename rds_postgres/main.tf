provider "aws" {
  profile = var.aws_profile_name
  region  = var.aws_region

  default_tags {
    tags = {
      Project   = "${var.project}"
      Terraform = true
    }
  }
}

# -----------------------------------------------------------------------------
# Subnet group for private subnets
# -----------------------------------------------------------------------------
resource "aws_db_subnet_group" "maindb_subnet_group" {
  name        = "${var.project}_subnets_group"
  description = "${var.project} vpc"
  subnet_ids = [
    var.private_subnet_id_1,
    var.private_subnet_id_2
  ]
}

# -----------------------------------------------------------------------------
# Postgres RDS instance in private subnet.
# -----------------------------------------------------------------------------
resource "aws_db_instance" "maindb" {
  allocated_storage    = var.rds_allocated_storage
  engine               = "postgres"
  instance_class       = var.rds_instance_class
  identifier           = var.rds_database_name
  name                 = var.rds_database_name
  username             = var.rds_database_username
  password             = var.rds_database_password
  db_subnet_group_name = aws_db_subnet_group.maindb_subnet_group.name

  vpc_security_group_ids = [
    aws_security_group.db_vpc_only.id
  ]
}

# -----------------------------------------------------------------------------
# Security group for instances to connect to DB.
# -----------------------------------------------------------------------------
resource "aws_security_group" "db_vpc_only" {
  vpc_id      = var.vpc_id
  name        = "db_vpc_only"
  description = "Allow internal VPC connections."

  ingress {
    description = "5432 from VPC public subnet."
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [
      var.vpc_public_subnet_cidr_block
    ]
  }
}
