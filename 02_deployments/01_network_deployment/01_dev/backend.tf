terraform {
  backend "s3" {
    bucket         = "ma3-terraform-state-backend-acg"
    key            = "state-file/networking-dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "lock_state_table_acg"
  }
}