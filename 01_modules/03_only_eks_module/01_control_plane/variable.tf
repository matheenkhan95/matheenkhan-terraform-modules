variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster (typically private subnets)"
  type        = list(string)
}

variable "whitelist_public_ips" {
  type    = list(string)
  default = []
}

variable "environment" {
  type = string
}
variable "eks_version" {
  type = string
}

variable "vpc_cidr_range" {
  
}

variable "tags" {
 type = map(string) 
}

variable "admin_arn" {
  description = "The ARN of the admin user or role for KMS key permissions"
  type        = string
}
