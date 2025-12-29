# security_groups.tf
resource "aws_security_group" "eks_cluster" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "EKS cluster security group"
  vpc_id      = local.vpc_id

  tags = merge(
    var.tags,
    {
      Name        = "${var.cluster_name}-cluster-sg"
      Component   = "security-group"
      Environment = var.environment
    }
  )
}

resource "aws_security_group" "eks_nodes" {
  name        = "${var.cluster_name}-node-sg"
  description = "EKS node security group"
  vpc_id      = local.vpc_id

  tags = merge(
    var.tags,
    {
      Name        = "${var.cluster_name}-node-sg"
      Component   = "security-group"
      Environment = var.environment
    }
  )
}

# Cluster Security Group Rules:Allow cluster egress to VPC

resource "aws_security_group_rule" "cluster_egress_internal" {
  description       = "Allow cluster egress to VPC"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  security_group_id = aws_security_group.eks_cluster.id
}

# Allow cluster to access external services (e.g., AWS API, Docker Hub)

resource "aws_security_group_rule" "cluster_egress_https" {
  description       = "Allow cluster outbound HTTPS"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks_cluster.id
}

# Allow API access to the cluster from whitelisted IPs

resource "aws_security_group_rule" "cluster_api_ingress" {
  description       = "Allow API access from whitelisted IPs"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.whitelist_public_ips
  security_group_id = aws_security_group.eks_cluster.id
}
/*
# Node Security Group Rules
resource "aws_security_group_rule" "nodes_egress" {
  description       = "Allow node egress"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks_nodes.id
}
*/
# Allow cluster to communicate with nodes on ephemeral ports (1025-65535)

resource "aws_security_group_rule" "cluster_node_ingress" {
  description              = "Allow cluster to communicate with nodes"
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_cluster.id
}

# Allow nodes to communicate with cluster API server

resource "aws_security_group_rule" "node_cluster_ingress" {
  description              = "Allow nodes to communicate with cluster"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
}

# Allow nodes to communicate with each other (for networking, daemonsets)

resource "aws_security_group_rule" "node_internal_communication" {
  description              = "Allow node-to-node communication"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_nodes.id
}