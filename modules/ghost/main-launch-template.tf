
resource aws_route53_record cms {
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

  instance_market_options {
    market_type = "spot"
//    spot_options {
//      spot_instance_type = one-time
//    }
  }

  instance_type = "t3a.micro"

//  disable_api_termination = true
  update_default_version  = true

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = local.subnet_ids[0]
    security_groups             = local.security_groups
  }

  user_data = filebase64("${path.module}/install.sh")

  instance_initiated_shutdown_behavior = "terminate"

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags          = local.ec2_tags
  }

}