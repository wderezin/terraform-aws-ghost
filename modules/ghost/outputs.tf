
resource aws_ssm_parameter db_connection {
  name        = "${local.parameter_prefix}/db_connection"
  description = "Ghost Database Host"
  type        = "String"
  value       = mysql_database.db.connection
}

resource aws_ssm_parameter db_name {
  name        = "${local.parameter_prefix}/db_name"
  description = "Ghost Database Name"
  type        = "String"
  value       = local.database_name
  tags        = local.tags
}

resource aws_ssm_parameter db_user {
  name        = "${local.parameter_prefix}/db_user"
  description = "Ghost Database User"
  type        = "String"
  value       = local.database_username
  tags        = local.tags
}

resource aws_ssm_parameter db_password {
  name        = "${local.parameter_prefix}/db_password"
  description = "Ghost Database User Password"
  type        = "SecureString"
  value       = local.database_password
  tags        = local.tags
}

resource aws_ssm_parameter smtp_user {
  name        = "${local.parameter_prefix}/smtp_user"
  description = "Ghost SMTP User"
  type        = "String"
  value       = local.smtp_user
  tags        = local.tags
}

resource aws_ssm_parameter smpt_password {
  name        = "${local.parameter_prefix}/smtp_password"
  description = "Ghost SMTP User Password"
  type        = "SecureString"
  value       = local.smtp_password
  tags        = local.tags
}

resource aws_ssm_parameter database_host {
  name        = "${local.parameter_prefix}/database_host"
  description = "Database Host"
  type        = "String"
  value       = local.database_host
  tags        = local.tags
}

resource aws_ssm_parameter database_port {
  name        = "${local.parameter_prefix}/database_port"
  description = "Database Port"
  type        = "String"
  value       = local.database_port
  tags        = local.tags
}