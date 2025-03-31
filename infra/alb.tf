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

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      message_body = "Unauthorised"
      status_code  = 401
    }
  }
}




# Target group para conectar o ALB da calculadora API
# Os IPs serão adicionados posteriormente pela execução do workflow da aplicação
resource "aws_lb_target_group" "alb-calculadora-api-tg" {
  name        = "tg-calculadora-api-${var.environment}"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id

  health_check {
    path = "/backend"
  }

  tags = merge(local.tags, {
    Name = "tg-calculadora-api-${var.environment}"
  })
}



# Target group para conectar o ALB do frontend
# Os IPs serão adicionados posteriormente pela execução do workflow da aplicação
resource "aws_lb_target_group" "alb-magic-calculator-tg" {
  name        = "tg-magic-calculator-${var.environment}"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id

  health_check {
    path = "/frontend"
  }

  tags = merge(local.tags, {
    Name = "tg-magic-calculator-${var.environment}"
  })
}




# Rule do listener para direcionar para o target group da calculadora API
resource "aws_lb_listener_rule" "rule-calculadora-api_b" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-calculadora-api-tg.arn
  }

  condition {
    path_pattern {
      values = ["/backend*"]
    }
  }
}

# Rule do listener para direcionar para o target group do frontend
resource "aws_lb_listener_rule" "rule-magic-calculator" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-magic-calculator-tg.arn
  }

  condition {
    path_pattern {
      values = ["/frontend*"]
    }
  }
}

