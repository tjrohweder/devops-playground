#General
env    = "dev"
region = "us-east-1"

#VPC
vpc_name           = "main"
vpc_cidr           = "172.32.0.0/16"
private_subnets    = ["172.32.0.0/20", "172.32.16.0/20", "172.32.32.0/20"]
public_subnets     = ["172.32.50.0/24", "172.32.51.0/24", "172.32.52.0/24"]
enable_nat_gateway = true

#EKS
cluster_name                             = "main"
cluster_version                          = "1.33"
cluster_endpoint_public_access           = true
enable_cluster_creator_admin_permissions = true
