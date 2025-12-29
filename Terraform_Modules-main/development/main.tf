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

terraform {
  backend "s3" {
    bucket         = "ma3-terraform-state-backend-acg-khans"
    key            = "state-file/eks-dev-ngbased/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "lock_state_table_acg"
  }
}
