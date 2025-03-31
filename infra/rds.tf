# RDS que será utilizado pela aplicação
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

  # tags = local.tags
  tags = merge(local.tags, {
    Name = "rds-msql-${var.environment}"
  })
}

