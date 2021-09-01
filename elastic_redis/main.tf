provider "aws" {
  profile = var.aws_profile_name
  region  = var.aws_region

  default_tags {
    tags = {
      Project   = var.project
      Terraform = true
    }
  }
}

# -----------------------------------------------------------------------------
# Subnet group for private subnets
# -----------------------------------------------------------------------------
resource "aws_elasticache_subnet_group" "maindb_subnet_group" {
  name = "${var.project}-cache-subnets-group"
  subnet_ids = [
    var.private_subnet_id_1
  ]
}

resource "aws_security_group" "cache_vpc_only" {
  vpc_id      = var.vpc_id
  name        = "cache_vpc_only"
  description = "Allow internal VPC connections."

  ingress {
    description = "${var.redis_port} from VPC public subnet."
    from_port   = var.redis_port
    to_port     = var.redis_port
    protocol    = "tcp"
    cidr_blocks = [
      var.vpc_public_subnet_cidr_block
    ]
  }
}

resource "aws_elasticache_cluster" "maindb" {
  cluster_id         = "${var.project}-${var.project_env}"
  engine             = "redis"
  node_type          = var.redis_node_type
  num_cache_nodes    = var.redis_node_count
  port               = var.redis_port
  subnet_group_name  = aws_elasticache_subnet_group.maindb_subnet_group.name
  security_group_ids = [aws_security_group.cache_vpc_only.id]
}
