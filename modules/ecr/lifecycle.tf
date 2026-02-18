# =============================================================================
# ECR Lifecycle Policies - Optimized for TFLint & Safety
# =============================================================================

resource "aws_ecr_lifecycle_policy" "this" {
  count = var.create_lifecycle_policy ? 1 : 0

  repository = aws_ecr_repository.this.name

  policy = <<EOF
{
    "rules": [
        ${join(",\n        ", local.all_lifecycle_rules)}
    ]
}
EOF
}

locals {
  # Regra 1: Expire untagged images
  untagged_rule = var.enable_lifecycle_untagged_images ? [jsonencode({
    rulePriority = 1
    description  = "Expire untagged images older than ${var.lifecycle_untagged_days} days"
    selection = {
      tagStatus   = "untagged"
      countType   = "sinceImagePushed"
      countUnit   = "days"
      countNumber = var.lifecycle_untagged_days
    }
    action = { type = "expire" }
  })] : []

  # Regra 2: Keep only N tagged images
  tagged_rule = var.enable_lifecycle_tagged_images ? [jsonencode({
    rulePriority = 2
    description  = "Keep only last ${var.lifecycle_tagged_count} tagged images"
    selection = {
      tagStatus     = "tagged"
      tagPrefixList = var.lifecycle_tagged_prefixes
      countType     = "imageCountMoreThan"
      countNumber   = var.lifecycle_tagged_count
    }
    action = { type = "expire" }
  })] : []

  # Une as regras transformando-as em strings individuais para o join
  # Isso evita o erro de pânico de tipos do TFLint
  all_lifecycle_rules = concat(
    local.untagged_rule,
    local.tagged_rule,
    [for r in var.custom_lifecycle_rules : jsonencode(r)]
  )
}
