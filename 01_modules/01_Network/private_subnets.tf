resource "aws_subnet" "private-subnet" {

  for_each = local.az_subnets

  vpc_id                  = aws_vpc.default.id
  cidr_block              = each.value.private_cidr_block
  availability_zone       = each.key


  tags = merge(
    var.default_tags,  # Apply the default tags
    {
      Name = "${var.vpc_name}-private-subnet-${each.key}"
      environment = "${var.environment}"
    },
    var.is_kubernetes == true ? {
      "kubernetes.io/role/internal-elb" = "1"  # If Kubernetes, add this tag for internal ELBs
    } : {}  # Empty map if not used for Kubernetes
  )
}

