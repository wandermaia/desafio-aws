# resource "aws_route53_zone" "private" {
#   name = "wandermaia.com"

#   vpc {
#     vpc_id = module.vpc.vpc_id
#   }
# }

# resource "aws_route53_record" "teste" {
#   zone_id = aws_route53_zone.private.zone_id
#   name    = "teste.wandermaia.com"
#   type    = "A"
#   ttl     = 300
#   records = ["192.168.56.110"]
# }


# resource "aws_route53_record" "teste-cname" {
#   zone_id = aws_route53_zone.private.zone_id
#   name    = "private-CNAME.wandermaia.com"
#   type    = "CNAME"
#   ttl     = 300
#   records = ["dev.wandermaia.com"]
# }

# resource "aws_route53_record" "dns-mysql" {
#   zone_id = aws_route53_zone.private.zone_id
#   name    = "mysql-${var.environment}.wandermaia.com"
#   type    = "CNAME"
#   ttl     = 300
#   records = ["${aws_db_instance.db-mysql.address}"]
# }

