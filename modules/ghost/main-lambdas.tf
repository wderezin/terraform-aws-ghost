
module default-cloudfront-s3-viewer-request-lambda {
  count = local.use_default_request_lambda ? 1 : 0

  source               = "daringway/cloudfront-viewer-request-lambda/aws"
  version              = "1.2.2"
  tags                 = local.tags
  lambda_name          = "${local.application}-website-viewer_request"
  apex_domain_redirect = true
  index_rewrite        = var.cdn_mode == "static"
  append_slash         = true
//  ghost_hostname       = local.cms_fqdn
}
