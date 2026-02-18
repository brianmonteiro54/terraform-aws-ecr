# =============================================================================
# Local Variables
# =============================================================================

locals {

  # Account ID for cross-account access
  account_id = data.aws_caller_identity.current.account_id

  # Region
  region = data.aws_region.current.region

  partition = data.aws_partition.current.partition

  # Merge default tags with custom tags
  common_tags = merge(
    {
      Module      = "terraform-aws-ecr"
      ManagedBy   = "Terraform"
      Environment = var.environment
    },
    var.tags
  )

  # Repository name with optional prefix
  repository_name = var.repository_name_prefix != "" ? "${var.repository_name_prefix}/${var.repository_name}" : var.repository_name

  # Encryption logic
  enable_encryption = var.enable_encryption || var.kms_key_arn != null

  # KMS key ARN to use
  kms_key_arn = local.enable_encryption ? (
    var.kms_key_arn != null ? var.kms_key_arn : (
      var.create_kms_key ? aws_kms_key.ecr[0].arn : null
    )
  ) : null


}
