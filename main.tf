# Create AWS Backup Vault
resource "aws_backup_vault" "vault" {
  name = "${var.namespace}-backup-vault"
}

# Create AWS Backup Plan
resource "aws_backup_plan" "plan" {
  name = "${var.namespace}-backup-plan"

  rule {
    rule_name         = "${var.namespace}-backup-rule"
    target_vault_name = aws_backup_vault.vault.name
    schedule          = "${var.backup_schedule}"

    lifecycle {
      delete_after = var.backup_retention_days
    }
  }
}

# Create IAM Role for Backups
data "aws_iam_policy_document" "backup_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "backup" {
  name               = "${var.namespace}-backup-service-role"
  assume_role_policy = data.aws_iam_policy_document.backup_assume_role.json
}

resource "aws_iam_role_policy_attachment" "backup" {
  role       = aws_iam_role.backup.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

# Create AWS Backup Selection
resource "aws_backup_selection" "example" {
  iam_role_arn = aws_iam_role.backup.arn
  name         = "${var.namespace}-backup-selection"
  plan_id      = aws_backup_plan.plan.id

  resources = var.backup_resources

  condition {
    string_equals {
      key   = "aws:ResourceTag/namespace"
      value = "${var.namespace}"
    }
  }
}