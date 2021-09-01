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

variable "project_env" {
}

variable "redis_node_type" {
}

variable "redis_port" {
}

variable "redis_node_count" {
}

variable "private_subnet_id_1" {
}

variable "private_subnet_id_2" {
}

variable "vpc_id" {
}

variable "vpc_public_subnet_cidr_block" {
}
