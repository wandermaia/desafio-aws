module "security_group_mysql" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = local.name
  description = "MySQL security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "Acesso ao MySQL das subnet privada 1"
      #cidr_blocks = "${module.vpc.private_subnets_cidr_blocks}"
      cidr_blocks = element(module.vpc.private_subnets_cidr_blocks, 0)
    },
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "Acesso ao MySQL das subnet privada 2"
      #cidr_blocks = "${module.vpc.private_subnets_cidr_blocks}"
      cidr_blocks = element(module.vpc.private_subnets_cidr_blocks, 1)
    },
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "Acesso ao MySQL das subnet privada 3"
      #cidr_blocks = "${module.vpc.private_subnets_cidr_blocks}"
      cidr_blocks = element(module.vpc.private_subnets_cidr_blocks, 2)
    }
  ]

  tags = local.tags
}



resource "aws_security_group" "security_group_ec2" {

  name        = "security_group_ec2"
  description = "security group para teste ec2"

  vpc_id = module.vpc.vpc_id

  #   subnet_id     = element(module.vpc.private_subnets_cidr_blocks, 0)

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


