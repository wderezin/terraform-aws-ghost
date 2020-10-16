locals {

  name = "ghost_cms_server"

  tags = merge({
    Application : var.application
    backup : "default"
    },
    var.tags,
    {
      SSHUSER : "ubuntu"
    }
  )

}