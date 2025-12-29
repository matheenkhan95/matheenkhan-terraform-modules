provider "aws" {
  region = var.region
}

# Fetch EKS Cluster Details
data "aws_eks_cluster" "eks" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = var.cluster_name
}


# Kubernetes Provider with Alias (used for Helm operations)
provider "kubernetes" {
  alias                  = "eks"
  host                   = data.aws_eks_cluster.eks.endpoint
  token                  = data.aws_eks_cluster_auth.eks.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.eks.endpoint
    token                  = data.aws_eks_cluster_auth.eks.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  }
} 

terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
}

# Fetch OIDC Provider for IAM Role
data "aws_iam_openid_connect_provider" "eks" {
  arn = var.oidc_provider_arn
}

# IAM Trust Policy
data "aws_iam_policy_document" "aws_lbc" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.eks.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.lbc_name}"]
    }
  }
}

# IAM Role
resource "aws_iam_role" "aws_lbc" {
  name               = "${var.cluster_name}-aws-lbc"
  assume_role_policy = data.aws_iam_policy_document.aws_lbc.json
}

# IAM Policy (external JSON file)
resource "aws_iam_policy" "aws_lbc" {
  name   = var.iam_policy_name
  policy = file(var.iam_policy_json_path)
}

# Attach IAM policy to IAM role
resource "aws_iam_role_policy_attachment" "aws_lbc" {
  policy_arn = aws_iam_policy.aws_lbc.arn
  role       = aws_iam_role.aws_lbc.name
}

# Kubernetes Service Account
resource "kubernetes_service_account" "aws_lbc" {
  provider = kubernetes.eks  # <-- Important: Use the alias
  metadata {
    name      = var.lbc_name
    namespace = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.aws_lbc.arn
    }
  }
}

# AWS Load Balancer Controller Helm Release
resource "helm_release" "aws_lbc" {
  name       = var.lbc_name
  provider   = helm
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = var.namespace
  version    = var.aws_lbc_helm_chart_version

  set = [
  {
    name  = "clusterName"
    value = var.cluster_name
  },
  {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.aws_lbc.metadata[0].name
  },
  {
    name  = "serviceAccount.create"
    value = "false"
  },
  {
    name  = "region"
    value = var.region
  },
  {
    name  = "vpcId"
    value = var.vpc_id
  }
]

  depends_on = [aws_iam_role_policy_attachment.aws_lbc]
}
