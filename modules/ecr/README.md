# ECR Module

Módulo Terraform para criação de ECR na AWS.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.31 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.32.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_lifecycle_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_registry_scanning_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_registry_scanning_configuration) | resource |
| [aws_ecr_replication_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_replication_configuration) | resource |
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [aws_iam_policy.pull_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.push_pull](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_kms_alias.ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ecr_kms_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.pull_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.push_pull](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.repository_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_lambda_pull"></a> [allow\_lambda\_pull](#input\_allow\_lambda\_pull) | Allow Lambda to pull images | `bool` | `false` | no |
| <a name="input_allowed_read_principals"></a> [allowed\_read\_principals](#input\_allowed\_read\_principals) | ARNs allowed to pull images | `list(string)` | `[]` | no |
| <a name="input_allowed_write_principals"></a> [allowed\_write\_principals](#input\_allowed\_write\_principals) | ARNs allowed to push images | `list(string)` | `[]` | no |
| <a name="input_create_iam_policies"></a> [create\_iam\_policies](#input\_create\_iam\_policies) | Create IAM policies for ECR access | `bool` | `false` | no |
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | Create custom KMS key for ECR encryption | `bool` | `true` | no |
| <a name="input_create_lifecycle_policy"></a> [create\_lifecycle\_policy](#input\_create\_lifecycle\_policy) | Create lifecycle policy | `bool` | `true` | no |
| <a name="input_create_repository_policy"></a> [create\_repository\_policy](#input\_create\_repository\_policy) | Create repository policy | `bool` | `false` | no |
| <a name="input_custom_lifecycle_rules"></a> [custom\_lifecycle\_rules](#input\_custom\_lifecycle\_rules) | Custom lifecycle rules | `list(any)` | `[]` | no |
| <a name="input_custom_repository_policy_statements"></a> [custom\_repository\_policy\_statements](#input\_custom\_repository\_policy\_statements) | Custom repository policy statements | `list(any)` | `[]` | no |
| <a name="input_enable_encryption"></a> [enable\_encryption](#input\_enable\_encryption) | Enable KMS encryption | `bool` | `true` | no |
| <a name="input_enable_enhanced_scanning"></a> [enable\_enhanced\_scanning](#input\_enable\_enhanced\_scanning) | Enable enhanced scanning with Amazon Inspector | `bool` | `false` | no |
| <a name="input_enable_lifecycle_tagged_images"></a> [enable\_lifecycle\_tagged\_images](#input\_enable\_lifecycle\_tagged\_images) | Enable lifecycle rule for tagged images | `bool` | `true` | no |
| <a name="input_enable_lifecycle_untagged_images"></a> [enable\_lifecycle\_untagged\_images](#input\_enable\_lifecycle\_untagged\_images) | Enable lifecycle rule for untagged images | `bool` | `true` | no |
| <a name="input_enable_multi_region"></a> [enable\_multi\_region](#input\_enable\_multi\_region) | Enable multi-region KMS key | `bool` | `false` | no |
| <a name="input_enable_replication"></a> [enable\_replication](#input\_enable\_replication) | Enable cross-region replication | `bool` | `false` | no |
| <a name="input_enhanced_scanning_rules"></a> [enhanced\_scanning\_rules](#input\_enhanced\_scanning\_rules) | Enhanced scanning rules | <pre>list(object({<br/>    scan_frequency = string<br/>    repository_filters = list(object({<br/>      filter      = string<br/>      filter_type = string<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (dev/staging/prod) | `string` | n/a | yes |
| <a name="input_force_delete"></a> [force\_delete](#input\_force\_delete) | Delete repository even if it contains images | `bool` | `false` | no |
| <a name="input_image_tag_mutability"></a> [image\_tag\_mutability](#input\_image\_tag\_mutability) | Image tag mutability setting (MUTABLE or IMMUTABLE) | `string` | `"IMMUTABLE"` | no |
| <a name="input_kms_deletion_window_in_days"></a> [kms\_deletion\_window\_in\_days](#input\_kms\_deletion\_window\_in\_days) | KMS key deletion window | `number` | `30` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | ARN of existing KMS key | `string` | `null` | no |
| <a name="input_lifecycle_tagged_count"></a> [lifecycle\_tagged\_count](#input\_lifecycle\_tagged\_count) | Number of tagged images to keep | `number` | `10` | no |
| <a name="input_lifecycle_tagged_prefixes"></a> [lifecycle\_tagged\_prefixes](#input\_lifecycle\_tagged\_prefixes) | Tag prefixes for lifecycle policy | `list(string)` | <pre>[<br/>  "prod",<br/>  "staging",<br/>  "dev"<br/>]</pre> | no |
| <a name="input_lifecycle_untagged_days"></a> [lifecycle\_untagged\_days](#input\_lifecycle\_untagged\_days) | Days to keep untagged images | `number` | `7` | no |
| <a name="input_replication_destinations"></a> [replication\_destinations](#input\_replication\_destinations) | Replication destination configurations | <pre>list(object({<br/>    region      = string<br/>    registry_id = string<br/>    repository_filters = optional(list(object({<br/>      filter      = string<br/>      filter_type = string<br/>    })))<br/>  }))</pre> | `[]` | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | Name of the ECR repository | `string` | n/a | yes |
| <a name="input_repository_name_prefix"></a> [repository\_name\_prefix](#input\_repository\_name\_prefix) | Prefix for repository name (e.g., 'mycompany' results in 'mycompany/repo-name') | `string` | `""` | no |
| <a name="input_scan_on_push"></a> [scan\_on\_push](#input\_scan\_on\_push) | Enable image scanning on push (basic scanning) | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection_info"></a> [connection\_info](#output\_connection\_info) | Connection information for CI/CD |
| <a name="output_docker_commands"></a> [docker\_commands](#output\_docker\_commands) | Docker commands for repository |
| <a name="output_kms_key_alias"></a> [kms\_key\_alias](#output\_kms\_key\_alias) | KMS key alias |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS key ARN |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS key ID |
| <a name="output_pull_only_policy_arn"></a> [pull\_only\_policy\_arn](#output\_pull\_only\_policy\_arn) | ARN of the pull-only IAM policy |
| <a name="output_pull_only_policy_name"></a> [pull\_only\_policy\_name](#output\_pull\_only\_policy\_name) | Name of the pull-only IAM policy |
| <a name="output_push_pull_policy_arn"></a> [push\_pull\_policy\_arn](#output\_push\_pull\_policy\_arn) | ARN of the push-pull IAM policy |
| <a name="output_push_pull_policy_name"></a> [push\_pull\_policy\_name](#output\_push\_pull\_policy\_name) | Name of the push-pull IAM policy |
| <a name="output_registry_id"></a> [registry\_id](#output\_registry\_id) | Registry ID where the repository was created |
| <a name="output_repository_arn"></a> [repository\_arn](#output\_repository\_arn) | ARN of the ECR repository |
| <a name="output_repository_name"></a> [repository\_name](#output\_repository\_name) | Name of the ECR repository |
| <a name="output_repository_url"></a> [repository\_url](#output\_repository\_url) | URL of the ECR repository |
<!-- END_TF_DOCS -->