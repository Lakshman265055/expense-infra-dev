variable "project_name" {
  default = "expense"
}

variable "environment" {
  default = "dev"

}

variable "common_tags" {
  default = {
    project     = "expense"
    terraform   = "true"
    Environment = "Dev"
  }

}

variable "rds_tags" {
  default = {
    component = "mysql"
  }

}

variable "zone_id" {
    default = "Z0273878MO51HBY4V78N"
}
