# =============================================================================
# ECR Replication Configuration
# =============================================================================

# -----------------------------------------------------------------------------
# Replication Configuration (Registry-level, not repository-level)
# Note: This creates a registry replication configuration
# -----------------------------------------------------------------------------
resource "aws_ecr_replication_configuration" "this" {
  count = var.enable_replication && length(var.replication_destinations) > 0 ? 1 : 0

  replication_configuration {
    dynamic "rule" {
      for_each = var.replication_destinations
      content {
        dynamic "destination" {
          for_each = [rule.value]
          content {
            region      = destination.value.region
            registry_id = destination.value.registry_id
          }
        }

        dynamic "repository_filter" {
          for_each = lookup(rule.value, "repository_filters", [])
          content {
            filter      = repository_filter.value.filter
            filter_type = repository_filter.value.filter_type
          }
        }
      }
    }
  }
}
