# creating S3 bucket and Dynamo DB Table

# Create S3 Bucket and DynamoDB table to store state and state lock.
resource "aws_s3_bucket" "bucket" {
  bucket = "ma3-terraform-state-backend-acg18"


  #object_lock_enabled = false

  tags = {
    Name = "S3 Remote Terraform State Store"
  }
}

resource "aws_dynamodb_table" "terraform-lock" {
  name           = "lock_state_table_acg"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    "Name" = "DynamoDB Terraform State Lock Table"
  }
}