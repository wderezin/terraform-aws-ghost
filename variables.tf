
variable "tags" {
  type = map(string)
}

variable "network_info" {
  type = object({
    vpc_id             = string
    cidr_blocks        = list(string)
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
}

variable "cluster" {
  type        = string
  description = "Cluster name"
}

