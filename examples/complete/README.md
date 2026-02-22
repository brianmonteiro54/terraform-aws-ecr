# Example: Complete ECR Repository

This example provisions a production-ready ECR repository for container image storage.

## What is created

- ECR repository with **immutable tags** (prevents overwriting tagged images)
- Customer-managed KMS key for encryption (auto-created)
- Image scanning on every push (basic scanning)
- Lifecycle policy:
  - Untagged images expire after **7 days**
  - Max **10 tagged images** kept per prefix (`prod`, `staging`, `dev`, `v`)
- Repository policy scoped to the account root
- Two IAM policies ready to attach to your roles:
  - **push-pull** — for CI/CD pipelines (build & push)
  - **pull-only** — for ECS tasks, EKS pods, Lambda (runtime)

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Pushing your first image

```bash
# Authenticate Docker with ECR
$(terraform output -raw docker_login_command)

# Build and push
docker build -t my-app .
docker tag my-app:latest $(terraform output -raw repository_url):v1.0.0
docker push $(terraform output -raw repository_url):v1.0.0
```

## Pulling an image (from ECS/EKS)

```bash
# Your ECS task or EKS pod role needs the pull_only_policy attached
docker pull $(terraform output -raw repository_url):v1.0.0
```

## Inputs

| Name | Description | Required |
|------|-------------|----------|
| aws_region | AWS region | No (default: `us-east-1`) |

## Outputs

| Name | Description |
|------|-------------|
| repository_url | Full URL for `docker push/pull` |
| push_pull_policy_arn | IAM policy for CI/CD roles |
| pull_only_policy_arn | IAM policy for ECS/EKS/Lambda roles |
| docker_login_command | Ready-to-run `aws ecr get-login-password` command |
| kms_key_arn | KMS key ARN for at-rest encryption |

> **Cross-account access:** Add the consumer account root to `allowed_read_principals`
> to allow another AWS account to pull images from this repository.

> **Production checklist:** Set `enable_enhanced_scanning = true` for continuous
> vulnerability scanning powered by Amazon Inspector. Use tag convention `v*` for
> semantic versioning and keep `image_tag_mutability = "IMMUTABLE"`.
