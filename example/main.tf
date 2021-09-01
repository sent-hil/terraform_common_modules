module "vpc" {
  source = "../vpc"

  aws_region       = var.aws_region
  aws_profile_name = var.aws_profile_name
  project          = var.project
}

module "rds_postgres" {
  source = "../rds_postgres"

  aws_region       = var.aws_region
  aws_profile_name = var.aws_profile_name
  project          = var.project

  rds_database_name     = var.rds_database_name
  rds_database_username = var.rds_database_username
  rds_database_password = var.rds_database_password
  rds_allocated_storage = var.rds_allocated_storage
  rds_database_port     = var.rds_database_port
  rds_instance_class    = var.rds_instance_class

  private_subnet_id_1          = module.vpc.private_subnet_id_1
  private_subnet_id_2          = module.vpc.private_subnet_id_2
  vpc_id                       = module.vpc.vpc_id
  vpc_public_subnet_cidr_block = module.vpc.public_subnet.cidr_block
}

module "elastic_redis" {
  source = "/Users/senthil/play/terraform-common-modules/elastic_redis"

  aws_region       = var.aws_region
  aws_profile_name = var.aws_profile_name
  project          = var.project

  vpc_id                       = module.vpc.vpc_id
  private_subnet_id_1          = module.vpc.private_subnet_id_1
  private_subnet_id_2          = module.vpc.private_subnet_id_2
  vpc_public_subnet_cidr_block = module.vpc.public_subnet.cidr_block

  redis_node_type = var.redis_node_type
}

module "elasticbeanstalk" {
  source = "../elasticbeanstalk"

  aws_region       = var.aws_region
  aws_profile_name = var.aws_profile_name

  vpc_id            = module.vpc.vpc_id
  vpc_public_subnet = module.vpc.public_subnet

  project     = var.project
  project_env = var.project_env
  app_path    = var.app_path
  app_version = var.app_version
}
