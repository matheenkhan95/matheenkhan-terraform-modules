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

module "eks_node_groups" {
  source = "../../../../01_modules/03_only_eks_module/02_node_group"

  cluster_name    = data.terraform_remote_state.eks.outputs.cluster_name
  private_subnets = values(data.terraform_remote_state.vpc.outputs.private_subnet_ids)
  public_subnets  = values(data.terraform_remote_state.vpc.outputs.public_subnet_ids)
  ec2_key_name    = "my-key-pair"
  whitelist_public_ips = ["0.0.0.0/0"]
  environment          = "development"
  vpc_id               = data.terraform_remote_state.vpc.outputs.vpc_id 
  tags = {
    Name        = "dev-cluster"
    Environment = "development"
  }
  
  node_groups = {
    "general" = {
      instance_type    = "t3.medium"
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      node_subnet_ids  = [] # Multi-AZ
    }/*,
    "gpu" = {
      instance_type    = "p3.2xlarge"
      desired_capacity = 1
      max_capacity     = 1
      min_capacity     = 1
      node_subnet_ids  = [] # Multi-AZ
      taints = [
        {
          key    = "workload-HA"
          value  = "gpu-intensive"
          effect = "NO_SCHEDULE" # Ensures only GPU workloads are scheduled here
        }
      ]
    },
    "inferentia" = {
      instance_type    = "inf1.xlarge"
      desired_capacity = 1
      max_capacity     = 1
      min_capacity     = 1
      node_subnet_ids = [element(values(data.terraform_remote_state.vpc.outputs.private_subnet_ids), 0)] # Single AZ
      taints = [
        {
          key    = "workload"
          value  = "inferentia"
          effect = "NO_SCHEDULE" # Ensures only Inferentia workloads are scheduled here
        }
      ]
    }
    "general-az1" = {
      instance_type    = "t3.medium"
      desired_capacity = 2
      max_capacity     = 2
      min_capacity     = 1
      node_subnet_ids = [data.terraform_remote_state.vpc.outputs.private_subnet_ids["us-east-1b"],
                        data.terraform_remote_state.vpc.outputs.private_subnet_ids["us-east-1c"]] # Single AZ
    },
    "general-az-one" = {
      instance_type    = "t3.medium"
      desired_capacity = 1
      max_capacity     = 1
      min_capacity     = 1
      node_subnet_ids = [element(values(data.terraform_remote_state.vpc.outputs.private_subnet_ids), 0)] # Single AZ
    }
    "gpu-az1" = {
      instance_type    = "p3.2xlarge"
      desired_capacity = 1
      max_capacity     = 1
      min_capacity     = 1
      node_subnet_ids = [element(values(data.terraform_remote_state.vpc.outputs.private_subnet_ids), 2)] # Single AZ
      taints = [
        {
          key    = "workload-single"
          value  = "gpu-intensive"
          effect = "NO_SCHEDULE" # Ensures only GPU workloads are scheduled here
        }
      ]
    }*/
  }
}