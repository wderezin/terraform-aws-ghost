
resource aws_s3_bucket cms {
  bucket = local.cms_bucket_name

  force_destroy = false
  tags          = local.tags

  versioning {
    enabled = true
  }
}

resource aws_s3_bucket web {
  bucket = local.web_bucket_name

  force_destroy = true
  tags          = local.tags

  versioning {
    enabled = true
  }
}

resource aws_s3_bucket_public_access_block access {
  for_each = [aws_s3_bucket.web.id, aws_s3_bucket.cms.id]
  bucket   = each.value

  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
}
