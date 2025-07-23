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
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.37"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # Optional
  cluster_endpoint_public_access = var.cluster_endpoint_public_access

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = [module.vpc.private_subnets]

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}
