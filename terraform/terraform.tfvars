#General
env = "dev"

#VPC
vpc_name = "main"
vpc_cidr = "172.32.0.0/16"
private_subnets = ["172.32.0.0/20", "172.32.16.0/20", "172.32.32.0/20"]
public_subnets = ["172.32.40.0/24", "172.32.41.0/24", "172.32.42.0/24"]
