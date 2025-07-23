#General
variable "env" {}

#VPC
variable "vpc_name" {}
variable "vpc_cidr" {}
variable "private_subnets" {}
variable "public_subnets" {}

#EKS
variable "cluster_name" {}
variable "cluster_version" {}
variable "cluster_endpoint_public_access" {
  type = bool
}
variable "enable_cluster_creator_admin_permissions" {
  type = bool
}
