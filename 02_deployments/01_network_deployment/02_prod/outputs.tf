# outputs.tf
output "vpc_id" {
  description = "ID of the development VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the development VPC"
  value       = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  description = "Map of public subnet IDs per AZ"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "Map of private subnet IDs per AZ"
  value       = module.vpc.private_subnets
}

output "isolated_subnet_ids" {
  description = "Map of isolated subnet IDs per AZ (if enabled)"
  value       = module.vpc.isolated_subnets
}

output "nat_gateway_ips" {
  description = "Map of NAT Gateway public IPs"
  value       = module.vpc.nat_public_ips
}

output "availability_zones" {
  description = "List of AZs used in the VPC"
  value       = keys(module.vpc.public_subnets)
}
/*
output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.vpc.aws_internet_gateway.default.id
}*/