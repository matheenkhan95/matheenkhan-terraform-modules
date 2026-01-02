terraform {
  backend "s3" {
    bucket         = "ma3-terraform-state-backend-acg18"
    key            = "state-file/eks/node-groups/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
