data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = split(",", data.aws_availability_zones.available)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = [local.azs[0], local.azs[1], local.azs[2]]
  private_subnets = [var.private_subnets[0], var.private_subnets[1], var.private_subnets[2]]
  public_subnets  = [var.public_subnets[0], var.public_subnets[1], var.public_subnets[2]]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.37"

  cluster_name    = "example"
  cluster_version = "1.33"

  # Optional
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = "vpc-1234556abcdef"
  subnet_ids = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
