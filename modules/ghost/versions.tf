terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    mysql = {
      source = "terraform-providers/mysql"
    }
  }
  required_version = ">= 0.13"
}

data aws_caller_identity current {}
data aws_region current {}
