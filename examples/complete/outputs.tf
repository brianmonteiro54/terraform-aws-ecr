output "repository_url" {
  description = "Full ECR repository URL for docker push/pull"
  value       = module.ecr.repository_url
}

output "repository_arn" {
  description = "ARN of the ECR repository"
  value       = module.ecr.repository_arn
}

output "repository_name" {
  description = "Name of the ECR repository"
  value       = module.ecr.repository_name
}

output "registry_id" {
  description = "AWS account ID of the registry"
  value       = module.ecr.registry_id
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for encryption"
  value       = module.ecr.kms_key_arn
}

output "kms_key_alias" {
  description = "Alias of the KMS key"
  value       = module.ecr.kms_key_alias
}

output "pull_only_policy_arn" {
  description = "IAM policy ARN for pull-only access (attach to ECS tasks, EKS nodes, Lambda)"
  value       = module.ecr.pull_only_policy_arn
}

output "push_pull_policy_arn" {
  description = "IAM policy ARN for push and pull access (attach to CI/CD roles)"
  value       = module.ecr.push_pull_policy_arn
}

output "docker_commands" {
  description = "Ready-to-use Docker commands"
  value       = module.ecr.docker_commands
}

output "docker_login_command" {
  description = "Docker login command for this registry"
  value       = module.ecr.docker_commands.login
}

output "connection_info" {
  description = "Connection information for CI/CD pipelines"
  value       = module.ecr.connection_info
}
