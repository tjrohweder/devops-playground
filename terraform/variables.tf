#General
variable "env" {}

#VPC
variable "vpc_name" {}
variable "vpc_cidr" {}
variable "private_subnets" {
  type = list()
}
variable "public_subnets" {
  type = list()
}
