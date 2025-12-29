# Isolated Subnets (optional)
resource "aws_subnet" "isolated-subnet" {
   for_each = var.enable_isolated ? local.az_subnets : {}

  vpc_id            = aws_vpc.default.id
  cidr_block        = each.value.isolated_cidr_block
  availability_zone = each.key

  tags = {

    Name        = "${var.vpc_name}-isolated-subnet-${each.key}"
    environment = "${var.environment}"
  }
}