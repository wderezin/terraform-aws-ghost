
variable tags {
  type = map(string)
}

variable dns_zone_name {
  type = string
}

variable acm_cert_arn {
  type        = string
  description = "Override the default certification of *.DOMAIN"
}

variable application {
  type        = string
  description = "Application Id Name"
}

variable cluster_info {
  type = object({
    database_host = string,
    database_port = string,
    subnet_ids : list(string)
    security_groups : list(string
    //    log_bucket_name : string
  })
}
