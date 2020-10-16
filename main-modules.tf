
module ghost {
  count       = local.enable_ghost_count
  source      = "./modules/global-ghost"
  tags        = local.tags
  application = var.ghost_application_name
}