# =============================================================================
# KMS Key for ECR Encryption
# =============================================================================
data "aws_iam_policy_document" "ecr_kms_key_policy" {
  # checkov:skip=CKV_AWS_111: "Root permissions are required for KMS key administration"
  # checkov:skip=CKV_AWS_356: "Policy attached to the key itself, resource * is required"
  # checkov:skip=CKV_AWS_109: "Key policy management requires these permissions"
  statement {
    sid    = "EnableIAMUserPermissions"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:${local.partition}:iam::${local.account_id}:root"
      ]
    }

    actions   = ["kms:*"]
    resources = ["*"]
  }
}

# -----------------------------------------------------------------------------
# Customer-Managed KMS Key for ECR
# -----------------------------------------------------------------------------
resource "aws_kms_key" "ecr" {
  count = (var.kms_key_arn == null && var.enable_encryption && var.create_kms_key) ? 1 : 0

  description             = "KMS key for ECR repository ${local.repository_name} encryption"
  deletion_window_in_days = var.kms_deletion_window_in_days
  enable_key_rotation     = true
  multi_region            = var.enable_multi_region

  policy = data.aws_iam_policy_document.ecr_kms_key_policy.json


  tags = merge(
    local.common_tags,
    {
      Name = "${local.repository_name}-ecr-kms-key"
    }
  )
}

resource "aws_kms_alias" "ecr" {
  count = (var.kms_key_arn == null && var.enable_encryption && var.create_kms_key) ? 1 : 0

  name          = "alias/${replace(local.repository_name, "/", "-")}-ecr"
  target_key_id = aws_kms_key.ecr[0].key_id
}
