provider "aws" {
  profile = var.aws_profile_name
  region  = var.aws_region
}

locals {
  #project_with_env = "${var.project}-${var.project_env}" # uncomment after testing
  project_with_env = "${var.project_env}"
  ssh_key_name   = "${local.project_with_env}-SSH"
}

# -----------------------------------------------------------------------------
# Security group to allow only inbound http and https access to EB instance.
# -----------------------------------------------------------------------------
resource "aws_security_group" "allow_inbound_http" {
  vpc_id      = var.vpc_id
  name        = "allow_inbound_http"
  description = "Allow HTTP/HTTPS inbound traffic"

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow HTTP/HTTPS inbound traffic"
  }
}

# -----------------------------------------------------------------------------
# Generate a SSH key pair and save to local to SSH into EB instances.
# -----------------------------------------------------------------------------
resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "default" {
  key_name   = local.ssh_key_name
  public_key = tls_private_key.default.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.default.private_key_pem}' > ./${local.ssh_key_name}.pem && chmod 400 ./${local.ssh_key_name}.pem"
  }
}

# -----------------------------------------------------------------------------
# Create S3 bucket to store application artifacts.
# -----------------------------------------------------------------------------
resource "aws_s3_bucket" "default" {
  #bucket = "${var.project}-deploy"
  bucket = "${local.project_with_env}-deploy-1"
  force_destroy = true
}

resource "aws_s3_bucket_object" "default" {
  bucket   = aws_s3_bucket.default.id
  key      = "${local.project_with_env}/${var.app_version}"
  source   = "${var.app_path}/${var.app_version}"
}

# -----------------------------------------------------------------------------
# Create ElasticBeanstalk app in VPC and public subnet.
# -----------------------------------------------------------------------------
resource "aws_elastic_beanstalk_application_version" "default" {
  application = aws_elastic_beanstalk_application.default.name
  bucket      = aws_s3_bucket.default.id
  key         = aws_s3_bucket_object.default.id
  name        = "${var.app_version}"
}

resource "aws_iam_instance_profile" "beanstalk_service_profile" {
  name = "beanstalk_service_user"
  role = aws_iam_role.beanstalk_service_role.name
}

resource "aws_iam_role" "beanstalk_service_role" {
  name = "beanstalk_service_role"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_elastic_beanstalk_application" "default" {
  description = "${var.project} application (terraform-managed)"
  name        = var.project

  appversion_lifecycle {
    service_role          = aws_iam_role.beanstalk_service_role.arn
    max_count             = 128
    delete_source_from_s3 = true
  }
}

resource "aws_elastic_beanstalk_environment" "default" {
  application   = aws_elastic_beanstalk_application.default.name
  version_label = aws_elastic_beanstalk_application_version.default.id

  name                = "${local.project_with_env}"
  #cname_prefix        = "${local.project_with_env}2222"

  solution_stack_name = var.eb_solution_stack_name
  tier                = "WebServer"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = var.vpc_public_subnet.id
  }

  setting {
    name      = "EC2KeyName"
    namespace = "aws:autoscaling:launchconfiguration"
    value     = aws_key_pair.default.key_name
  }
  setting {
    name      = "InstanceTypes"
    namespace = "aws:ec2:instances"
    value     = var.eb_instance_type
  }
  setting {
    name      = "MaxSize"
    namespace = "aws:autoscaling:asg"
    value     = "2"
  }
  setting {
    name      = "MinSize"
    namespace = "aws:autoscaling:asg"
    value     = "1"
  }
  setting {
    name      = "RollingUpdateEnabled"
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    value     = "true"
  }
  setting {
    name      = "SecurityGroups"
    namespace = "aws:autoscaling:launchconfiguration"
    value     = aws_security_group.allow_inbound_http.id
  }
  setting {
    name      = "IamInstanceProfile"
    namespace = "aws:autoscaling:launchconfiguration"
    value     = aws_iam_instance_profile.beanstalk_service_profile.name
  }
}
