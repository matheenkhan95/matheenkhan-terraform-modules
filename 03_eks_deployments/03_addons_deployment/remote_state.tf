data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket = "ma3-terraform-state-backend-acg18"
    key    = "state-file/eks-dev-ngbased/terraform.tfstate"
    region = "us-east-1"
  }
}