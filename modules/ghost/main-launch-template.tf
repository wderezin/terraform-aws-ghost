
data aws_ami default {
  //  ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20201026 (ami-0885b1f6bd170450c)
  most_recent = true
  name_regex  = "^ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
  owners      = ["099720109477"]

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

  vpc_security_group_ids = local.security_groups
  network_interfaces {
    associate_public_ip_address = true
    subnet_id = local.subnet_ids[0]
  }

  user_data = filebase64("${path.module}/install.sh")

  instance_initiated_shutdown_behavior = "terminate"

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