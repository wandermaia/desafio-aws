# Zona privada para testes da aplicação
resource "aws_route53_zone" "private" {
  #name = "wandermaia.com"
  name = "wandermaia.com"

  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

resource "aws_route53_record" "teste-dns" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "teste.wandermaia.com"
  type    = "A"
  ttl     = 300
  records = ["192.168.56.110"]
}


# CNAME que será associado com o RDS do mysql
resource "aws_route53_record" "dns-mysql" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "mysql-${var.environment}.wandermaia.com"
  type    = "CNAME"
  ttl     = 300
  records = ["${aws_db_instance.db-mysql.address}"]
}


# CNAME que será associado com a API
resource "aws_route53_record" "dns-calculadora-api" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "calculadora-api-${var.environment}.wandermaia.com"
  type    = "CNAME"
  ttl     = 300
  records = ["${aws_lb.proxy.dns_name}"]
}


# CNAME que será associado com o Frontend
resource "aws_route53_record" "dns-magic-calculator" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "magic-calculator-${var.environment}.wandermaia.com"
  type    = "CNAME"
  ttl     = 300
  records = ["${aws_lb.proxy.dns_name}"]
}