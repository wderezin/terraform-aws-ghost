
resource aws_autoscaling_group ghost_server {
  name             = local.cluster_base_name
  min_size         = 0
  max_size         = 1
  desired_capacity = null

  lifecycle {
    ignore_changes = [desired_capacity]
  }

  vpc_zone_identifier = local.subnet_ids

  //  suspended_processes = []

  health_check_type = "ELB"

  termination_policies = [
    "AllocationStrategy",
    "OldestInstance"
  ]

  mixed_instances_policy {
//    instances_distribution {
//      on_demand_base_capacity                  = 0
//      on_demand_percentage_above_base_capacity = 0
//      spot_allocation_strategy                 = "lowest-price"
//      //      spot_max_price =
//    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.default.id
        version            = "$Latest"
      }
//      override {
//        instance_type = "t3a.small"
//      }
//      override {
//        instance_type = "t3.small"
//      }
//      override {
//        instance_type = "t2.small"
//      }
    }
  }

  tags = [
    {
      key                 = "Name"
      value               = local.base_name
      propagate_at_launch = true
    }
  ]

}
