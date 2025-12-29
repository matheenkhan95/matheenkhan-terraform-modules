# Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
  
  for_each = toset(local.nat_gateway_azs)

  tags = {
    Name        = "${var.vpc_name}-EIP-${each.key}"
    environment = "${var.environment}"
  }
}

# NAT Gateway per AZ (if enabled)
resource "aws_nat_gateway" "nat" {
  for_each = toset(local.nat_gateway_azs)
  allocation_id = aws_eip.nat[each.key].id 
  subnet_id     = aws_subnet.public-subnet[each.key].id #aws_subnet.public-subnet[count.index].id

  tags = {
    Name        = "${var.vpc_name}-NAT-Gateway-${each.key}"
    environment = "${var.environment}"
  }
}
