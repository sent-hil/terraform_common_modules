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
# VPC that will contain all the resources created.
# -----------------------------------------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16" # 65,536 IP addresses
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# -----------------------------------------------------------------------------
# 2 private subnets for RDS.
# -----------------------------------------------------------------------------
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.${count.index + 1}.0/24" # 251 IP addresses
  count      = 2

  # RDS requires you have 2 diff. availability zones.
  availability_zone = "${var.aws_region}${count.index == 0 ? "b" : "a"}"

  tags = {
    Name = "${var.project} private subnet ${count.index + 1}"
  }
}

# -----------------------------------------------------------------------------
# 1 public subnet
# -----------------------------------------------------------------------------
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.3.0/24" # 251 IP addresses

  # TODO: does this matter which availability zone this is in?
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "${var.project} public subnet 1"
  }
}

# -----------------------------------------------------------------------------
# Expose the public subnet to the internet.
# -----------------------------------------------------------------------------
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project} internet gateway 1"
  }
}

resource "aws_route_table" "public_route_1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    Name = "${var.project} public route to internet"
  }
}

resource "aws_route_table_association" "public_route_1_public_subnet_1" {
  route_table_id = aws_route_table.public_route_1.id
  subnet_id      = aws_subnet.public_subnet.id
}
