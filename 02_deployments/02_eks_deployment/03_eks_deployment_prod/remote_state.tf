data "terraform_remote_state" "vpc" {
  backend = "s3" # Update with your backend config

  config = {
    bucket = "ma3-terraform-state-backend-acg"
    key    = "state-file/networking-prod/terraform.tfstate"
    region = "us-east-1"
  }
}
