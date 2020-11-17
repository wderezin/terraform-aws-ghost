
locals {
  //  project_name = "ghost-${var.project_id}"
  //  global_name  = "ghost-${var.project_id}-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"

  application = var.application
  // ssm
  parameter_prefix = "/application/${local.application}/"

  tags = merge(
    //    Default Tag Values
    {
      managed-by : "terraform",
    },
    //    User Tag Value
    var.tags,
    //    Fixed tags for module
    {
      Application : local.application,
    }
  )

  ec2_tags = merge({
    Application : var.application
    backup : "default"
    },
    local.tags,
    {
      Name : var.application
      SSHUSER : "ubuntu",
      SSM_PREFIX : local.parameter_prefix
    }
  )

  base_name = local.application

  //  ***** Network Settings
  vpc_id          = var.cluster_info.vpc_id
  subnet_ids      = var.cluster_info.subnet_ids
  security_groups = var.cluster_info.security_groups


  //  ***** DNS Settings
  enable_root_domain_count = var.enable_root_domain ? 1 : 0

  cloudfront_aliases = var.enable_root_domain ? [local.www_fqdn, local.dns_zone_name] : [local.www_fqdn]

  inactive_seconds = var.inactive_seconds

  dns_zone_name = var.dns_zone_name
  www_hostname  = var.web_hostname
  cms_hostname  = var.cms_hostname
  www_fqdn      = "${var.web_hostname}.${var.dns_zone_name}"
  cms_fqdn      = "${var.cms_hostname}.${var.dns_zone_name}"

  cms_bucket_name = "${replace(local.application, "_", "-")}-ghost-${data.aws_caller_identity.current.account_id}"
  web_bucket_name = "${replace(local.application, "_", "-")}-website-${data.aws_caller_identity.current.account_id}"

  buckets               = toset([local.cms_bucket_name, local.web_bucket_name])
  instance_profile_name = local.cms_fqdn

  //  ***** CLOUDFRONT main-cloudfront-s3.tf
  acm_cert_arn = var.acm_cert_arn

  database_name     = "ghost_${local.base_name}"
  database_username = "ghost_${substr(strrev(local.base_name), 0, 10)}"
  database_password = "abc123"

  smtp_user     = var.smtp_user
  smtp_password = var.smtp_password

  database_host = var.cluster_info.database_host
  database_port = var.cluster_info.database_port

  use_default_request_lambda = var.viewer_request_lambda_arn == null
  viewer_request_lambda_arn  = local.use_default_request_lambda ? [module.default-cloudfront-s3-viewer-request-lambda[0].qualified_arn] : [var.viewer_request_lambda_arn]
}