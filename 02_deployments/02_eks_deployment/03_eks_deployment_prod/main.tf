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



module "eks_control_plane" {
  source               = "../../01_modules/03_only_eks_module/01_control_plane"
  cluster_name         = "my-eks-cluster"
  vpc_id               = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids           = values(data.terraform_remote_state.vpc.outputs.private_subnet_ids)
  vpc_cidr_range       = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  whitelist_public_ips = ["0.0.0.0/0"]
  environment          = "production"
  eks_version          = 1.32
  tags = {
    Name        = "dev-cluster"
    Environment = "production"
  }
}

module "eks_node_groups" {
  source = "../../01_modules/03_only_eks_module/02_node_group"

  cluster_name    = module.eks_control_plane.cluster_name
  private_subnets = values(data.terraform_remote_state.vpc.outputs.private_subnet_ids)
  public_subnets  = values(data.terraform_remote_state.vpc.outputs.public_subnet_ids)
  ec2_key_name    = "Kubernetes_Instance_kp1"

  # Define your node groups here.
  # For each node group:
  # - An empty "azs" list means the node group spans all private subnets (multi-AZ).
  # - Providing a specific subnet list restricts the node group to that AZ.
  #
  # In this example, we define:
  #   • "general" and "gpu" that span all private subnets (Scenario 1: Multi-AZ)
  #   • "inferentia" that is restricted to a single AZ
  #   • "general-az1" and "gpu-az1" to demonstrate two node groups in the same AZ (Scenario 2: Multiple per AZ)
  node_groups = {
    "general" = {
      instance_type    = "t3.medium"
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      node_subnet_ids  = [] # Multi-AZ: uses all private subnets
    },
    "gpu" = {
      instance_type    = "p3.2xlarge"
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1
      node_subnet_ids  = [] # Multi-AZ: uses all private subnets
    },
    "inferentia" = {
      instance_type    = "inf1.xlarge"
      desired_capacity = 1
      max_capacity     = 1
      min_capacity     = 1
      # Restrict this node group to a single AZ by providing one subnet (e.g. first private subnet)
      node_subnet_ids = [element(values(data.terraform_remote_state.vpc.outputs.private_subnet_ids), 1)]
    },
    "general-az1" = {
      instance_type    = "t3.medium"
      desired_capacity = 1
      max_capacity     = 1
      min_capacity     = 1
      # Deploy this node group in the same AZ as above (using first private subnet)
      node_subnet_ids = [element(values(data.terraform_remote_state.vpc.outputs.private_subnet_ids), 2)]
    },
    "gpu-az1" = {
      instance_type    = "p3.2xlarge"
      desired_capacity = 1
      max_capacity     = 1
      min_capacity     = 1
      # Another node group in the same AZ (using first private subnet)
      node_subnet_ids = [element(values(data.terraform_remote_state.vpc.outputs.private_subnet_ids), 1)]
    }
  }
}
