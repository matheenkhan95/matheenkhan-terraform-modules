resource "aws_iam_role" "this" {
  count = var.use_custom_iam ? 1 : 0
  name  = "${var.cluster_name}-${var.addon_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = var.use_custom_iam ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = var.iam_policy_arn
}