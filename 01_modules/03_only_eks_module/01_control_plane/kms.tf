# Create the KMS Key
resource "aws_kms_key" "eks" {
  description             = "KMS key for EKS envelope encryption"
  enable_key_rotation     = true # Enable automatic key rotation
  deletion_window_in_days = 30

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "Enable IAM User Permissions"
        Effect    = "Allow"
        Principal = { "AWS" = var.admin_arn } # Replace with your admin ARN
        Action    = "kms:*"
        Resource  = "*"
      },
      {
        Sid    = "Allow EKS to Use Key"
        Effect = "Allow"
        Principal = {
          "Service" = "eks.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKeyWithoutPlaintext"

        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_alias" "eks" {
  name          = "alias/eks-cluster-key"
  target_key_id = aws_kms_key.eks.id
}
