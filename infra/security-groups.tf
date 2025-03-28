module "security_group_mysql" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = local.security_group_name_mysql
  description = "MySQL security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "Acesso ao MySQL das subnet privada 1"
      cidr_blocks = element(module.vpc.private_subnets_cidr_blocks, 0)
    },
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "Acesso ao MySQL das subnet privada 2"
      cidr_blocks = element(module.vpc.private_subnets_cidr_blocks, 1)
    },
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "Acesso ao MySQL das subnet privada 3"
      cidr_blocks = element(module.vpc.private_subnets_cidr_blocks, 2)
    }
  ]

  tags = merge(local.tags, {
    Name = local.security_group_name_mysql
  })

}



resource "aws_security_group" "security_group_ec2" {

  name        = local.security_group_name_ec2
  description = "security group para teste ec2"

  vpc_id = module.vpc.vpc_id


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

  tags = merge(local.tags, {
    Name = local.security_group_name_ec2
  })

}


# resource "aws_security_group" "security_group_eks" {

#   name        = local.security_group_name_eks
#   description = "security group para eks, quando houver a necessidade de alguma regra personalizada"

#   vpc_id = module.vpc.vpc_id

#   ingress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = merge(local.tags, {
#     Name = local.security_group_name_eks
#   })

# }
