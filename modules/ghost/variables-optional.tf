
variable instance_size {
  type        = string
  default     = "small"
  description = "Size of the instance in the t2, t3, and t3a class"
}

variable web_hostname {
  type        = string
  default     = "www"
  description = "The public hostname such as www in www.acme.com"
}

variable cms_hostname {
  type        = string
  default     = "ghost"
  description = "The ghost management server hostname such as cms in www.acme.com"
}

variable enable_root_domain {
  type        = bool
  default     = true
  description = "Create root domain DNS record.  Will be redirected to web_hostname"
}

variable viewer_request_lambda_arn {
  type        = string
  default     = null
  description = "A lambda@edge cloudfront view-requests"
}

variable smtp_user {
  type        = string
  default     = null
  description = "smtp user in the ghost config"
}

variable smtp_password {
  type        = string
  default     = null
  description = "smtp user password in the ghost config"
}

variable inactive_seconds {
  type        = number
  default     = 3600
  description = "Number of seconds until ghost CMS is considered inactive and stops"
}

variable ghost_api_key {
  type = string
  default = null
  description = "Ghost API Key to push serverless ghostHunt"
}
