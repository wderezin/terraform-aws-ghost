
variable "tags" {
  type = map(string)
}

variable "dns_zone_name" {
  type = string
}

variable "acm_cert_arn" {
  type        = string
  description = "Override the default certification of *.DOMAIN"
}

variable "application" {
  type        = string
  description = "Application Id Name"
}

variable "cdn_mode" {
  type        = string
  description = "Does the CDN use live or static."
  validation {
    condition     = contains(["live", "static"], var.cdn_mode)
    error_message = "Valid options are live or static."
  }
}

variable "cluster_info" {
  type = object({
    database_arn  = string,
    database_host = string,
    database_port = string,
    vpc_id        = string,
    subnet_ids : list(string),
    security_groups : list(string)
    //    log_bucket_name : string
  })
}
