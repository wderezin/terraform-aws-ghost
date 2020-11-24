
resource aws_ssm_parameter database_host {
  name        = "${local.parameter_prefix}database_host"
  description = "Database Host"
  type        = "String"
  value       = local.database_host
  tags        = local.tags
}

resource aws_ssm_parameter database_port {
  name        = "${local.parameter_prefix}database_port"
  description = "Database Port"
  type        = "String"
  value       = local.database_port
  tags        = local.tags
}

resource aws_ssm_parameter database_name {
  name        = "${local.parameter_prefix}database_name"
  description = "Ghost Database Name"
  type        = "String"
  value       = local.database_name
  tags        = local.tags
}

resource aws_ssm_parameter database_user {
  name        = "${local.parameter_prefix}database_user"
  description = "Ghost Database User"
  type        = "String"
  value       = local.database_username
  tags        = local.tags
}

resource aws_ssm_parameter database_password {
  name        = "${local.parameter_prefix}database_password"
  description = "Ghost Database User Password"
  type        = "SecureString"
  value       = local.database_password
  tags        = local.tags
}

resource aws_ssm_parameter smtp_user {
  count       = local.smtp_user != null ? 1 : 0
  name        = "${local.parameter_prefix}smtp_user"
  description = "Ghost SMTP User"
  type        = "String"
  value       = local.smtp_user
  tags        = local.tags
}

resource aws_ssm_parameter smpt_password {
  count       = local.smtp_password != null ? 1 : 0
  name        = "${local.parameter_prefix}smtp_password"
  description = "Ghost SMTP User Password"
  type        = "SecureString"
  value       = local.smtp_password
  tags        = local.tags
}

resource aws_ssm_parameter web_hostname {
  name        = "${local.parameter_prefix}web_hostname"
  description = "the http name of the website"
  type        = "String"
  value       = local.www_fqdn
  tags        = local.tags
}

resource aws_ssm_parameter cms_hostname {
  name        = "${local.parameter_prefix}cms_hostname"
  description = "the http name of the website"
  type        = "String"
  value       = local.cms_fqdn
  tags        = local.tags
}

resource aws_ssm_parameter cloudfront_id {
  name        = "${local.parameter_prefix}cloudfront_id"
  description = "The Cloudfront distribution id"
  type        = "String"
  value       = aws_cloudfront_distribution.www.id
  tags        = local.tags
}

resource aws_ssm_parameter web_bucket {
  name        = "${local.parameter_prefix}web_bucket"
  description = "the S3 bucket for the static website"
  type        = "String"
  value       = aws_s3_bucket.web.bucket
  tags        = local.tags
}

resource aws_ssm_parameter cms_bucket {
  name        = "${local.parameter_prefix}cms_bucket"
  description = "the S3 bucket for CMS backups"
  type        = "String"
  value       = aws_s3_bucket.cms.bucket
  tags        = local.tags
}

resource aws_ssm_parameter inactive_seconds {
  name        = "${local.parameter_prefix}inactive_seconds"
  description = "Number of seconds until CMS is considered inactive before stopping"
  type        = "String"
  value       = local.inactive_seconds
  tags        = local.tags
}

resource aws_ssm_parameter zone_id {
  name        = "${local.parameter_prefix}zone_id"
  description = "the zone id for DNS"
  type        = "String"
  value       = data.aws_route53_zone.zone.id
  tags        = local.tags
}

resource aws_ssm_parameter ghost_api_key {
  count = local.ghost_api_key != null ? 1 : 0
  name        = "${local.parameter_prefix}ghost_api_key"
  description = "the ghost api key for serverless ghostHunter"
  type        = "SecureString"
  value       = local.ghost_api_key
  tags        = local.tags
}