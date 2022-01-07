variable "name" {
  description = "The name of the database to create when the DB instance is created"
  default     = "mydatabase"
}

variable "restore_rds_from_snapshot" {
  description = "If value is true, it is required to provide snapshot arn to TF_VAR_snapshot_identifier otherwise, leave it blank"
  default     = false
}

variable "snapshot_identifier" {
  description = "Required, when TF_VAR_restore_rds_from_snapshot is set to true"
  default     = null
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window. Default is false"
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "The minor engine upgrades will be applied automatically to the DB instance during the maintenance window. Defaults to true"
  default     = true
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to true"
  default     = true
}

variable "delete_automated_backups" {
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted. Default is true"
  default     = true
}

variable "enabled_cloudwatch_logs_exports" {
  description = "Set of log types to enable for exporting to CloudWatch logs"
  default     = ["audit", "general", "slowquery", "error"]
}

variable "primary_skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted. If true is specified, no DB snapshot is created."
  default     = false
}

variable "backup_retention_period" {
  description = "How long to keep backups for (in days)"
  default     = 30
}

variable "replica_backup_retention_period" {
  description = "How long to keep backups for (in days). Must be greater than 0 if the database is used as a source for a Read Replica"
  default     = 2
}

variable "enhanced_monitoring_role_enabled" {
  type        = bool
  description = "A boolean flag to enable/disable the creation of the enhanced monitoring IAM role. If set to `false`, the module will not create a new role and will use `rds_monitoring_role_arn` for enhanced monitoring"
  default     = false
}
variable "monitoring_interval" {
  description = "The interval (seconds) between points when Enhanced Monitoring metrics are collected"
  type        = number
  default     = 10
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights is enabled or not"
  type        = bool
  default     = false
}

variable "performance_insights_kms_key_id" {
  description = "The ARN for the KMS key to encrypt Performance Insights data"
  default     = ""
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  default     = "true"
}

variable "storage_type" {
  description = "One of standard (magnetic), gp2 (general purpose SSD), or io1 (provisioned IOPS SSD)"
  default     = "io1"
}

variable "iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of io1"
  default     = 3000
}

variable "allocated_storage" {
  description = "The allocated storage in gibibytes"
  default     = 100
}

variable "private_subnet_ids" {
  description = "Private subnet ids in which db created"
  type        = list(string)
  default     = null
}

variable "replica_private_subnet_ids" {
  description = "Private subnet ids in which replica db created"
  type        = list(string)
  default     = null
}

variable "rds_security_group" {
  description = " List of VPC security groups to associate with  Primary"
  type        = list(any)
  default     = []
}

variable "replica_rds_security_group" {
  description = "List of VPC security groups to associate with Replica"
  type        = list(any)
  default     = []
}

variable "primary_region" {
  description = "primary region where db is create"
  default     = null
}

variable "secondry_region" {
  description = "secondryregion where db replica is create"
  default     = null
}

variable "instance_class" {
  description = "The RDS instance class"
  default     = "db.t2.small"
}

variable "engine_version" {
  description = "The engine version to use. If auto_minor_version_upgrade is enabled, you can provide a prefix of the version such as 5.7 (for 5.7.10) "
  default     = "10.4.13"
}

variable "engine" {
  description = "Required unless a snapshot_identifier or replicate_source_db is provided) The database engine to use"
  default     = "mariadb"
}

variable "Primary_subnet_name" {
  description = "Name of Primary DB subnet group. DB instance will be created in the VPC associated with the DB subnet group"
  default     = "mariadb-subnet"
}

variable "Primary_parameters_name" {
  description = "Name of the DB parameter group to associate."
  default     = "mariadb-params"
}

variable "parameters_family" {
  description = "The family of the DB parameter group."
  default     = "mariadb10.4"
}

variable "replica_parameters_name" {
  description = "The name of the Replica DB parameter group"
  default     = "mariabd-replica-parameter"
}

variable "Replica_subnet_name" {
  description = "Name of Replica DB subnet group. DB instance will be created in the VPC associated with the DB subnet group"
  default     = "mariadb-replica-subnet"
}

variable "user_name" {
  description = "Username for the master DB user"
  default     = "root"
}

variable "primary_identifier" {
  description = "primary_identifier "
  default     = "mariadb"
}

variable "Replica_identifier" {
  description = "Replica_identifier"
  default     = "mariadb-replica"
}

variable "replica_skip_final_snapshot" {
  description = "Determines whether a Replica final DB snapshot is created before the DB cluster is deleted. If true is specified, no DB snapshot is created."
  default     = true
}