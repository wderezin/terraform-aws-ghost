
data aws_region default {}
data aws_availability_zones default {}

locals {
  //  Make sure these are set
  cluster   = var.cluster
  version   = "57"
  base_name = "${local.cluster}-${local.version}"

  tags = merge(
    //    Default Tag Values
    {
      managed-by : "terraform",
      Application : "daringway/content-infrastructure"
    },
    //    User Tag Value
    var.tags,
    //    Fixed tags for module
    {
      Name : local.base_name
      Cluster : local.cluster,
      Version : local.version
      Function : "shared",
    }
  )

  database_tags = merge(local.tags, { Function : "database" })

  vpc_id            = var.network_info.vpc_id
  cidr_blocks       = var.network_info.cidr_blocks
  subnet_ids        = var.network_info.subnet_ids
  security_group_is = concat(var.network_info.security_group_is, [aws_security_group.rds.id])

  password_change_id = var.password_change_id

  seconds_until_auto_pause = var.seconds_until_auto_pause
  max_database_units       = var.max_database_units

  enable_ghost_count     = var.enable_ghost ? 1 : 0
  ghost_application_name = var.ghost_application_name

}