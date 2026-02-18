# =============================================================================
# IAM Policies for ECR Access
# =============================================================================

# -----------------------------------------------------------------------------
# IAM Policy - Pull Only (Read-Only)
# -----------------------------------------------------------------------------
data "aws_iam_policy_document" "pull_only" {
  count = var.create_iam_policies ? 1 : 0

  statement {
    sid    = "AllowECRPull"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:DescribeRepositories",
      "ecr:DescribeImages",
      "ecr:ListImages"
    ]

    resources = [
      aws_ecr_repository.this.arn
    ]
  }

  # Allow getting auth token (account-level permission)
  statement {
    sid    = "AllowGetAuthToken"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "pull_only" {
  count = var.create_iam_policies ? 1 : 0

  name        = "${replace(local.repository_name, "/", "-")}-ecr-pull-only"
  description = "IAM policy for pulling images from ECR repository ${local.repository_name}"
  policy      = data.aws_iam_policy_document.pull_only[0].json

  tags = local.common_tags
}

# -----------------------------------------------------------------------------
# IAM Policy - Push and Pull (Read-Write)
# -----------------------------------------------------------------------------
data "aws_iam_policy_document" "push_pull" {
  count = var.create_iam_policies ? 1 : 0

  statement {
    sid    = "AllowECRPushPull"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:DescribeImages",
      "ecr:ListImages"
    ]

    resources = [
      aws_ecr_repository.this.arn
    ]
  }

  # Allow getting auth token
  statement {
    sid    = "AllowGetAuthToken"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "push_pull" {
  count = var.create_iam_policies ? 1 : 0

  name        = "${replace(local.repository_name, "/", "-")}-ecr-push-pull"
  description = "IAM policy for pushing and pulling images from ECR repository ${local.repository_name}"
  policy      = data.aws_iam_policy_document.push_pull[0].json

  tags = local.common_tags
}
