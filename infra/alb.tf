# ALB para ser utilizado com o CDN
resource "aws_lb" "proxy" {

  depends_on = [
    module.vpc
  ]

  name               = "cdn-app-alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.security_group_alb_cdn.security_group_id]
  subnets            = module.vpc.public_subnets
  tags = merge(local.tags, {
    Name = "cdn-app-alb-${var.environment}"
  })
}


# Listener que será associado com os ingress das aplicações do eks
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.proxy.id
  port              = 80
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      message_body = "Unauthorised"
      status_code  = 401
    }
  }
}

