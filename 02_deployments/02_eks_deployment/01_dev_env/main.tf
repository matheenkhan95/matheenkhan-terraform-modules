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

module "eks" {
  source               = "../../01_modules/02_eks_modules"
  cluster_name         = "dev-cluster"
  environment          = "development"
  multi_az             = true
  enable_gpu           = false
  enable_general       = true
  whitelist_public_ips = ["0.0.0.0/0"]
  eks_version          = 1.32
  tags = {
    Name        = "dev-cluster"
    Environment = "development"
  }

  # Node Group configuration for the general node group
  general_node_group_name           = "general"
  general_node_group_instance_types = ["t3.medium"]
  general_node_group_min_size       = 1
  general_node_group_max_size       = 3
  general_node_group_desired_size   = 2
  /*
  # Node Group configuration for the GPU node group (only used if enable_gpu is true)
  gpu_node_group_name                = "gpu"
  gpu_node_group_instance_types       = ["p3.2xlarge"]
  gpu_node_group_min_size             = 0
  gpu_node_group_max_size             = 2
  gpu_node_group_desired_size         = 0
  gpu_node_group_taints = [
    {
      key    = "gpu"
      value  = "present"
      effect = "NoSchedule"
    }
  ]
*/
}

