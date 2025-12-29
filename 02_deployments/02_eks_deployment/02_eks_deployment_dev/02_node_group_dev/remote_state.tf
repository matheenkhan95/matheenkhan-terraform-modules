# Fetch VPC details from remote state
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "ma3-terraform-state-backend-acg18"
    key    = "state-file/networking-prod/terraform.tfstate"
    region = "us-east-1"
  }
}


# Fetch EKS control plane details from remote state
data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket = "ma3-terraform-state-backend-acg18"
    key    = "state-file/eks-dev-ngbased/terraform.tfstate"
    region = "us-east-1"
  }
}
