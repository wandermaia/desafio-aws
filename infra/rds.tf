resource "aws_db_instance" "db-mysql" {
  identifier        = "rds-msql-${var.environment}"
  allocated_storage = 10
  db_name           = "mydb"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t4g.micro"
  username          = "seuUsuarioAqui"
  password          = "suaSenhaAqui"

  vpc_security_group_ids = [module.security_group_mysql.security_group_id]
  db_subnet_group_name   = module.vpc.database_subnet_group

  skip_final_snapshot = true

  tags = local.tags
}



#https://github.com/terraform-aws-modules/terraform-aws-rds/blob/v1.14.0/examples/complete-postgres/main.tf

# https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest
# 
# https://github.com/terraform-aws-modules/terraform-aws-rds/blob/master/examples/complete-mysql/main.tf

# https://spacelift.io/blog/terraform-aws-rds

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance