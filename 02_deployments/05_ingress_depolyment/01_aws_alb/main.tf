terraform {
  required_version = ">= 1.10.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.7.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.22.0"
    }
  }
}

 
provider "aws" {
  region = "us-east-1"
}


data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}


module "aws_lbc" {
  source = "../../../01_modules/05_ingress_controller/01_aws_alb"

  region                     = "us-east-1"
  cluster_name                = data.terraform_remote_state.eks.outputs.cluster_name
  vpc_id                      = data.terraform_remote_state.vpc.outputs.vpc_id
  oidc_provider_arn           = "arn:aws:iam::536631738691:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/9EEB58F4B631AB6F1D98241E900F3A3F"
  iam_policy_json_path        = "E:/10_cka_tasks/12_vpc_deployment_locals_for/01_modules/00_iam_json/iam_policy.json"
  iam_policy_name             = "AWSLoadBalancerControllerPolicy"
  namespace                   = "kube-system"
  lbc_name                    = "aws-load-balancer-controller"
  aws_lbc_helm_chart_version  = "1.8.1"
}