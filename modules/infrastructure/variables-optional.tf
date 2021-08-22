
variable "seconds_until_auto_pause" {
  type        = number
  default     = 1200
  description = "Number of seconds to pause database when there are no connections"
}

variable "max_database_units" {
  type        = number
  default     = 8
  description = "Max number aurora serverles database units"
}

variable "password_change_id" {
  type        = string
  default     = "1"
  description = "Id to trigger changing the master password"
}

variable "enable_ghost" {
  type        = bool
  default     = false
  description = "Enable support for ghost CMS sub module"
}

variable "ghost_application_name" {
  type        = string
  default     = "ghost"
  description = "Default application tag"
}