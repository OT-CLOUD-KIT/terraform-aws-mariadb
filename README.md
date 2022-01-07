AWS RDS MariaDB Terraform module
=====================================

[![Opstree Solutions][opstree_avatar]][opstree_homepage]

[Opstree Solutions][opstree_homepage] 

  [opstree_homepage]: https://opstree.github.io/
  [opstree_avatar]: https://img.cloudposse.com/150x150/https://github.com/opstree.png

Terraform module which creates Master Slave Replication MariaDB on AWS.

These types of resources are supported:

* [aws_db_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group)
* [aws_db_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group)
* [aws_db_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance)


Terraform versions
------------------

Terraform 1.0.9.

Usage
------

```hcl

provider "aws" {
  region  = "ap-south-1"
}
module "mariadb" {
  source                          = "./rds-classic"
  name                            = "mydatabase"
  engine                          = "mariadb"
  engine_version                  = "10.4.13"
  instance_class                  = "db.t2.small"
  primary_identifier              = "mariadb"
  Replica_identifier              = "mariadb-replica"
  user_name                       = "root"
  deletion_protection             = false
  private_subnet_ids              = ["subnet-7d8c6216", "subnet-0dc89441"]
  rds_security_group              = ["sg-00224a54e254e5207"]
  replica_private_subnet_ids      = ["subnet-0dc89441", "subnet-04efa5b17ca8dd288"]
  replica_rds_security_group      = ["sg-00224a54e254e5207"]
  primary_region                  = "ap-south-1"
  secondry_region                 = "ap-south-1"
  multi_az                        = true
  allocated_storage               = 100
  iops                            = 3000
  storage_type                    = "io1"
  replica_backup_retention_period = 2
  backup_retention_period         = 30
  delete_automated_backups        = true 
  primary_skip_final_snapshot     = false
 
  ** # Add below two line to restore RDS from Snapshot ** 
 
  restore_rds_from_snapshot       = true    

  snapshot_identifier = "arn:aws:rds:ap-south-1:858266601255:snapshot:mariadb-final-snapshot-26a6ff31"
}

```


Inputs
------
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name  | The name of the database to create when the DB instance is created | `string` | `"mydatabase"` | No |
| engine  | (Required unless a snapshot_identifier or replicate_source_db is provided) The database engine to use | `string` | `"mariadb"` | No |
| engine_version | The engine version to use. If auto_minor_version_upgrade is enabled, you can provide a prefix of the version such as 5.7 (for 5.7.10) | `string` | `"10.4.13"` | No |
| instance_class | The RDS instance class. | `string` | `"db.t2.small"` | No |
| primary_identifier | The name of the primary RDS instance  | `string` | `"mariadb"` | No |
| Replica_identifier | The name of the Replica  RDS instance | `string` | `"mariadb-replica"` | No |
| deletion_protection |If the DB instance should have deletion protection enabled. The database can`t be deleted when this value is set to true | `boolean` | `"false"` | No |
| private_subnet_ids |Private subnet ids in which db created| `List(string)` | `Null` | yes |
| rds_security_group  |List of VPC security groups to associate with  Primary  | `List(string)` | `Null` | No |
| replica_private_subnet_ids |Private subnet ids in which replica db created| `List(string)` | `Null` | Yes |
| replica_rds_security_group |List of VPC security groups to associate with  Replica |`List(string)` | `Null` | No |
| primary_region |primary region where db is create | `string` | `Null` | No |
|secondry_region | secondryregion where db replica is create | `string` | `Null` | No |
| Primary_subnet_name | Name of Primary DB subnet group. DB instance will be created in the VPC associated with the DB subnet group | `string` | `"mariadb-subnet"` | No | 
| Primary_parameters_name | Name of the DB parameter group to associate. | `string` | `"mariadb-params"` | No |
| parameters_family | The family of the DB parameter group. | `string` | mariadb10.4 | No |
| Replica_parameters_name | The name of the DB parameter group | `string` | `"mariadb-params-replica"` | No |
| Replica_subnet_name | Name of Replica DB subnet group. DB instance will be created in the VPC associated with the DB subnet group |  `string` | `"mariadb-subnet-replica"` | No |
| user_name | Username for the master DB user | `string` | `"root"` | No |
| replica_skip_final_snapshot | Determines whether a Replica final DB snapshot is created before the DB cluster is deleted. If true is specified, no DB snapshot is created. | `boolean` | `"true"` | No |
| restore_rds_from_snapshot |If value is true, it is required to provide snapshot arn to TF_VAR_snapshot_identifier otherwise, leave it blank| `boolean` | `"false"` | No|
| snapshot_identifier |Required, when TF_VAR_restore_rds_from_snapshot is set to true.Specifies whether or not to create this database from a snapshot.| `string` | `Null` | No |
| apply_immediately |Specifies whether any database modifications are applied immediately, or during the next maintenance window.| `boolean` | `false` | No |
| auto_minor_version_upgrade | "The minor engine upgrades will be applied automatically to the DB instance during the maintenance window." | `boolean` | `true` | No |
| delete_automated_backups  | Specifies whether to remove automated backups immediately after the DB instance is deleted | `boolean` | `true` | No |
| enabled_cloudwatch_logs_exports  | Set of log types to enable for exporting to CloudWatch logs | `list(string)` | `["audit", "general", "slowquery", "error"]` | No |
| primary_skip_final_snapshot  | Determines whether a final DB snapshot is created before the DB cluster is deleted. If true is specified, no DB snapshot is created. | `boolean` | `false` | No |
| backup_retention_period | How long to keep backups for (in days) | `number` | `30` | No |
| replica_backup_retention_period  | How long to keep backups for (in days). Must be greater than 0 if the database is used as a source for a Read Replica | `number` | `2` | No |
|enhanced_monitoring_role_enabled  | A boolean flag to enable/disable the creation of the enhanced monitoring IAM role. If set to `false`, the module will not create a new role and will use `rds_monitoring_role_arn` for enhanced monitoring | `boolean` |    `false` | No |
|monitoring_interval  | The interval (seconds) between points when Enhanced Monitoring metrics are collected | `number` | `10` | No |
|performance_insights_enabled  | Specifies whether Performance Insights is enabled or not | `boolean` | `false` | No |
|performance_insights_kms_key_id  | The ARN for the KMS key to encrypt Performance Insights data | `string` | `Null` | No |
| multi_az  | Specifies if the RDS instance is multi-AZ | `boolean` | `true` | No |
| storage_type | One of standard (magnetic), gp2 (general purpose SSD), or io1 (provisioned IOPS SSD) | `string` | `"i01"` | No
| iops | The amount of provisioned IOPS. Setting this implies a storage_type of io1 | `number` | `3000` | No |
| allocated_storage | The allocated storage in gibibytes | `number` | `100` | No |



Output
------
| Name | Description |
|------|-------------|
| mariadb_username | The master username for the database |
| mariadb_password | The master username  Password for the database  |
| mariadb_arn | The ARN of the RDS instance |
| mariadb_id | The RDS instance ID. |



### Contributors

[![Shweta Tyagi][shweta_avatar]][shweta_homepage]<br/>[Shweta Tyagi][shweta_homepage] 

  [shweta_homepage]: https://github.com/shwetatyagi-ot
  [shweta_avatar]: https://img.cloudposse.com/75x75/https://github.com/shwetatyagi-ot.png

  
[![aashutosh][aashutosh_avatar]][aashutosh_homepage]<br/>[Aashutosh][aashutosh_homepage] 

  [aashutosh_homepage]: https://https://github.com/aashutoshvats
  [aashutosh_avatar]: https://img.cloudposse.com/70x70/http://github.com/aashutoshvats.png