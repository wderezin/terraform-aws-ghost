
data aws_region current {}

data aws_caller_identity current {}

locals {
  //  project_name = "ghost-${var.project_id}"
  //  global_name  = "ghost-${var.project_id}-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  //  ssm_prefix = "/project/${var.project_id}/ghost/"

  application = var.application

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

  base_name = "${local.application}"

  //  ***** Network Settings
  //  vpc_id     = var.infrastructure_info.vpc_id
  //  subnet_ids = var.infrastructure_info.subnet_ids

  //  ***** DNS Settings
  enable_root_domain_count = var.enable_root_domain ? 1 : 0

  cloudfront_aliases = var.enable_root_domain ? [local.www_fqdn, local.dns_zone_name] : [local.www_fqdn]

  dns_zone_name = var.dns_zone_name
  www_hostname  = var.web_hostname
  cms_hostname  = var.cms_hostname
  www_fqdn      = "${var.web_hostname}.${var.dns_zone_name}"
  cms_fqdn      = "${var.cms_hostname}.${var.dns_zone_name}"

  //  ***** CLOUDFRONT main-cloudfront.tf
  acm_cert_arn = var.acm_cert_arn

  database_name     = "ghost_${local.base_name}"
  database_username = "ghost_${substr(strrev(local.base_name), 0, 10)}"

  //  s3_bucket_name = "${local.cluster}-ghost-${local.base_name}-${data.aws_caller_identity.current.account_id}"

  viewer_request_lambda_arns = var.viewer_request_lambda_arns
}