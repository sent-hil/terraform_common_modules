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
  description = "production|staging etc."
  default     = "staging"
}

variable "app_version" {
  description = "Zip'ed bundle of the app to deploy to EB app."
}

variable "app_path" {
  description = "Folder of app_version."
}

// Get list from:
// $ aws elasticbeanstalk list-available-solution-stacks
variable "eb_solution_stack_name" {
  description = "EB Solution Stack."
  default     = "64bit Amazon Linux 2 v3.4.5 running Docker"
}

variable "eb_instance_type" {
  default = "t3.micro"
}

variable "vpc_id" {
  description = "VPC to which EB app will be deployed."
}

variable "vpc_public_subnet" {
  description = "VPC subnet to which EB app will be deployed."
}

variable "settings" {
  default = {}
}