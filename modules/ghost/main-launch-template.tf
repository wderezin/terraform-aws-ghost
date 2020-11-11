
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

resource aws_launch_template default {
  name          = local.base_name
  image_id      = data.aws_ami.default.id
  instance_type = "t3a.micro"

  disable_api_termination = true
  update_default_version  = true

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
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
    tags          = local.ec2_tags
  }

}