variable "cluster_name" {
  type = string
}

variable "environment" {
  type = string
}
variable "eks_version" {
  type = string
}
variable "multi_az" {
  type    = bool
  default = true
}

variable "enable_gpu" {
  type    = bool
  default = false
}

variable "enable_general" {
   type    = bool
}

variable "whitelist_public_ips" {
  type    = list(string)
  default = []
}
variable "tags" {
 type = map(string) 
}

variable "general_node_group_name" {
  description = "Name for the general node group"
  type        = string
  default     = "general"
}

variable "general_node_group_instance_types" {
  description = "Instance types for the general node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "general_node_group_min_size" {
  description = "Minimum number of nodes in the general node group"
  type        = number
  default     = 1
}

variable "general_node_group_max_size" {
  description = "Maximum number of nodes in the general node group"
  type        = number
  default     = 3
}

variable "general_node_group_desired_size" {
  description = "Desired number of nodes in the general node group"
  type        = number
  default     = 2
}

variable "gpu_node_group_name" {
  description = "Name for the GPU node group"
  type        = string
  default     = "gpu"
}

variable "gpu_node_group_instance_types" {
  description = "Instance types for the GPU node group"
  type        = list(string)
  default     = ["p3.2xlarge"]
}

variable "gpu_node_group_min_size" {
  description = "Minimum number of nodes in the GPU node group"
  type        = number
  default     = 0
}

variable "gpu_node_group_max_size" {
  description = "Maximum number of nodes in the GPU node group"
  type        = number
  default     = 2
}

variable "gpu_node_group_desired_size" {
  description = "Desired number of nodes in the GPU node group"
  type        = number
  default     = 0
}

variable "gpu_node_group_taints" {
  description = "List of taints to apply to the GPU node group"
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
  default = [
    {
      key    = "nvidia.com/gpu"
      value  = "present"
      effect = "NoSchedule"
    }
  ]
}