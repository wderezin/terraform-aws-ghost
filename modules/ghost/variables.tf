
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

variable smtp_user {
  type = strint
  description = "smtp user in the ghost config"
}

variable smtp_password {
  type = strint
  description = "smtp user password in the ghost config"
}


//variable infrastructure_info {
//  type = object({
//    vpc_id : string
//    subnet_ids : list(string)
//    log_bucket_name : string
//  })
//}