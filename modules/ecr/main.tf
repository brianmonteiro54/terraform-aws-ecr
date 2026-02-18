# =============================================================================
# AWS ECR Repository Module - Production Ready with Security Best Practices
# =============================================================================
# This file contains ONLY the main ECR repository resource

# -----------------------------------------------------------------------------
# ECR Repository
# -----------------------------------------------------------------------------
resource "aws_ecr_repository" "this" {
  name                 = local.repository_name
  image_tag_mutability = var.image_tag_mutability

  # Encryption Configuration
  encryption_configuration {
    encryption_type = local.enable_encryption ? "KMS" : "AES256"
    kms_key         = local.kms_key_arn
  }

  # Image Scanning
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  # Force Delete (use with caution)
  force_delete = var.force_delete

  tags = merge(
    local.common_tags,
    {
      Name = local.repository_name
    }
  )
}
