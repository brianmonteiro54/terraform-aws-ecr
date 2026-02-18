# =============================================================================
# Data Sources
# =============================================================================

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_partition" "current" {}

data "aws_partition" "ecr_kms" {}

data "aws_caller_identity" "ecr_kms" {}
