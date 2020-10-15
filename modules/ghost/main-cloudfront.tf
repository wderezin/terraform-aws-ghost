
data aws_route53_zone zone {
  name         = local.dns_zone_name
  private_zone = false
}

locals {
  cms_origin_id = "ghostOrigin"
}

resource aws_cloudfront_distribution www {
  enabled = true
  comment = local.base_name

  aliases = local.cloudfront_aliases

  viewer_certificate {
    acm_certificate_arn      = local.acm_cert_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  origin {
    domain_name = local.cms_fqdn
    origin_id   = local.cms_origin_id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = [
        "TLSv1",
        "TLSv1.1",
        "TLSv1.2"
      ]
    }
    custom_header {
      name  = "X-Forwarded-Host"
      value = local.www_fqdn
    }
    custom_header {
      name  = "X-Forwarded-Proto"
      value = "https"
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.cms_origin_id

    forwarded_values {
      query_string = false
      headers = [
        "Origin"
      ]
      cookies {
        forward = "none"
      }
    }

    dynamic lambda_function_association {
      for_each = local.viewer_request_lambda_arns
      content {
        event_type   = "viewer-request"
        lambda_arn   = lambda_function_association.value
        include_body = false
      }
    }

    min_ttl                = 0
    default_ttl            = 30
    max_ttl                = 60
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  dynamic ordered_cache_behavior {
    for_each = [
      "/content/*",
      "/assets/*"
    ]
    content {
      path_pattern     = ordered_cache_behavior.value
      allowed_methods  = ["GET", "HEAD", "OPTIONS"]
      cached_methods   = ["GET", "HEAD", "OPTIONS"]
      target_origin_id = local.cms_origin_id

      forwarded_values {
        query_string = true
        headers = [
          "Origin",
        ]

        cookies {
          forward = "all"
        }
      }

      dynamic lambda_function_association {
        for_each = local.viewer_request_lambda_arns
        content {
          event_type   = "viewer-request"
          lambda_arn   = lambda_function_association.value
          include_body = false
        }
      }

      //    3600 1 hour 86400 is 1 day and 604800 is 1 week
      min_ttl                = 86400
      default_ttl            = 604800
      max_ttl                = 31536000
      compress               = true
      viewer_protocol_policy = "redirect-to-https"
    }
  }

  ordered_cache_behavior {
    path_pattern = [
      "/ghost/*",
      "/*/api/*"
    ]
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["HEAD", "GET"]
    target_origin_id = local.cms_origin_id

    forwarded_values {
      query_string = true
      //      query_string_cache_keys = []
      headers = [
        "Origin",
      ]

      cookies {
        forward = "all"
      }
    }

    dynamic lambda_function_association {
      for_each = local.viewer_request_lambda_arns
      content {
        event_type   = "viewer-request"
        lambda_arn   = lambda_function_association.value
        include_body = false
      }
    }

    //    3600 1 hour 86400 is 1 day and
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }
}

resource aws_route53_record ghost {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = local.www_hostname
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.www.domain_name
    zone_id                = aws_cloudfront_distribution.www.hosted_zone_id
    evaluate_target_health = true
  }
}

resource aws_route53_record root {
  count = local.enable_root_domain_count

  zone_id = data.aws_route53_zone.zone.zone_id
  name    = data.aws_route53_zone.zone.name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.www.domain_name
    zone_id                = aws_cloudfront_distribution.www.hosted_zone_id
    evaluate_target_health = true
  }
}

