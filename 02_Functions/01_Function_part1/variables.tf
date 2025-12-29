variable "aws_region" {}
variable "vpc_cidr" {}
variable "vpc_name" {}
variable "key_name" {}
#variable "azs" {}
#variable "public_cird_block" {}
#variable "private_cird_block" {}
variable "environment" {}
variable "ingress_value" {}
variable "amis" { type = map(string) }
variable "public_subnets" {
  type = map(string)
}

variable "private_subnets" {
  type = map(string)
}

variable "non_prod_subnet_count" {

}
