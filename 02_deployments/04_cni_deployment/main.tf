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

module "cni" {
  source        = "../../01_modules/05_addons_test"
  cluster_name  = data.terraform_remote_state.eks.outputs.cluster_name
  addon_name    = "vpc-cni"
  
  addon_version = "v1.19.2-eksbuild.1"
  resolve_conflicts = "OVERWRITE"           
 
  # IRSA Configuration
  create_iam_role          = true
  service_account_name     = "aws-node"
  service_account_namespace = "kube-system"
  iam_policy_arns          = ["arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"]

  # Custom ENI/IP settings
  configuration_values = {
    env = {
      ENABLE_POD_ENI = "true"
      WARM_IP_TARGET = "5"
    }
  }

  tags = { Name = "eks-vpc-cni", Env = "production" }
}

