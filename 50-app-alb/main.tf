module "app_alb" {
  source = "terraform-aws-modules/alb/aws"
  
  internal = true
  name    = "${local.resource_name}-app-alb"
  vpc_id  = local.vcp_id
  subnets = local.private_subnet_id
  security_groups = [data.aws_ssm_parameter.app_alb_sg_id.value]
  create_security_group = false
  enable_deletion_protection = false

  tags = merge(
    var.common_tags,
    var.app_alb_tags
  )
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = module.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

 default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I am from Application ALP </h1>"
      status_code  = "200"
    }

  }
}

# resource "aws_route53_record" "frontend" {
#   zone_id = var.zone_id
#   name    = "*.app-${var.environment}"
#   type    = "A"
#   ttl     = 1
#   records = [module.app_alb.dns_name]
#   allow_overwrite = true
# }

resource "aws_route53_record" "frontend" {
  zone_id = var.zone_id
  name    = "*.app-${var.environment}"
  type    = "A"

  alias {
    name                   = module.app_alb.dns_name
    zone_id                = module.app_alb.zone_id
    evaluate_target_health = true
  }

  allow_overwrite = true
}
