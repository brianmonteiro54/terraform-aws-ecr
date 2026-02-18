# =============================================================================
# Outputs - ECR Module
# =============================================================================

# -----------------------------------------------------------------------------
# Repository Information
# -----------------------------------------------------------------------------
output "repository_arn" {
  description = "ARN of the ECR repository"
  value       = aws_ecr_repository.this.arn
}

output "repository_name" {
  description = "Name of the ECR repository"
  value       = aws_ecr_repository.this.name
}

output "repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.this.repository_url
}

output "registry_id" {
  description = "Registry ID where the repository was created"
  value       = aws_ecr_repository.this.registry_id
}

# -----------------------------------------------------------------------------
# KMS Information
# -----------------------------------------------------------------------------
output "kms_key_id" {
  description = "KMS key ID"
  value       = local.kms_key_arn
}

output "kms_key_arn" {
  description = "KMS key ARN"
  value       = local.kms_key_arn
}

output "kms_key_alias" {
  description = "KMS key alias"
  value       = try(aws_kms_alias.ecr[0].name, null)
}

# -----------------------------------------------------------------------------
# IAM Policy Information
# -----------------------------------------------------------------------------
output "pull_only_policy_arn" {
  description = "ARN of the pull-only IAM policy"
  value       = try(aws_iam_policy.pull_only[0].arn, null)
}

output "pull_only_policy_name" {
  description = "Name of the pull-only IAM policy"
  value       = try(aws_iam_policy.pull_only[0].name, null)
}

output "push_pull_policy_arn" {
  description = "ARN of the push-pull IAM policy"
  value       = try(aws_iam_policy.push_pull[0].arn, null)
}

output "push_pull_policy_name" {
  description = "Name of the push-pull IAM policy"
  value       = try(aws_iam_policy.push_pull[0].name, null)
}

# -----------------------------------------------------------------------------
# Usage Examples
# -----------------------------------------------------------------------------
output "docker_commands" {
  description = "Docker commands for repository"
  value = {
    login = "aws ecr get-login-password --region ${local.region} | docker login --username AWS --password-stdin ${aws_ecr_repository.this.repository_url}"
    build = "docker build -t ${aws_ecr_repository.this.name} ."
    tag   = "docker tag ${aws_ecr_repository.this.name}:latest ${aws_ecr_repository.this.repository_url}:latest"
    push  = "docker push ${aws_ecr_repository.this.repository_url}:latest"
    pull  = "docker pull ${aws_ecr_repository.this.repository_url}:latest"
  }
}

# -----------------------------------------------------------------------------
# Connection Information
# -----------------------------------------------------------------------------
output "connection_info" {
  description = "Connection information for CI/CD"
  value = {
    repository_url  = aws_ecr_repository.this.repository_url
    repository_arn  = aws_ecr_repository.this.arn
    registry_id     = aws_ecr_repository.this.registry_id
    region          = local.region
    repository_name = aws_ecr_repository.this.name
  }
}
