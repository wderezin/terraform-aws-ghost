
variable tags {
  type = map(string)
}

variable application {
  type        = string
  description = "Application Id Name"
}

//variable infrastructure_info {
//  type = object({
//    vpc_id : string
//    subnet_ids : list(string)
//    log_bucket_name : string
//  })
//}