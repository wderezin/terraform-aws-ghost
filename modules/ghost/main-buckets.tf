
resource aws_s3_bucket cms {
  bucket = local.cms_bucket_name

  force_destroy = true
  tags          = local.tags

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id                                     = "auto-delete-after-30-days"
    prefix                                 = ""
    enabled                                = true
    abort_incomplete_multipart_upload_days = 1

    noncurrent_version_expiration {
      days = 30
    }
  }
}

resource aws_s3_bucket web {
  bucket = local.web_bucket_name

  force_destroy = true
  tags          = local.tags

  versioning {
    //    No need to version as it can be reproduced from the CMS
    enabled = false
  }
}

resource aws_s3_bucket_public_access_block access {
  depends_on = [aws_s3_bucket.cms, aws_s3_bucket.web]

  for_each = local.buckets
  bucket   = each.value

  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
}

data aws_iam_policy_document web {
  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.web.arn}"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.default.iam_arn]
    }
  }

  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.web.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.default.iam_arn]
    }
  }
}

resource aws_s3_bucket_policy web {
  bucket = aws_s3_bucket.web.id
  policy = data.aws_iam_policy_document.web.json
}