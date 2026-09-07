# AWS Backups Module
This module will create a backup vault, plan and selection.

### Example
```
module "aws-backup-vault" { 
    source = "github.com/tom-j-smith/aws-backup-vault"

    namespace             = var.namespace
    backup_schedule       = "cron(0 3 * * ? *)"
    backup_retention_days = 7

    backup_resources = [
        module.s3.arn,
        module.rds.arn
    ]
}
```