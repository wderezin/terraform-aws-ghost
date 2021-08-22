
resource "aws_route53_record" "cms" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = local.cms_fqdn
  type    = "A"
  ttl     = 60

  //  We only want to setup the DNS record
  //  It will be updated by ghost-serverless
  records = [
    "127.0.0.1"
  ]

  lifecycle {
    ignore_changes = [records, ttl]
  }
}

data "aws_ami" "default" {
  most_recent = true
  name_regex  = "daringway-ghost-*"
  owners      = ["self"]

  filter {
    name   = "is-public"
    values = ["true"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_launch_template" "default" {
  name     = local.base_name
  image_id = data.aws_ami.default.id

  //  instance_market_options {
  //    market_type = "spot"
  //    spot_options {
  //      spot_instance_type = persistent
  //      instance_interruption_behavior = "stop"
  //    }
  //  }

  instance_type = "t3a.micro"

  //  disable_api_termination = true
  update_default_version = true

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = local.subnet_ids[0]
    security_groups             = local.security_groups
  }

  instance_initiated_shutdown_behavior = "terminate"

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags          = local.ec2_tags
  }

}


resource "aws_iam_instance_profile" "ec2_profile" {
  name = local.instance_profile_name
  role = aws_iam_role.ec2_role.name
}

data "aws_iam_policy_document" "ec2_assume_policy_document" {
  version = "2012-10-17"

  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = local.instance_profile_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_policy_document.json
  tags               = local.tags
}

data "aws_iam_policy_document" "ec2_access_policy_document" {
  version = "2012-10-17"

  statement {
    //      Needed by (acme.sh)
    effect = "Allow"
    actions = [
      "route53:ListHostedZones"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      //      Update IP Address and TLS (acme.sh)
      "route53:ChangeResourceRecordSets",
      //      Needed by (acme.sh)
      "route53:GetHostedZone",
      "route53:ListResourceRecordSets"
    ]
    resources = [
      "arn:aws:route53:::hostedzone/${data.aws_route53_zone.zone.id}"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "cloudfront:CreateInvalidation"
    ]
    resources = [
      aws_cloudfront_distribution.www.arn
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:List*"
    ]
    resources = [
      aws_s3_bucket.cms.arn,
      aws_s3_bucket.web.arn
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject*",
      "s3:GetObject*",
      "s3:DeleteObject*",
      "s3:AbortMultipartUpload",
      "s3:List*",
    ]
    resources = [
      "${aws_s3_bucket.cms.arn}/*",
      "${aws_s3_bucket.web.arn}/*"

    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "rds:DescribeDBClusters",
      "rds:ModifyCurrentDBClusterCapacity"
    ]
    resources = [
      var.cluster_info.database_arn
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeTags"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
      "ssm:DescribePrameters"
    ]
    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter${local.parameter_prefix}*",
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/global/*"
    ]
  }
}

resource "aws_iam_role_policy" "ec2_access_policy" {
  name   = "access_policy"
  role   = aws_iam_role.ec2_role.id
  policy = data.aws_iam_policy_document.ec2_access_policy_document.json
}
