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

variable "app_alb_tags" {
  default = {
    component = "app-alb"
  }

}

variable "zone_id" {
    default = "Z0273878MO51HBY4V78N"
}
