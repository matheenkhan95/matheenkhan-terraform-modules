resource "aws_security_group" "allow_all" {
  name        = "${var.cluster_name}-cluster-sg-${var.environment}-all"
  description = "EKS cluster security group"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name        = "${var.cluster_name}-cluster-sg"
      Component   = "security-group"
      Environment = var.environment
    }
  )
}

# Allow ALL inbound traffic
resource "aws_security_group_rule" "allow_all_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = var.whitelist_public_ips
  security_group_id = aws_security_group.allow_all.id
}

# Allow ALL outbound traffic
resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = var.whitelist_public_ips
  security_group_id = aws_security_group.allow_all.id
}