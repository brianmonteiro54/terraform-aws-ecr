# 📦 Terraform AWS ECR

[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.9.0-623CE4?logo=terraform)](https://www.terraform.io/)
[![AWS Provider](https://img.shields.io/badge/AWS%20Provider-~%3E%206.31-FF9900?logo=amazonaws)](https://registry.terraform.io/providers/hashicorp/aws/latest)

> **FIAP — Pós Tech · Tech Challenge — Fase 03 · ToggleMaster**
>
> Módulo Terraform para provisionamento de repositórios **Amazon ECR** com lifecycle policies, scanning, criptografia e replicação.

---

## 📋 Descrição

Módulo completo para repositórios ECR com:

- **Repositórios privados** com tag immutability configurável
- **Lifecycle Policies** para limpeza automática de imagens (untagged e tagged)
- **Image Scanning** on push (opcional)
- **Encryption** AES-256 ou KMS
- **Repository Policies** para acesso cross-account
- **Replication** para multi-região (opcional)
- **IAM Policies** para push/pull granular

---

## 🚀 Uso

```hcl
module "ecr" {
  source = "github.com/brianmonteiro54/terraform-aws-ecr//modules/ecr?ref=<commit-sha>"

  repository_name        = "auth-service"
  repository_name_prefix = "togglemaster"
  environment            = "production"

  image_tag_mutability = "IMMUTABLE"
  scan_on_push         = false

  create_lifecycle_policy          = true
  enable_lifecycle_untagged_images = true
  lifecycle_untagged_days          = 3
  enable_lifecycle_tagged_images   = true
  lifecycle_tagged_count           = 10

  enable_encryption        = true
  create_kms_key           = false
  create_iam_policies      = false
  create_repository_policy = false
}
```

### Repositórios Criados

| Repositório | Microsserviço |
|-------------|---------------|
| `togglemaster/auth-service` | Autenticação e autorização |
| `togglemaster/flag-service` | Gerenciamento de feature flags |
| `togglemaster/targeting-service` | Regras de targeting |
| `togglemaster/evaluation-service` | Avaliação de flags |
| `togglemaster/analytics-service` | Coleta e análise de eventos |

---

## 📁 Estrutura

```
terraform-aws-ecr/
├── modules/
│   └── ecr/
│       ├── main.tf
│       ├── lifecycle.tf
│       ├── policies.tf
│       ├── scanning.tf
│       ├── replication.tf
│       ├── kms.tf
│       ├── iam.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── locals.tf
│       ├── data.tf
│       └── provider.tf
├── .github/workflows/
│   └── terraform-ci.yml
└── LICENSE
```
## 📄 Licença

[MIT License](LICENSE)
