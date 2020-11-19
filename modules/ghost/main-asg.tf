
resource aws_autoscaling_group ghost_server {
  name             = local.application
  min_size         = 1
  max_size         = 1
  desired_capacity = null

  lifecycle {
    ignore_changes = [desired_capacity]
  }

  //  suspended_processes = []
  //  health_check_type = "ELB"

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy                 = "lowest-price"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.default.id
        version            = "$Latest"
      }
      override {
        instance_type = "t3a.${local.instance_size}"
      }
      override {
        instance_type = "t3.${local.instance_size}"
      }
      override {
        instance_type = "t2.${local.instance_size}"
      }
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
