output "vpc_name" {
  value = var.vpc_name
}

output "environment" {
  value = var.environment
}

output "vpc_id" {
  value = aws_vpc.default.id
}

output "vpc_cidr" {

  value = aws_vpc.default.cidr_block
}

# Public Subnets (Map of AZ -> Subnet ID)
output "public_subnets" {
  value = { for az, subnet in aws_subnet.public-subnet : az => subnet.id }
}

# Correct the private subnet output
output "private_subnets" {
  value = { for az, subnet in aws_subnet.private-subnet : az => subnet.id }  # Use splat operator to get a list of private subnet IDs
}

# Isolated subnets output, check if isolated subnets are enabled


output "isolated_subnets" {
  value = var.enable_isolated ? { for az, subnet in aws_subnet.isolated-subnet : az => subnet.id } : {}
}

# NAT public IPs output, use splat operator to get public IPs of all NAT gateways

output "nat_public_ips" {
  value = { for az, nat in aws_nat_gateway.nat : az => aws_eip.nat[az].public_ip }
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public-route-table.id
}

output "private_route_table_ids" {
  description = "Map of private route table IDs keyed by AZ"
  value       = { for az, rt in aws_route_table.private-route-table : az => rt.id }
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.default.id
}
