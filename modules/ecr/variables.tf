# =============================================================================
# Variables - ECR Module
# =============================================================================

# -----------------------------------------------------------------------------
# Required Variables
# -----------------------------------------------------------------------------
variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9](?:[a-z0-9-_]*[a-z0-9])?(?:/[a-z0-9](?:[a-z0-9-_]*[a-z0-9])?)*$", var.repository_name))
    error_message = "Repository name must follow ECR naming conventions."
  }
}

variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string

  validation {
    condition     = can(regex("^(dev|development|staging|stage|prod|production|qa|test)$", var.environment))
    error_message = "Environment must be valid."
  }
}

# -----------------------------------------------------------------------------
# Optional - Repository Configuration
# -----------------------------------------------------------------------------
variable "repository_name_prefix" {
  description = "Prefix for repository name (e.g., 'mycompany' results in 'mycompany/repo-name')"
  type        = string
  default     = ""
}

variable "image_tag_mutability" {
  description = "Image tag mutability setting (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "IMMUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "Image tag mutability must be MUTABLE or IMMUTABLE."
  }
}

variable "force_delete" {
  description = "Delete repository even if it contains images"
  type        = bool
  default     = false
}

# -----------------------------------------------------------------------------
# Security - Encryption
# -----------------------------------------------------------------------------
variable "enable_encryption" {
  description = "Enable KMS encryption"
  type        = bool
  default     = true
}

variable "create_kms_key" {
  description = "Create custom KMS key for ECR encryption"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN of existing KMS key"
  type        = string
  default     = null
}

variable "kms_deletion_window_in_days" {
  description = "KMS key deletion window"
  type        = number
  default     = 30

  validation {
    condition     = var.kms_deletion_window_in_days >= 7 && var.kms_deletion_window_in_days <= 30
    error_message = "Must be between 7 and 30 days."
  }
}

variable "enable_multi_region" {
  description = "Enable multi-region KMS key"
  type        = bool
  default     = false
}

# -----------------------------------------------------------------------------
# Image Scanning
# -----------------------------------------------------------------------------
variable "scan_on_push" {
  description = "Enable image scanning on push (basic scanning)"
  type        = bool
  default     = true
}

variable "enable_enhanced_scanning" {
  description = "Enable enhanced scanning with Amazon Inspector"
  type        = bool
  default     = false
}

variable "enhanced_scanning_rules" {
  description = "Enhanced scanning rules"
  type = list(object({
    scan_frequency = string
    repository_filters = list(object({
      filter      = string
      filter_type = string
    }))
  }))
  default = []
}

# -----------------------------------------------------------------------------
# Lifecycle Policy
# -----------------------------------------------------------------------------
variable "create_lifecycle_policy" {
  description = "Create lifecycle policy"
  type        = bool
  default     = true
}

variable "enable_lifecycle_untagged_images" {
  description = "Enable lifecycle rule for untagged images"
  type        = bool
  default     = true
}

variable "lifecycle_untagged_days" {
  description = "Days to keep untagged images"
  type        = number
  default     = 7
}

variable "enable_lifecycle_tagged_images" {
  description = "Enable lifecycle rule for tagged images"
  type        = bool
  default     = true
}

variable "lifecycle_tagged_count" {
  description = "Number of tagged images to keep"
  type        = number
  default     = 10
}

variable "lifecycle_tagged_prefixes" {
  description = "Tag prefixes for lifecycle policy"
  type        = list(string)
  default     = ["prod", "staging", "dev"]
}

variable "custom_lifecycle_rules" {
  description = "Custom lifecycle rules"
  type        = list(any)
  default     = []
}

# -----------------------------------------------------------------------------
# Repository Policy
# -----------------------------------------------------------------------------
variable "create_repository_policy" {
  description = "Create repository policy"
  type        = bool
  default     = false
}

variable "allowed_read_principals" {
  description = "ARNs allowed to pull images"
  type        = list(string)
  default     = []
}

variable "allowed_write_principals" {
  description = "ARNs allowed to push images"
  type        = list(string)
  default     = []
}

variable "allow_lambda_pull" {
  description = "Allow Lambda to pull images"
  type        = bool
  default     = false
}

variable "custom_repository_policy_statements" {
  description = "Custom repository policy statements"
  type        = list(any)
  default     = []
}

# -----------------------------------------------------------------------------
# IAM Policies
# -----------------------------------------------------------------------------
variable "create_iam_policies" {
  description = "Create IAM policies for ECR access"
  type        = bool
  default     = false
}

# -----------------------------------------------------------------------------
# Replication
# -----------------------------------------------------------------------------
variable "enable_replication" {
  description = "Enable cross-region replication"
  type        = bool
  default     = false
}

variable "replication_destinations" {
  description = "Replication destination configurations"
  type = list(object({
    region      = string
    registry_id = string
    repository_filters = optional(list(object({
      filter      = string
      filter_type = string
    })))
  }))
  default = []
}

# -----------------------------------------------------------------------------
# Tags
# -----------------------------------------------------------------------------
variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

variable "cost_center" {
  description = "Cost center"
  type        = string
  default     = "engineering"
}
