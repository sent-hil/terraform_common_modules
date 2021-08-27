variable "aws_profile_name" {
  description = "AWS profile name"
  default     = "default"
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "project" {
  description = "Name of project (no spaces or special characters). "
}

variable "rds_database_port" {
  description = "Port of database."
  default = 5432
}

variable "rds_database_name" {
}

variable "rds_database_username" {
}

variable "rds_database_password" {
}

variable "rds_allocated_storage" {
  description = "GB of disk space."
  default = 100
}

variable "rds_instance_class" {
  default = "db.t3.micro"
}

variable "private_subnet_id_1" {
}

variable "private_subnet_id_2" {
}

variable "vpc_id" {
}

variable "vpc_public_subnet_cidr_block" {
}
