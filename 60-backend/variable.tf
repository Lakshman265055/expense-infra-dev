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

variable "backend_tags" {
  default = {
    component = "backend"
  }

}



variable "zone_id" {
    default = "Z0273878MO51HBY4V78N"
}

variable "zone_name" {
  default = "lakshmangundapu.icu"
}