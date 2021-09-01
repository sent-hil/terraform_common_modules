# Common variables
variable "aws_profile_name" {
}

variable "aws_region" {
}

variable "project" {
}

variable "project_env" {
}

# rds_postgres module variables
variable "rds_database_port" {
}

variable "rds_database_name" {
}

variable "rds_database_username" {
}

variable "rds_database_password" {
}

variable "rds_allocated_storage" {
}

variable "rds_instance_class" {
}

# elastic_redis module variables
variable "redis_node_type" {
}

# elasticbeanstalk module variables
variable "app_version" {
}

variable "app_path" {
}
