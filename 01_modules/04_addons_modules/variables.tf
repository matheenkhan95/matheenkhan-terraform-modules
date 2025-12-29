variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "addon_name" {
  description = "Name of the EKS add-on"
  type        = string
}

variable "addon_version" {
  description = "Version of the EKS add-on"
  type        = string
  default     = null
}

variable "auto_version" {
  description = "Automatically use the latest version"
  type        = bool
  default     = true
}

variable "resolve_conflicts" {
  description = "Conflict resolution strategy"
  type        = string
  default     = "OVERWRITE"
}

variable "config_values" {
  description = "Fine-tuned configuration JSON for the add-on"
  type        = string
  default     = "{}"
}

variable "use_custom_iam" {
  description = "Attach a custom IAM role for the add-on"
  type        = bool
  default     = false
}

variable "iam_policy_arn" {
  description = "IAM policy to attach if using a custom IAM role"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
