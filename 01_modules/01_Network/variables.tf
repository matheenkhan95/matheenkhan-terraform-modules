variable "vpc_cidr" { type = string }
variable "vpc_name" { type = string }
variable "environment" { type = string }
variable "az_count" { type = string }
variable "enable_isolated" { type = bool }
variable "enable_nat_per_az" { type = bool }
# Define a default_tags variable for the VPC module
variable "is_kubernetes" {
  description = "Flag to indicate if the subnet is for Kubernetes purposes"
  type        = bool
  default     = false  # Set this to true for Kubernetes-specific configurations
}

variable "default_tags" {
  type        = map(string)
  description = "A map of default tags to be applied to all resources"
  default     = {}
}

