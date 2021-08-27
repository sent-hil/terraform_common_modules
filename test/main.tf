module "vpc" {
  source = "../vpc"

  aws_region = var.aws_region
  aws_profile_name = var.aws_profile_name
  project = var.project
}
