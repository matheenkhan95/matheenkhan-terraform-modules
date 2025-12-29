resource "aws_eks_cluster" "this" {
  name     = "${var.cluster_name}-${var.environment}"
  role_arn = aws_iam_role.cluster.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_public_access  = true # variable
    endpoint_private_access = true # variable
    public_access_cidrs     = var.whitelist_public_ips
    #security_group_ids      = [aws_security_group.eks_cluster.id,aws_security_group.eks_nodes.id] # Associate security group for the cluster
    security_group_ids      = [aws_security_group.allow_all.id]
  }

  encryption_config {
    resources = ["secrets"]  # Encrypt Kubernetes Secrets with KMS key
    provider {
      key_arn = aws_kms_key.eks.arn  # Reference the KMS key ARN
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy,
    aws_iam_role_policy_attachment.cluster_ecr_policy,
    aws_iam_role_policy_attachment.cluster_logging_policy
  ]

  # Optionally enable logging, specify Kubernetes version, etc.
}
