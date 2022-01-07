####### For DB Password #######
resource "random_string" "root_password" {
  length  = 32
  upper   = true
  lower   = true
  number  = true
  special = false
}


resource "random_id" "snapshot_identifier" {
  keepers = {
    id = var.name
  }
  byte_length = 4
}

############### Primary region DB subnet group ###########
resource "aws_db_subnet_group" "mariadb-subnet" {
  name        = var.Primary_subnet_name
  description = "RDS subnet group"
  subnet_ids  = var.private_subnet_ids
}

resource "aws_db_parameter_group" "mariadb-parameters" {
  name        = var.Primary_parameters_name
  family      = var.parameters_family
  description = "MariaDB parameter group"

  parameter {
    name  = "max_allowed_packet"
    value = "16777216"
  }
}

############### Cross region DB subnet group ###########
resource "aws_db_subnet_group" "mariadb-subnet-region2" {
  provider    = aws.region2
  name        = var.Replica_subnet_name
  description = "RDS subnet group"
  subnet_ids  = var.replica_private_subnet_ids
}

resource "aws_db_parameter_group" "mariadb-parameters-region2" {
  provider    = aws.region2
  name        = var.replica_parameters_name
  family      = var.parameters_family
  description = "MariaDB parameter group"

  parameter {
    name  = "max_allowed_packet"
    value = "16777216"
  }
}


resource "aws_db_instance" "mariadb" {

  allocated_storage               = var.allocated_storage
  engine                          = var.engine
  engine_version                  = var.engine_version
  instance_class                  = var.instance_class
  identifier                      = var.primary_identifier
  name                            = var.name
  username                        = var.user_name
  password                        = random_string.root_password.result
  db_subnet_group_name            = aws_db_subnet_group.mariadb-subnet.name
  parameter_group_name            = aws_db_parameter_group.mariadb-parameters.name
  multi_az                        = var.multi_az
  vpc_security_group_ids          = var.rds_security_group
  storage_type                    = var.storage_type
  iops                            = var.storage_type == "io1" ? var.iops : null
  apply_immediately               = var.apply_immediately
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  deletion_protection             = var.deletion_protection
  delete_automated_backups        = var.delete_automated_backups
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  skip_final_snapshot             = var.primary_skip_final_snapshot
  backup_retention_period         = var.backup_retention_period

  # Enhanced monitoring
  monitoring_interval             = var.enhanced_monitoring_role_enabled == true ? var.monitoring_interval : 0
  monitoring_role_arn             = var.enhanced_monitoring_role_enabled == true ? aws_iam_role.rds_enhanced_monitoring[0].arn : ""
  performance_insights_enabled    = var.performance_insights_enabled
  performance_insights_kms_key_id = var.performance_insights_enabled == true ? var.performance_insights_kms_key_id : ""
  final_snapshot_identifier       = "mariadb-final-snapshot-${element(concat(random_id.snapshot_identifier.*.hex, [""]), 0)}"
  snapshot_identifier             = var.restore_rds_from_snapshot == true ? var.snapshot_identifier : null
  tags = {
    Name = "mariadb-instance"
  }
}

resource "aws_db_instance" "mariadb-replica" {

  provider = aws.region2
  # Source database. For cross-region use db_instance_arn
  replicate_source_db    = aws_db_instance.mariadb.arn
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  identifier             = var.Replica_identifier
  db_subnet_group_name   = aws_db_subnet_group.mariadb-subnet-region2.name
  parameter_group_name   = aws_db_parameter_group.mariadb-parameters-region2.name
  multi_az               = var.multi_az
  vpc_security_group_ids = var.replica_rds_security_group
  storage_type           = var.storage_type
  iops                   = var.storage_type == "io1" ? var.iops : null

  apply_immediately               = var.apply_immediately
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  deletion_protection             = var.deletion_protection
  delete_automated_backups        = var.delete_automated_backups
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  backup_retention_period         = var.replica_backup_retention_period

  # Enhanced monitoring
  monitoring_interval             = var.enhanced_monitoring_role_enabled == true ? var.monitoring_interval : 0
  monitoring_role_arn             = var.enhanced_monitoring_role_enabled == true ? aws_iam_role.rds_enhanced_monitoring[0].arn : ""
  performance_insights_enabled    = var.performance_insights_enabled
  skip_final_snapshot             = var.replica_skip_final_snapshot
  performance_insights_kms_key_id = var.performance_insights_enabled == true ? var.performance_insights_kms_key_id : ""


  tags = {
    Name = "mariadb-instance"
  }

  lifecycle {
    ignore_changes = [
      replicate_source_db
    ]
  }
}
