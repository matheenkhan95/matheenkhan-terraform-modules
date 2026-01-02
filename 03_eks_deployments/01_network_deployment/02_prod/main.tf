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

module "vpc" {

  source = "../../../01_modules/01_Network"

  vpc_cidr          = "10.1.0.0/16"
  vpc_name          = "prod_vpc"
  environment       = "production"
  az_count          = 3 
  enable_nat_per_az = true # No NAT in Dev
  enable_isolated   = true
  # Optionally, pass Kubernetes flag (true/false)
  is_kubernetes = true  # If you are deploying Kubernetes resources

}