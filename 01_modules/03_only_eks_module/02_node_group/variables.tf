variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "node_groups" {
  description = "Map of node groups and their properties"
  type = map(object({
    instance_type    = string
    desired_capacity = number
    max_capacity     = number
    min_capacity     = number
    node_subnet_ids  = list(string)
    taints           = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), []) # Default to an empty list if no taints are provided
  }))
}


variable "private_subnets" {
  description = "List of private subnet IDs from the VPC"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet IDs from the VPC (if needed)"
  type        = list(string)
}

variable "ec2_key_name" {
  description = "EC2 key pair name for SSH access to node instances"
  type        = string
}

variable "whitelist_public_ips" {
  type    = list(string)
  default = []
}

variable "tags" {
 type = map(string) 
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}