
data aws_ami default {
  most_recent = true
  name_regex  = "^daringway-ghost-*"
  owners      = ["705630809193"]

  filter {
    name   = "is-public"
    values = ["true"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data aws_iam_policy_document ghost_ssm {
  statement {
    effect = "Allow"
    actions = [
      "ssm:DescribeParameters"
    ]
    resources = "*"
  }
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParametersByPath",
      "ssm:GetParameters",
      "ssm:GetParameter",
    ]
    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter${local.parameter_prefix}/*"
    ]
  }
}

data aws_iam_policy_document ghost_assume {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource aws_iam_role ghost {
  name = local.base_name
  path = "/"
  tags = local.tags
  assume_role_policy = data.aws_iam_policy_document.ghost_assume.json
}

resource aws_iam_role_policy policy {
  name = "ssm-policy"
  policy = data.aws_iam_policy_document.ghost_ssm.json
  role = aws_iam_role.ghost.id
}

  resource aws_iam_instance_profile ghost {
  name = local.base_name
  role = aws_iam_role.ghost.name
}

resource aws_launch_template default {
  name          = local.base_name
  image_id      = data.aws_ami.default.id
  instance_type = "t3a.micro"

  disable_api_termination = true

    iam_instance_profile {
      name = aws_iam_instance_profile.ghost.name
    }

  instance_initiated_shutdown_behavior = "stop"
  //  instance_initiated_shutdown_behavior = "terminate"

  //  vpc_security_group_ids = [
  //    aws_security_group.instance.id
  //  ]

  //  network_interfaces {
  //    associate_public_ip_address = true
  //    subnet_id = data.aws_subnet_ids.all.ids[0]
  ////    security_groups = [
  ////      data.aws_subnet_ids.
  ////    ]
  //  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags          = local.tags
  }

}