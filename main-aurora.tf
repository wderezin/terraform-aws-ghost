
resource "aws_db_subnet_group" "default" {
  name       = local.base_name
  subnet_ids = local.subnet_ids

  tags = merge(local.database_tags, { Function : "network" })
}

resource "random_password" "adminpassword" {
  for_each = toset([local.password_change_id])
  length   = 32
  special  = false
}

resource "aws_rds_cluster_parameter_group" "enhanced" {
  name   = local.base_name
  family = "aurora-mysql5.7"
  tags   = local.database_tags

  parameter {
    name  = "innodb_file_format"
    value = "BARRACUDA"
  }

  parameter {
    name  = "innodb_large_prefix"
    value = "1"
  }
}

resource "aws_rds_cluster" "default" {
  cluster_identifier = local.base_name
  engine             = "aurora-mysql"
  engine_mode        = "serverless"
  engine_version     = "5.7.mysql_aurora.2.07.1"
  tags               = local.database_tags

  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.enhanced.id

  skip_final_snapshot       = false
  final_snapshot_identifier = "${local.base_name}-final"

  db_subnet_group_name = aws_db_subnet_group.default.name

  vpc_security_group_ids = [aws_security_group.rds.id]

  master_username         = "masteradmin"
  master_password         = random_password.adminpassword[local.password_change_id].result
  backup_retention_period = 5
  preferred_backup_window = "01:00-05:00"
  storage_encrypted       = true

  scaling_configuration {
    auto_pause               = true
    min_capacity             = 1
    max_capacity             = local.max_database_units
    seconds_until_auto_pause = local.seconds_until_auto_pause
    timeout_action           = "RollbackCapacityChange"
  }
}

resource "aws_security_group" "rds" {
  name        = "${local.base_name}-rds"
  description = "Allow SQL"
  vpc_id      = local.vpc_id

  tags = merge(local.tags, { Name = "${local.base_name}-database" })

  ingress {
    # MYSQL Port
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = local.cidr_blocks
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = local.cidr_blocks
  }
}
