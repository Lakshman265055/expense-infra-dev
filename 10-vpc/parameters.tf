resource "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.Environment}/vpc_id"
  type = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "public_subnet_id" {
  name = "/${var.project_name}/${var.Environment}/public_subnet_ids"
  type = "StringList"
  value = join(",", module.vpc.public_subnet_ids)
}

resource "aws_ssm_parameter" "private_subnet_id" {
  name = "/${var.project_name}/${var.Environment}/private_subnet_ids"
  type = "StringList"
  value = join(",", module.vpc.private_subnet_ids)
}

resource "aws_ssm_parameter" "database_subnet_id" {
  name = "/${var.project_name}/${var.Environment}/database_subnet_ids"
  type = "StringList"
  value = join(",", module.vpc.database_subnet_ids)
}

resource "aws_ssm_parameter" "database_subnet_group_name" {
  name = "/${var.project_name}/${var.Environment}/database_subnet_group_name"
  type = "String"
  value = module.vpc.database_subnet_group_name
}