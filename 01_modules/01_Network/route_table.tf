resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name        = "${var.vpc_name}-Public-RT"
    environment = "${var.environment}"

  }
}


resource "aws_route_table" "private-route-table" {

  for_each = toset(local.nat_gateway_azs)
  vpc_id = aws_vpc.default.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[each.key].id
  }

  tags = {
    Name        = "${var.vpc_name}-private-RT-${each.key}"
    environment = "${var.environment}"

  }
}

# **Isolated Route Table (NO INTERNET ACCESS)**
resource "aws_route_table" "isolated-route-table" {
  for_each = var.enable_isolated ? local.az_subnets : {}
  vpc_id = aws_vpc.default.id

  tags = {
    Name        = "${var.vpc_name}-isolated-RT-${each.key}"
    environment = "${var.environment}"

  }
}



resource "aws_route_table_association" "public-subnets" {

  for_each = local.az_subnets
  subnet_id      = aws_subnet.public-subnet[each.key].id
  route_table_id = aws_route_table.public-route-table.id
}


resource "aws_route_table_association" "private-subnets" {

  for_each = local.az_subnets
  subnet_id      = aws_subnet.private-subnet[each.key].id
  route_table_id = var.enable_nat_per_az ? aws_route_table.private-route-table[each.key].id : aws_route_table.private-route-table[local.nat_gateway_azs[0]].id
}

resource "aws_route_table_association" "isolated-subnets" {
  for_each = var.enable_isolated ? local.az_subnets : {}
  subnet_id      = aws_subnet.isolated-subnet[each.key].id
  route_table_id = aws_route_table.isolated-route-table[each.key].id
}


