# =============================================================================
# ECR Repository Policies
# =============================================================================

# -----------------------------------------------------------------------------
# Repository Policy Document
# -----------------------------------------------------------------------------
data "aws_iam_policy_document" "repository_policy" {
  count = var.create_repository_policy ? 1 : 0

  # Allow repository owner full access
  statement {
    sid    = "RepositoryOwnerFullAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${local.account_id}:root"]
    }

    actions = [
      "ecr:*"
    ]
  }

  # Allow cross-account pull access
  dynamic "statement" {
    for_each = length(var.allowed_read_principals) > 0 ? [1] : []
    content {
      sid    = "AllowCrossAccountPull"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = var.allowed_read_principals
      }

      actions = [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetAuthorizationToken",
        "ecr:DescribeRepositories",
        "ecr:DescribeImages",
        "ecr:ListImages"
      ]
    }
  }

  # Allow cross-account push access
  dynamic "statement" {
    for_each = length(var.allowed_write_principals) > 0 ? [1] : []
    content {
      sid    = "AllowCrossAccountPush"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = var.allowed_write_principals
      }

      actions = [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:DescribeRepositories",
        "ecr:DescribeImages",
        "ecr:ListImages"
      ]
    }
  }

  # Allow Lambda to pull images
  dynamic "statement" {
    for_each = var.allow_lambda_pull ? [1] : []
    content {
      sid    = "AllowLambdaPull"
      effect = "Allow"

      principals {
        type        = "Service"
        identifiers = ["lambda.amazonaws.com"]
      }

      actions = [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ]
    }
  }

  # Custom policy statements
  dynamic "statement" {
    for_each = var.custom_repository_policy_statements
    content {
      sid       = lookup(statement.value, "sid", null)
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = lookup(statement.value, "resources", null)

      dynamic "principals" {
        for_each = lookup(statement.value, "principals", [])
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = lookup(statement.value, "conditions", [])
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

# -----------------------------------------------------------------------------
# Repository Policy
# -----------------------------------------------------------------------------
resource "aws_ecr_repository_policy" "this" {
  count = var.create_repository_policy ? 1 : 0

  repository = aws_ecr_repository.this.name
  policy     = data.aws_iam_policy_document.repository_policy[0].json
}
