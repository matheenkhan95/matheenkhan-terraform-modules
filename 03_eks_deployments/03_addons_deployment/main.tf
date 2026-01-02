terraform {
  required_version = ">= 1.10.4" # Specifies that Terraform version must be 1.10.4 or newer

  required_providers {
    aws = {
      source  = "hashicorp/aws" # Defines the source of the AWS provider
      version = "~> 5.0"        # Specifies the version constraint for AWS provider
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
/*
module "cni" {
  source            = "../../01_modules/04_cni_modules"
  cluster_name      = data.terraform_remote_state.eks.outputs.cluster_name
  addon_name        = "vpc-cni"
  auto_version      = false
  addon_version     = "v1.19.2-eksbuild.1"
  resolve_conflicts = "OVERWRITE"

  # REMOVE: No need for a custom IAM role
  use_custom_iam    = false
  iam_policy_arn    = null  # This should be removed or set to null

  config_values = jsonencode({
    env = {
      ENABLE_POD_ENI = "true"
      WARM_IP_TARGET = "5"
    }
  })

  tags = { Name = "eks-vpc-cni", Env = "production" }
}

module "coredns" {
  source            = "../../01_modules/04_cni_modules"
  cluster_name      = data.terraform_remote_state.eks.outputs.cluster_name
  addon_name        = "coredns"
  auto_version      = false
  addon_version     = "v1.11.4-eksbuild.2"
  resolve_conflicts = "OVERWRITE"
  use_custom_iam    = false

  config_values = jsonencode({
    replicaCount = 3
    resources = {
      limits   = { cpu = "250m", memory = "256Mi" }
      requests = { cpu = "200m", memory = "200Mi" }
    }
  })

  tags = { Name = "eks-coredns", Env = "production" }
}

module "kube-proxy" {
  source            = "../../01_modules/04_cni_modules"
  cluster_name      = data.terraform_remote_state.eks.outputs.cluster_name
  addon_name        = "kube-proxy"
  auto_version      = true
  resolve_conflicts = "OVERWRITE"
  use_custom_iam    = false

  tags = { Name = "eks-kube-proxy", Env = "production" }
}
*/
/*
module "cni" {
  source            = "../../01_modules/04_cni_modules"
  cluster_name      = data.terraform_remote_state.eks.outputs.cluster_name
  addon_name        = "vpc-cni"
  auto_version      = false
  addon_version     = "v1.19.2-eksbuild.1"
  resolve_conflicts = "OVERWRITE"

  use_custom_iam = false  # Use node group's IAM role
  iam_policy_arn = null   # No custom IAM role needed

  # REMOVE custom config to use default settings

  tags = { Name = "eks-vpc-cni", Env = "production" }
}

module "coredns" {
  source            = "../../01_modules/04_cni_modules"
  cluster_name      = data.terraform_remote_state.eks.outputs.cluster_name
  addon_name        = "coredns"
  auto_version      = false
  addon_version     = "v1.11.4-eksbuild.2"
  resolve_conflicts = "OVERWRITE"
  use_custom_iam    = false

  # REMOVE custom config to use default CoreDNS settings

  tags = { Name = "eks-coredns", Env = "production" }
}

module "kube-proxy" {
  source            = "../../01_modules/04_cni_modules"
  cluster_name      = data.terraform_remote_state.eks.outputs.cluster_name
  addon_name        = "kube-proxy"
  auto_version      = true
  resolve_conflicts = "OVERWRITE"
  use_custom_iam    = false

  tags = { Name = "eks-kube-proxy", Env = "production" }
}
*/
#  VPC CNI 
/*
module "cni" {
  source            = "../../01_modules/04_addons_modules"
  cluster_name      = data.terraform_remote_state.eks.outputs.cluster_name
  addon_name        = "vpc-cni"
  auto_version      = false
  addon_version     = "v1.19.2-eksbuild.1"
  resolve_conflicts = "OVERWRITE"
  use_custom_iam    = false
  #Network policies kind of SG's
  config_values = jsonencode({
    env = {
      ENABLE_POD_ENI = "true"
      WARM_IP_TARGET = "5"
    }
  })

  tags = { Name = "eks-vpc-cni", Env = "production" }
}
*/
module "cni" {
  source            = "../../01_modules/04_addons_modules"
  cluster_name      = data.terraform_remote_state.eks.outputs.cluster_name
  addon_name        = "vpc-cni"
  auto_version      = false
  addon_version     = "v1.19.2-eksbuild.1"
  resolve_conflicts = "OVERWRITE"
  use_custom_iam    = false

  # Pass both the top-level enableNetworkPolicy and your existing env vars
  config_values = jsonencode({
    enableNetworkPolicy = "true"          # <— enable native NetworkPolicy support
    env = {
      ENABLE_POD_ENI       = "true"
      WARM_IP_TARGET       = "5"
      # any other AWS_* CNI vars you need…
    }
  })

  tags = {
    Name = "eks-vpc-cni"
    Env  = "production"
  }
}

#CoreDNS 
module "coredns" {
  source            = "../../01_modules/04_addons_modules"
  cluster_name      = data.terraform_remote_state.eks.outputs.cluster_name
  addon_name        = "coredns"
  auto_version      = false
  addon_version     = "v1.11.4-eksbuild.2"
  resolve_conflicts = "OVERWRITE"
  use_custom_iam    = false

  config_values = jsonencode({
    replicaCount = 1
    resources = {
      limits   = { cpu = "250m", memory = "256Mi" }
      requests = { cpu = "200m", memory = "200Mi" }
    }
    affinity = {
      podAntiAffinity = {
        requiredDuringSchedulingIgnoredDuringExecution = [
          {
            labelSelector = {
              matchExpressions = [{ key = "k8s-app", operator = "In", values = ["kube-dns"] }]
            }
            topologyKey = "kubernetes.io/hostname"
          }
        ]
      }
    }
  })

  tags = { Name = "eks-coredns", Env = "production" }
}

# Kube Proxy 
module "kube-proxy" {
  source            = "../../01_modules/04_addons_modules"
  cluster_name      = data.terraform_remote_state.eks.outputs.cluster_name
  addon_name        = "kube-proxy"
  auto_version      = true
  resolve_conflicts = "OVERWRITE"
  use_custom_iam    = false

  tags = { Name = "eks-kube-proxy", Env = "production" }
}

#  EBS CSI Driver 
module "ebs_csi_driver" {
  source            = "../../01_modules/04_addons_modules"
  cluster_name      = data.terraform_remote_state.eks.outputs.cluster_name
  addon_name        = "aws-ebs-csi-driver"
  auto_version      = false
  addon_version     = "v1.40.1-eksbuild.1"  
  resolve_conflicts = "OVERWRITE"
  use_custom_iam    = false  

  tags = { Name = "eks-ebs-csi-driver", Env = "production" }
}




# Metrics Server

module "metrics_server" {
  source            = "../../01_modules/04_addons_modules"
  cluster_name      = data.terraform_remote_state.eks.outputs.cluster_name
  addon_name        = "metrics-server"
  auto_version      = true
  resolve_conflicts = "OVERWRITE"
  use_custom_iam    = false

  tags = { Name = "eks-metrics-server", Env = "production" }
}