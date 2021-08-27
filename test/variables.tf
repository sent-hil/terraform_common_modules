variable "aws_profile_name" {
  description = "AWS profile name"
  default     = "default"
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "project" {
  description = "Name of your project"
}

variable "rds_database_engine_version" {
  default = "10"
}

variable "rds_database_port" {
  default = 5432
}

variable "rds_database_name" {
}

variable "rds_database_username" {
}

variable "rds_database_password" {
}

variable "rds_allocated_storage" {
  default = 100
}

variable "rds_instance_class" {
  default = "db.t3.micro"
}
