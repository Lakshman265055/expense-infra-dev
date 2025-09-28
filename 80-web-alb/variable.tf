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

variable "web_alb_tags" {
  default = {
    component = "web-alb"
  }

}

variable "zone_id" {
    default = "Z0273878MO51HBY4V78N"
}
