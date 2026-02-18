# =============================================================================
# ECR Enhanced Scanning (Inspector)
# =============================================================================

# -----------------------------------------------------------------------------
# Registry Scanning Configuration
# Enhanced scanning is configured at the registry level
# -----------------------------------------------------------------------------
resource "aws_ecr_registry_scanning_configuration" "this" {
  count = var.enable_enhanced_scanning ? 1 : 0

  scan_type = "ENHANCED"

  dynamic "rule" {
    for_each = var.enhanced_scanning_rules
    content {
      scan_frequency = rule.value.scan_frequency

      dynamic "repository_filter" {
        for_each = rule.value.repository_filters
        content {
          filter      = repository_filter.value.filter
          filter_type = repository_filter.value.filter_type
        }
      }
    }
  }
}
