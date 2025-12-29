resource "aws_route_table_association" "public-subnets" {
  #   count          = 3
  for_each       = aws_subnet.public-subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public-route-table.id
}


resource "aws_route_table_association" "private-subnets" {
  #   count          = 3
  for_each = aws_subnet.private-subnet
  #subnet_id      = element(aws_subnet.private-subnet[*].id, count.index)
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private-route-table.id
}
