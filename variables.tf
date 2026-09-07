variable "namespace" {
  description = "Namespace for the AWS Backup resources"
  type        = string
}

variable "backup_schedule" {
  description = "Cron expression for the backup schedule"
  type        = string
  default     = "cron(0 3 * * ? *)"
}

variable "backup_retention_days" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

variable "backup_resources" {
  description = "List of AWS resource ARNs to include in the backup selection"
  type        = list(string)
}