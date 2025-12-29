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

  vpc_cidr          = "10.0.0.0/16"
  vpc_name          = "dev_vpc"
  environment       = "development"
  az_count          = 2
  enable_nat_per_az = false # No NAT in Dev
  enable_isolated   = true

}