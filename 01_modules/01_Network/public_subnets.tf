resource "aws_subnet" "public-subnet" {

  for_each = local.az_subnets

  vpc_id                  = aws_vpc.default.id
  cidr_block              = each.value.public_cidr_block
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = merge(
    var.default_tags, # Add the default tags
    {
      Name        = "${var.vpc_name}-public-subnet-${each.key}"
      environment = "${var.environment}"
    },
    var.is_kubernetes == true ? {
      "kubernetes.io/role/elb" = "1" # If Kubernetes, add this tag

    } : {} # Empty map if not used for Kubernetes
  )
}
