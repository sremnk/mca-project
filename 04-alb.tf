
# Find a certificate that is issued
data "aws_acm_certificate" "issued" {
  domain   = "*.kumoc.com"
  statuses = ["ISSUED"]
}


module "alb" {
  source = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"
  name =  "web-alb"
  load_balancer_type = "application"
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  security_groups = [module.lb_sg.security_group.id]
  https_listeners = [
      {
          port = 443,
          protocol = "HTTPS"
          certificate_arn    = data.aws_acm_certificate.issued.arn
          target_group_index = 0
      }
  ]

  target_groups = [
      {
          name_prefix = "tgroup",
          backend_protocol = "HTTP",
          backend_port = 8000
          target_type = "instance"
          health_check = {
            enabled             = true
            interval            = 30
            path                = "/"
            port                = 8000
            healthy_threshold   = 3
            unhealthy_threshold = 3
            timeout             = 6
            protocol            = "HTTP"
            matcher             = "200-399"
        }
      }
  ]
}