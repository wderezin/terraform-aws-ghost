
output "cluster" {
  value = aws_rds_cluster.default
}

output "database_arn" {
  value = aws_rds_cluster.default.arn
}

output "database_host" {
  value = aws_rds_cluster.default.endpoint
}

output "database_port" {
  value = aws_rds_cluster.default.port
}

output "database_name" {
  value = aws_rds_cluster.default.database_name
}

output "database_username" {
  value = aws_rds_cluster.default.master_username
}

output "database_password" {
  sensitive = true
  value     = aws_rds_cluster.default.master_password
}

output "vpc_id" {
  value = local.vpc_id
}

output "subnet_ids" {
  value = local.subnet_ids
}

output "security_groups" {
  value = local.security_group_ids
}

output "database_endpoint" {
  value = aws_rds_cluster.default.endpoint
}
