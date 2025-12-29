data "terraform_remote_state" "vpc" {
  backend = "s3" # Update with your backend config

  config = {
    bucket = "ma3-terraform-state-backend-acg"
    key    = "state-file/networking-dev/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_eks_cluster" "main" {
  name     = "${var.cluster_name}-${var.environment}"
  role_arn = aws_iam_role.cluster.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids              = local.private_subnets
    endpoint_public_access  = true
    endpoint_private_access = true
    public_access_cidrs     = var.whitelist_public_ips
    security_group_ids      = [aws_security_group.eks_cluster.id,aws_security_group.eks_nodes.id] # Associate security group for the cluster
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy,
    aws_iam_role_policy_attachment.cluster_ecr_policy,
    aws_iam_role_policy_attachment.cluster_logging_policy
  ]
}
