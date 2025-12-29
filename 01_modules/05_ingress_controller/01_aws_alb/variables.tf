

variable "region" {
  description = "AWS region to deploy to"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace to deploy to"
  type        = string
  default     = "kube-system"
}

variable "lbc_name" {
  description = "Service account and helm release name for Load Balancer Controller"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "aws_lbc_helm_chart_version" {
  description = "Version of the AWS Load Balancer Controller helm chart"
  type        = string
  default     = "1.8.1"
}

variable "vpc_id" {
  description = "VPC ID where the Load Balancer Controller should operate"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the IAM OIDC provider for EKS"
  type        = string
}

variable "iam_policy_json_path" {
  description = "Path to the IAM policy JSON file"
  type        = string
}

variable "iam_policy_name" {
  description = "Name for the IAM policy"
  type        = string
  default     = "AWSLoadBalancerControllerPolicy"
}