
resource aws_ssm_parameter db_name {
  name        = "${local.parameter_prefix}/db_name"
  description = "Ghost Database Name"
  type        = "String"
  value       = mysql_database.db.name
}
resource aws_ssm_parameter db_user {
  name        = "${local.parameter_prefix}/db_user"
  description = "Ghost Database User"
  type        = "String"
  value       = mysql_user.ghost.user
}
resource aws_ssm_parameter db_password {
  name        = "${local.parameter_prefix}/db_password"
  description = "Ghost Database User Password"
  type        = "SecureString"
  value       = mysql_user.ghost.password
}
resource aws_ssm_parameter db_host {
  name        = "${local.parameter_prefix}/db_host"
  description = "Ghost Database Host"
  type        = "String"
  value       = mysql_user.ghost.password
}

output database_info {
  value = {
    DATABASE_NAME = mysql_database.db.name
    DATABASE_USER = mysql_user.ghost.user
  }
}