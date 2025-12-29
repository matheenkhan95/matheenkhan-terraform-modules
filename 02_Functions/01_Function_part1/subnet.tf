/*resource "aws_subnet" "public-subnet" {
  #count             = 3
  count             = length(var.public_cird_block)
  vpc_id            = aws_vpc.default.id
  cidr_block        = element(var.public_cird_block, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name        = "${var.vpc_name}-public-subnet-${count.index + 1}"
    Owner       = local.Owner
    costcenter  = local.costcenter
    TeamDL      = local.TeamDL
    environment = "${var.environment}"

  }
}

resource "aws_subnet" "private-subnet" {
  #   count             = 3
  count             = length(var.private_cird_block)
  vpc_id            = aws_vpc.default.id
  cidr_block        = element(var.private_cird_block, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name        = "${var.vpc_name}-private-subnet-${count.index + 1}"
    Owner       = local.Owner
    costcenter  = local.costcenter
    TeamDL      = local.TeamDL
    environment = "${var.environment}"

  }
}
*/

resource "aws_subnet" "public-subnet" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.default.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true


  tags = {
    Name        = "${var.vpc_name}-public-subnet-${each.key}"
    Owner       = local.Owner
    costcenter  = local.costcenter
    TeamDL      = local.TeamDL
    environment = "${var.environment}"

  }
}

resource "aws_subnet" "private-subnet" {
  #   count             = 3
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.default.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = {
    Name        = "${var.vpc_name}-private-subnet-${each.key}"
    Owner       = local.Owner
    costcenter  = local.costcenter
    TeamDL      = local.TeamDL
    environment = "${var.environment}"

  }
}
