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
  source               = "../../../../01_modules/03_only_eks_module/01_control_plane"
  cluster_name         = "my-eks-cluster"
  vpc_id               = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids           = values(data.terraform_remote_state.vpc.outputs.private_subnet_ids)
  vpc_cidr_range       = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  whitelist_public_ips = ["0.0.0.0/0"]
  environment          = "development"
  eks_version          = 1.32
  tags = {
    Name        = "dev-cluster"
    Environment = "development"
  }
  admin_arn = "arn:aws:iam::536631738691:user/cloud_user"
}

