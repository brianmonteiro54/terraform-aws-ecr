# =============================================================================
# Example: Complete ECR Repository
#
# This example provisions a production-ready ECR repository with:
#   - Immutable image tags (prevent overwriting tagged images)
#   - KMS encryption with a customer-managed key (auto-created)
#   - Image scanning on every push (basic scanning)
#   - Lifecycle policy: expire untagged images after 7 days, keep last 10 tagged
#   - Repository policy scoped to the account root (no public access)
#   - Separate IAM policies for CI/CD (push-pull) and runtime (pull-only)
#
# Usage:
#   terraform init
#   terraform plan
#   terraform apply
#
# After apply, push your first image:
#   $(terraform output -raw docker_login_command)
#   docker build -t my-app .
#   docker tag my-app:latest $(terraform output -raw repository_url):latest
#   docker push $(terraform output -raw repository_url):latest
# =============================================================================

module "ecr" {
  source = "../../modules/ecr"

  # ---------------------------------------------------
  # Required
  # ---------------------------------------------------
  repository_name = "my-app"
  environment     = "dev"

  # ---------------------------------------------------
  # Repository Configuration
  # IMMUTABLE prevents overwriting existing tags — recommended for prod
  # ---------------------------------------------------
  image_tag_mutability = "IMMUTABLE"
  force_delete         = false # Safety: prevent accidental deletion with images

  # ---------------------------------------------------
  # Encryption — customer-managed KMS key (auto-created)
  # ---------------------------------------------------
  enable_encryption = true
  create_kms_key    = true

  # ---------------------------------------------------
  # Image Scanning
  # scan_on_push = true enables basic scanning on every push
  # Set enable_enhanced_scanning = true for continuous Inspector scanning (prod)
  # ---------------------------------------------------
  scan_on_push             = true
  enable_enhanced_scanning = false

  # ---------------------------------------------------
  # Lifecycle Policy
  # Keeps the repository clean and reduces storage costs
  # ---------------------------------------------------
  create_lifecycle_policy          = true
  enable_lifecycle_untagged_images = true
  lifecycle_untagged_days          = 7 # Remove untagged images after 7 days

  enable_lifecycle_tagged_images = true
  lifecycle_tagged_count         = 10 # Keep last 10 images per tag prefix
  lifecycle_tagged_prefixes      = ["prod", "staging", "dev", "v"]

  # ---------------------------------------------------
  # Repository Policy — scoped to account root only
  # Uncomment allowed_read_principals to grant cross-account pull access
  # ---------------------------------------------------
  create_repository_policy = true
  allowed_read_principals  = [] # e.g. ["arn:aws:iam::111122223333:root"]
  allowed_write_principals = []
  allow_lambda_pull        = false

  # ---------------------------------------------------
  # IAM Policies (attach to your roles)
  #   push_pull_policy → CI/CD pipelines
  #   pull_only_policy → ECS tasks, EKS pods, Lambda
  # ---------------------------------------------------
  create_iam_policies = true

  # ---------------------------------------------------
  # Tags
  # ---------------------------------------------------
  tags = {
    Project    = "my-app"
    Owner      = "platform-team"
    CostCenter = "engineering"
  }
}
