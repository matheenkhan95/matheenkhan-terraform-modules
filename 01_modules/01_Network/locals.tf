locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count) # fetching the Avalaibity Zones

 # Generate a map of AZs with their subnet CIDR blocks
  az_subnets = {
    for idx, az in local.azs : az => {
      public_cidr_block   =  cidrsubnet(var.vpc_cidr, 8, idx * 1 + 0)
      private_cidr_block  =  cidrsubnet(var.vpc_cidr, 8, idx * 1 + 10)
      isolated_cidr_block = var.enable_isolated ? cidrsubnet(var.vpc_cidr, 8, idx * 1 + 20) : null
    }
  }
  # 3 base defination
  # NAT Gateway configuration (map of AZs or single entry)
  nat_gateway_azs = var.enable_nat_per_az ? local.azs : [local.azs[0]] 

}