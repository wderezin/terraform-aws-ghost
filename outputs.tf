
output cluster_info {
  value = {
    database_host     = aws_rds_cluster.default.endpoint
    database_port     = aws_rds_cluster.default.port
    database_name     = aws_rds_cluster.default.database_name
    database_username = aws_rds_cluster.default.master_username
    database_password = aws_rds_cluster.default.master_password
    subnet_ids        = local.subnet_ids
  }
}

output database_info {
  value = {
    host     = aws_rds_cluster.default.endpoint
    port     = aws_rds_cluster.default.port
    name     = aws_rds_cluster.default.database_name
    username = aws_rds_cluster.default.master_username
    password = aws_rds_cluster.default.master_password
  }
}

output database_endpoint {
  value = aws_rds_cluster.default.endpoint
}

output database_port {
  value = aws_rds_cluster.default.port
}

output database_name {
  value = aws_rds_cluster.default.database_name
}

output database_username {
  value = aws_rds_cluster.default.master_username
}

output database_password {
  sensitive = true
  value     = aws_rds_cluster.default.master_password
}