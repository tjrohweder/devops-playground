data "aws_availability_zones" "available" {
  state = "available"
}

resource "null_resource" "kubectl" {
  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${module.eks.cluster_name}"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.21"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = var.enable_nat_gateway

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.37"

  cluster_name                             = var.cluster_name
  cluster_version                          = var.cluster_version
  cluster_endpoint_public_access           = var.cluster_endpoint_public_access
  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions
  cluster_upgrade_policy = {
    support_type = var.cluster_upgrade_policy
  }

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
      most_recent       = true
    }
    kube-proxy = {
      resolve_conflicts = "OVERWRITE"
      most_recent       = true
    }
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
      most_recent       = true
    }
  }

  eks_managed_node_groups = {
    main = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m6a.large"]

      min_size     = 2
      max_size     = 10
      desired_size = 2
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}
